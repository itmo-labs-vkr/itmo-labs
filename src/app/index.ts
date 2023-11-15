import Konva from 'konva';

import {RemoteComponent} from '@labs/components';
import {BaseLayer} from '@labs/layers';
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
    sizes!: Record<'workspace' | 'equipment', {width: number; height: number}>;

    constructor(config: Config) {
        this.root = new Konva.Stage(config);
        this.config = config;
    }

    initializeWorkLayer() {
        const {width, height} = this.sizes.workspace;

        const workLayer = new BaseLayer({width, height, withWires: true});

        return workLayer;
    }

    initializeEquipmentLayer() {
        const {width, height} = this.sizes.equipment;
        const equipmentLayer = new BaseLayer({width, height});

        return equipmentLayer;
    }

    async run() {
        await state.setup(this.config);

        const {
            geometry: {width, height},
        } = state.config();

        const {cell} = state.config();

        this.sizes = {
            workspace: {
                width: resize(width * 0.7, cell.width),
                height: resize(height, cell.height),
            },
            equipment: {
                width: resize(width * 0.25, cell.width),
                height: resize(height, cell.height),
            },
        };

        const workLayer = this.initializeWorkLayer();
        const equipmentLayer = this.initializeEquipmentLayer();

        equipmentLayer.x(this.config.width - this.sizes.equipment.width);

        this.root.add(workLayer, equipmentLayer);

        const lamp = new RemoteComponent({name: 'lamp'});

        lamp.attach(workLayer, [10, 4]);
        lamp.renderPorts();

        const battery = new RemoteComponent({name: 'battery'});

        battery.attach(workLayer, [10, 10]);
        battery.renderPorts();
    }
}

export {App};
