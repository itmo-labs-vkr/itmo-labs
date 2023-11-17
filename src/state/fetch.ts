import {isDev} from '@labs/utils';
import {Config} from '@labs/server';

const baseServerUrl = isDev() ? 'http://127.0.0.1:3000' : undefined;

const setup = async (): Promise<Config> => {
    const result = await fetch(`${baseServerUrl}/config`);

    return result.json();
};

export {setup};
