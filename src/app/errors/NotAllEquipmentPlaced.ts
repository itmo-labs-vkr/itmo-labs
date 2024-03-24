import {RuntimeError} from './RuntimeError';

export class NotAllEquipmentPlaced extends RuntimeError {
    constructor(placed: string[], required: string[]) {
        const notPlaced = required.filter((value) => !placed.includes(value));

        super(`Not all equipment placed: ${notPlaced.join(',')}`);
    }
}
