import {setup as setupEquipment} from './configuration';
import {EquipmentEntity, Equipments} from '@labs/server';

type Geometry = {
    width: number;
    height: number;
};

const _config = {
    cell: {
        width: 20,
        height: 20,
    },
    geometry: {} as Geometry,
    equipment: {} as Equipments,
};

function config() {
    return _config;
}

async function setup(geometry: Geometry) {
    Object.assign(_config.geometry, geometry);

    const equipment = await setupEquipment();

    for (const entity of equipment) {
        _config.equipment[entity.name] = entity;
    }
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

const state = {
    setup,
    size,
    remote,
    config,
};

export {state};
