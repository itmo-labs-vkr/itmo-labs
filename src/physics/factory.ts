import {PhysicsNotation} from '@labs/server';
import type {Inputs, Outputs, ProcessedPhysics} from './types';
const math = require('mathjs');

export const create = <T extends PhysicsNotation>(notation: T): ProcessedPhysics<T> => {
    const values: Partial<Inputs<T>> = {};
    const feed = (updateWith: Partial<Inputs<T>>) => {
        Object.assign(values, updateWith);
    };

    /* @todo cache values */
    const compute = (): Partial<Outputs<T>> => {
        const targets = Object.entries(notation.produces);
        const scope = {
            ...notation.constants,
            ...notation.initial,
            ...values,
        };

        const result: Record<string, number | undefined> = {};

        for (const [name, formula] of targets) {
            try {
                result[name] = math.evaluate(formula, scope) as number | undefined;
            } catch {
                result[name] = undefined;
            }
        }

        return result as Outputs<T>;
    };

    return {feed, compute};
};
