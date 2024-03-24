const random = (start: number, end: number) => Math.floor(Math.random() * (end - start)) + start;
const unique = (prefix = '') => `${prefix}${random(0, 1e10).toString(16)}`;

const resize = (value: number, cell: number) => {
    return value - (value % cell);
};

const assert = (statement: boolean, erorr = 'Assertion faled') => {
    if (!statement) {
        throw new Error(erorr);
    }
};

const extract = <Key extends string>(key: Key) => {
    return <T extends Record<Key, unknown>>(target: T) => {
        return target[key];
    };
};

const isDev = () => {
    // @ts-ignore
    return import.meta.env.DEV;
};

export {random, unique, assert, resize, isDev, extract};
