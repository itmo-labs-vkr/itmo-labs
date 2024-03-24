import {RuntimeError} from './RuntimeError';

export const render = (error: RuntimeError) => {
    alert(`WIP\n ${error.message}`);
};
