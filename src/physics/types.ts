import type {PhysicsNotation} from '@labs/server';

export type Inputs<T extends PhysicsNotation> = T['dependsOn'] extends string[]
    ? Record<T['dependsOn'][number], number | undefined>
    : [];
export type Outputs<T extends PhysicsNotation> = {
    [name in keyof T['produces']]?: number;
};

/** @todo infer any */
export type ProcessedPhysics<T extends PhysicsNotation = any> = {
    feed(inputs: Partial<Inputs<T>>): void;
    compute(): Outputs<T>;
    values: unknown;
};
