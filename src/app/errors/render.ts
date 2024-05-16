import {RuntimeError} from './RuntimeError';
import {HTMLPopup} from '@labs/components';

export const render = (error: RuntimeError) => {
    const {message} = error;

    const popup = new HTMLPopup({text: message});

    popup.render();
};
