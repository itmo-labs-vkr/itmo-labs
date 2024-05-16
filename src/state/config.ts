import {Cell, RemoteComponent} from '@labs/components';
import {setup as fetchConfiguration} from './fetch';
import {Config, EquipmentEntity} from '@labs/server';
import Konva from 'konva';

type Geometry = {
    width: number;
    height: number;
};

type AppConfig = Config & {
    geometry: Geometry;
    empty: Geometry;
    /** Record<type#type, Cell[][]> */
    connections: Map<string, Cell[][]>;
    /** Record<hash, Component> */
    relations: Record<string, RemoteComponent[]>;
    root: Konva.Layer;
    client: ReturnType<HTMLElement['getBoundingClientRect']>;
};

const _config: AppConfig = {
    cell: {
        width: 20,
        height: 20,
    },
    root: {} as Konva.Layer,
    equipment: {},
    empty: {} as AppConfig['empty'],
    geometry: {} as AppConfig['geometry'],
    proofOfDone: {} as AppConfig['proofOfDone'],
    relations: {},
    connections: new Map(),
    entry: '',
    client: {} as AppConfig['client'],
};

function config() {
    return _config;
}

async function setup(geometry: Geometry, root: Konva.Layer) {
    Object.assign(_config.geometry, geometry);

    const fetched = await fetchConfiguration();
    const client = document.getElementById('root')!.getBoundingClientRect();

    Object.assign(_config, fetched, {root, client});
}

function size(xCells: number, yCells: number): Geometry {
    const {width, height} = _config.cell;

    return {
        width: width * xCells,
        height: height * yCells,
    };
}

function set<Key extends keyof AppConfig>(key: Key, value: AppConfig[Key]) {
    _config[key] = value;
}

function remote(name: string): EquipmentEntity {
    return _config.equipment[name];
}

function position(point: Point2D): Point2D {
    const {x, y} = point;

    return {
        x: Math.floor(x / _config.cell.width),
        y: Math.floor(y / _config.cell.height),
    };
}

function connect(from: RemoteComponent, to: RemoteComponent, wire: Cell[] = []) {
    const [fromType, toType] = [from.type!, to.type!];
    const [fromId, toId] = [from.id(), to.id()];

    const hash = [fromType, toType].sort().join('#');
    const conntectedWires = _config.connections.get(hash) || [];

    if (_config.relations[fromId]) {
        _config.relations[fromId].push(to);
    } else {
        _config.relations[fromId] = [to];
    }

    if (_config.relations[toId]) {
        _config.relations[toId].push(from);
    } else {
        _config.relations[toId] = [from];
    }

    _config.connections.set(hash, [...conntectedWires, wire]);
}

function connections(from: string, to: string) {
    const hash = [from, to].sort().join('#');

    return (_config.connections.get(hash) || []).length;
}

function relations(from: string): RemoteComponent[] {
    return _config.relations[from] || [];
}

function disconnect(from: RemoteComponent, to: RemoteComponent) {
    const [fromType, toType] = [from.type!, to.type!];
    const [fromId, toId] = [from.id(), to.id()];
    const hash = [fromType, toType].sort().join('#');

    _config.relations[fromId] = _config.relations[fromId].filter((el) => el.id() !== toId);
    _config.relations[toId] = _config.relations[toId].filter((el) => el.id() !== fromId);

    const wires = _config.connections.get(hash);

    wires?.forEach((wire) => {
        wire.forEach((cell) => {
            cell.borrow(undefined);
        });
    });

    to.renderPorts();

    _config.connections.delete(hash);
}

export {setup, size, remote, config, position, connect, connections, set, relations, disconnect};
