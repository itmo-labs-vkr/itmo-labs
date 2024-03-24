import {BaseLayer} from '@labs/layers';
import {state} from '@labs/state';
import {extract} from '@labs/utils';
import {NotAllEquipmentConnected, NotAllEquipmentPlaced} from 'app/errors';

export const validate = (layer: BaseLayer) => {
    const config = state.config();
    const {equipments} = layer;
    const values = Object.values(equipments).map(extract('type'));

    const areAllEquipmentsPlaced = config.proofOfDone.required.every((name) =>
        values.find((value) => value === name),
    );

    if (!areAllEquipmentsPlaced) {
        throw new NotAllEquipmentPlaced(values, config.proofOfDone.required);
    }

    for (const connection of config.proofOfDone.connections) {
        const [from, to, count] = connection;

        if (state.connections(from, to) !== count) {
            throw new NotAllEquipmentConnected();
        }
    }
};
