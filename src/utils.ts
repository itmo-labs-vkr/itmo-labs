const random = (start: number, end: number) => Math.floor(Math.random() * (end - start)) + start;
const unique = (prefix = '') => `${prefix}${random(0, 1e10).toString(16)}`;

export {random, unique};
