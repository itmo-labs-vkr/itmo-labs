import {isDev} from '@labs/utils';
import {EquipmentEntity} from '@labs/server';

const baseServerUrl = isDev() ? 'http://127.0.0.1:3000' : undefined;

const setup = async (): Promise<EquipmentEntity[]> => {
    const result = await fetch(`${baseServerUrl}/equipment`);

    return result.json();
};

export {setup};
