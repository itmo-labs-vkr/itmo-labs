import {setup as fetchConfiguration} from './configuration';
import {Config, EquipmentEntity} from '@labs/server';

type Geometry = {
    width: number;
    height: number;
};

type AppConfig = Config & {
    geometry: Geometry;
};

const _config: AppConfig = {
    cell: {
        width: 20,
        height: 20,
    },
    equipment: {},
    geometry: {} as Geometry,
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
        x: x / _config.cell.width,
        y: y / _config.cell.height,
    };
}

const state = {
    setup,
    size,
    remote,
    config,
    position,
};

export {state};
