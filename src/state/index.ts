import {setup as setupEquipment} from './configuration';
import {Configuration} from './types';

type Geometry = {
    width: number;
    height: number;
};

const config = {
    cell: {
        width: 100,
        height: 100,
    },
    geometry: {} as Geometry,
    equipment: {} as Configuration,
};

async function setup(geometry: Geometry) {
    Object.assign(config.geometry, geometry);

    const equipment = await setupEquipment();

    for (const entity of equipment) {
        config.equipment[entity.name] = entity;
    }
}

function size(xCells: number, yCells: number): Geometry {
    const {width, height} = config.cell;

    return {
        width: width * xCells,
        height: height * yCells,
    };
}

const state = {
    setup,
    size,
    config() {
        return config;
    },
};

export {state};
