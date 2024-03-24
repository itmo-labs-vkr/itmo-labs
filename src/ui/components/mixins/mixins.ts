/**
 * export const Component = withMixins(RawComponent, Slider)
 */

import {BaseComponent} from '../base';

type Constructor<T = {}> = new (...args: any[]) => T;
interface WithMixins<T extends Constructor<BaseComponent>> {
    run(): void;
    (...args: ConstructorParameters<T>): T;
}

type Result<T extends BaseComponent> = T & WithMixins<Constructor<T>>;

export function withMixins<
    Component extends BaseComponent,
    ComponentConstructor = Constructor<Component>,
>(Base: ComponentConstructor): Result<Component> {
    // @ts-ignore
    return class extends Base {
        constructor(...args: unknown[]) {
            console.log('created');
            super(...args);
        }

        run() {
            console.log('run');
        }
    };
}

/* WIP */
