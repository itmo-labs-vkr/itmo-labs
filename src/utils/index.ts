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

const compose = (...args: Point2D[]): Point2D => {
    return args.reduce(
        (acc, curr) => {
            return {
                x: acc.x + curr.x,
                y: acc.y + curr.y,
            };
        },
        {x: 0, y: 0},
    );
};

const noop = () => {};

export {random, unique, assert, resize, isDev, extract, noop, compose};
