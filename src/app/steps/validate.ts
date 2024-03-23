import {BaseLayer} from '@labs/layers';
import {state} from '@labs/state';

export const validate = (layer: BaseLayer) => {
    const config = state.config();
    const {equipments} = layer;
    const values = Object.values(equipments);

    const areAllEquipmentsPlaced = config.proofOfDone.required.every((name) =>
        values.find((value) => value.type === name),
    );

    if (!areAllEquipmentsPlaced) {
        return false;
    }

    let areAllConectionsOk = true;

    for (const connection of config.proofOfDone.connections) {
        const [from, to, count] = connection;

        if (state.connections(from, to) !== count) {
            areAllConectionsOk = false;

            break;
        }
    }

    return areAllConectionsOk;
};
