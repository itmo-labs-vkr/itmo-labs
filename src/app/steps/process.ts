import {BaseLayer} from '@labs/layers';
import {state} from '@labs/state';

export const process = (layer: BaseLayer) => {
    const config = state.config();
    const entry = Object.values(layer.equipments).find(
        (component) => component.type === config.entry,
    );
    const queue = [[undefined, entry?.id()]] as [string | undefined, string][];

    const used: Record<string, true> = {};

    while (queue.length) {
        const [from, current] = queue.pop()!;

        if (used[current]) {
            continue;
        }

        used[current] = true;

        const component = layer.equipments[current]!;
        const prevResult = from ? layer.equipments[from].physics.compute() : {};

        component.physics.feed(prevResult);

        console.log(component.id(), component.physics.compute());

        queue.push(
            ...config.relations[component.id()].map((id) => [current, id] as [string, string]),
        );
    }
};
