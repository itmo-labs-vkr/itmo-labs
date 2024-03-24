import {BaseLayer} from '@labs/layers';
import {process, validate} from './steps';
import {RuntimeError, render} from './errors';

export function run(this: BaseLayer) {
    try {
        validate(this);
        process(this);
    } catch (error) {
        if (error instanceof RuntimeError) {
            render(error);

            return;
        }

        console.error(error);
    }
}
