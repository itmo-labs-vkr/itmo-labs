import Konva from 'konva';

import {RemoteComponent} from '@labs/components';
import {EquipmentLayer, WorkLayer} from '@labs/layers';
import {state} from '@labs/state';
import {resize} from '@labs/utils';

type Config = {
    width: number;
    height: number;
    container: string;
};

class App {
    root: Konva.Stage;
    config: Config;
    sizes!: Record<'workspace' | 'equipment' | 'empty', {width: number; height: number}>;

    rootLayer!: Konva.Layer;
    workLayer!: WorkLayer;
    equipmentLayer!: EquipmentLayer;

    constructor(config: Config) {
        this.root = new Konva.Stage(config);
        this.config = config;

        this.initializeRootLayer();
    }

    initializeRootLayer() {
        const {width, height} = this.config;

        const rootLayer = new Konva.Layer({width, height});

        if (!this.rootLayer) {
            this.rootLayer = rootLayer;
        }
    }

    initializeWorkLayer() {
        const {width, height} = this.sizes.workspace;

        const workLayer = new WorkLayer({width, height, withWires: true});

        if (!this.workLayer) {
            this.workLayer = workLayer;
        }

        return workLayer;
    }

    initializeEquipmentLayer() {
        const {width, height} = this.sizes.equipment;
        const equipmentLayer = new EquipmentLayer({
            width,
            height,
            onDragEnd: this.handleComponentLanded.bind(this),
            startX: 1,
            startY: 1,
            xAxis: 1,
            yAxis: 1,
        });

        if (!this.equipmentLayer) {
            this.equipmentLayer = equipmentLayer;
        }

        return equipmentLayer;
    }

    scale(width: number, height: number) {
        Object.assign(this.config, {width, height});
        const {cell} = state.config();

        const layers = {
            workspace: {
                width: resize(width * 0.6, cell.width),
                height: resize(height, cell.height),
            },
            equipment: {
                width: resize(width * 0.35, cell.width),
                height: resize(height, cell.height),
            },
        };

        this.sizes = {
            ...layers,
            empty: {
                width: Math.floor(width - layers.workspace.width - layers.equipment.width),
                height: Math.floor(height - layers.workspace.height - layers.equipment.height),
            },
        };

        state.set('empty', this.sizes.empty);

        this.initializeWorkLayer();
        this.initializeEquipmentLayer();

        this.equipmentLayer.x(this.config.width - this.sizes.equipment.width);
    }

    handleComponentLanded(event: Konva.KonvaEventObject<'dragend'>) {
        const {x, y} = event.target._lastPos!;
        const component = event.target as unknown as RemoteComponent;

        if (
            x >= 0 &&
            x <= this.sizes.workspace.width &&
            y >= 0 &&
            y <= this.sizes.workspace.height
        ) {
            const layer = component.layer();
            const {
                cell: {width, height},
            } = state.config();

            if (layer === this.equipmentLayer) {
                this.workLayer.add(component);
                component.x(x - (x % width)).y(y - (y % height));

                this.workLayer.draw();
            } else if (layer === this.workLayer) {
                component.x(x - (x % width)).y(y - (y % height));
            }
        } else {
            this.equipmentLayer.add(component);

            delete this.workLayer.equipments[component.id()];

            component.resetPosition();

            this.equipmentLayer.draw();
        }
    }

    async run() {
        await state.setup(this.config, this.rootLayer);

        this.scale(this.config.width, this.config.height);

        this.root.add(this.rootLayer, this.workLayer, this.equipmentLayer);

        this.equipmentLayer.renderEquipemnt();
    }
}

export {App};
