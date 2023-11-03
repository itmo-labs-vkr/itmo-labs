import {EquipmentEntity} from './types';

// @ts-ignore
const baseServerUrl = import.meta.env.DEV ? 'http://127.0.0.1:3000' : undefined;

const setup = async (): Promise<EquipmentEntity[]> => {
    const equipment = await fetch(`${baseServerUrl}/equipment`);

    return equipment.json();
};

export {setup};
