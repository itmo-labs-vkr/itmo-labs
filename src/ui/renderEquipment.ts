import {state} from '@labs/state';
import {Picture} from './components';

export const renderEquipment = (name: string): Picture => {
    const {equipment} = state.config();

    const {
        measure,
        src: {base},
    } = equipment[name];

    return new Picture({
        measure,
        src: base,
    });
};
