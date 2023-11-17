import {setup as fetchConfiguration} from './fetch';
import {Config, EquipmentEntity} from '@labs/server';

type Geometry = {
    width: number;
    height: number;
};

type AppConfig = Config & {
    geometry: Geometry;
    connections: Map<string, number>;
};

const _config: AppConfig = {
    cell: {
        width: 20,
        height: 20,
    },
    equipment: {},
    geometry: {} as AppConfig['geometry'],
    proofOfDone: {} as AppConfig['proofOfDone'],
    connections: new Map(),
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

function connect(from: string, to: string) {
    const hash = [from, to].sort().join('#');

    const count = _config.connections.get(hash) || 0;

    _config.connections.set(hash, count + 1);
}

export {setup, size, remote, config, position, connect};
