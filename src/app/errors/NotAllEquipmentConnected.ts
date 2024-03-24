import {RuntimeError} from './RuntimeError';

export class NotAllEquipmentConnected extends RuntimeError {
    constructor() {
        super('Not all equipment has correct connections');
    }
}
