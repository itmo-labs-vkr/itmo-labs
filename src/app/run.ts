import {BaseLayer} from '@labs/layers';
import {animate, process, validate} from './steps';

export function run(this: BaseLayer) {
    if (!validate(this)) {
        return;
    }

    process(this);
}
