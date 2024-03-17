import {PhysicsNotation} from '@labs/server';
import {expect, test} from 'vitest';
import {create} from './factory';

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const sample = {
    dependsOn: ['a', 'b'] as const,
    constants: {
        c: 30,
    },
    produces: {
        output: 'a + b * c',
        singleA: 'a',
        empty: 'd + 1',
    },
} satisfies PhysicsNotation;

test('physics compute logic', () => {
    const physics = create(sample);

    physics.feed({
        a: 1,
    });

    physics.feed({
        b: 2,
    });

    const {empty, output, singleA} = physics.compute();

    expect(singleA).toEqual(1);
    expect(empty).toBeUndefined();
    expect(output).toEqual(61);
});
