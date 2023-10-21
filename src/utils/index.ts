const random = (start: number, end: number) => Math.floor(Math.random() * (end - start)) + start;
const unique = (prefix = '') => `${prefix}${random(0, 1e10).toString(16)}`;

const assert = (statement: boolean, erorr = 'Assertion faled') => {
    if (!statement) {
        throw new Error(erorr);
    }
};

export {random, unique, assert};
