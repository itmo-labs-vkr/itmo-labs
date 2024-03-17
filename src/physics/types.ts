import type {PhysicsNotation} from '@labs/server';

export type Inputs<T extends PhysicsNotation> = Record<T['dependsOn'][number], number | undefined>;
export type Outputs<T extends PhysicsNotation> = {
    [name in keyof T['produces']]?: number;
};

export type ProcessedPhysics<T extends PhysicsNotation> = {
    feed(inputs: Partial<Inputs<T>>): void;
    compute(): Outputs<T>;
};
