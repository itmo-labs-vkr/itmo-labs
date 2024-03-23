import {BaseComponent} from 'ui';
import {setup as fetchConfiguration} from './fetch';
import {Config, EquipmentEntity} from '@labs/server';

type Geometry = {
    width: number;
    height: number;
};

type AppConfig = Config & {
    geometry: Geometry;
    connections: Map<string, number>;
    relations: Record<string, string[]>;
};

const _config: AppConfig = {
    cell: {
        width: 20,
        height: 20,
    },
    equipment: {},
    geometry: {} as AppConfig['geometry'],
    proofOfDone: {} as AppConfig['proofOfDone'],
    relations: {},
    connections: new Map(),
    entry: '',
};

function config() {
    return _config;
}

async function setup(geometry: Geometry) {
    Object.assign(_config.geometry, geometry);

    const fetched = await fetchConfiguration();

    Object.assign(_config, fetched);
}

function size(xCells: number, yCells: number): Geometry {
    const {width, height} = _config.cell;

    return {
        width: width * xCells,
        height: height * yCells,
    };
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

function connect(from: BaseComponent, to: BaseComponent) {
    const [fromType, toType] = [from.type!, to.type!];
    const [fromId, toId] = [from.id(), to.id()];

    const hash = [fromType, toType].sort().join('#');
    const count = _config.connections.get(hash) || 0;

    if (_config.relations[fromId]) {
        _config.relations[fromId].push(toId);
    } else {
        _config.relations[fromId] = [toId];
    }

    if (_config.relations[toId]) {
        _config.relations[toId].push(fromId);
    } else {
        _config.relations[toId] = [fromId];
    }

    _config.connections.set(hash, count + 1);
}

function connections(from: string, to: string) {
    const hash = [from, to].sort().join('#');

    return _config.connections.get(hash) || 0;
}

export {setup, size, remote, config, position, connect, connections};
