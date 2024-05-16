import {PhysicsNotation} from '@labs/server' /* (1) */;
import type {Inputs, Outputs, ProcessedPhysics} from './types';

const math = require('mathjs'); /* (2) */

export const create = <T extends PhysicsNotation>(notation: T): ProcessedPhysics<T> => {
    const values: Partial<Inputs<T>> = {};
    const feed /* (3) */ = (updateWith: Partial<Inputs<T>>) => {
        Object.assign(values, updateWith);
    };

    const compute /* (4) */ = (): Partial<Outputs<T>> => {
        const targets = Object.entries(notation.produces);
        const scope = {
            ...notation.constants,
            ...notation.initial,
            ...values,
        };

        const result: Record<string, number | undefined> = {};

        /* (5) */
        for (const [name, formula] of targets) {
            try {
                result[name] = math.evaluate(formula, scope) as number | undefined;
            } catch {
                result[name] = undefined;
            }
        }

        Object.assign(values, result);

        return result as Outputs<T>;
    };

    return {feed, compute, values};
};
