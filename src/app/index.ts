import Konva from 'konva';
import {Button, RemoteComponent} from '@labs/components';
import {BaseLayer} from '@labs/layers';
import {state} from '@labs/state';

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

        const workLayer = new BaseLayer({width, height});

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

        this.sizes = {
            workspace: {
                width: width * 0.7,
                height: height,
            },
            equipment: {
                width: width * 0.25,
                height: height,
            },
        };

        const workLayer = this.initializeWorkLayer();
        const equipmentLayer = this.initializeEquipmentLayer();

        const button = new Button({text: 'добавить кнопку', measure: [8, 3], draggable: true});

        button.attach(workLayer, {x: 100, y: 200});

        equipmentLayer.x(this.config.width - this.sizes.equipment.width);

        this.root.add(workLayer, equipmentLayer);

        const wip = new RemoteComponent({name: 'wip'});

        wip.attach(workLayer, [20, 25]);
    }
}

export {App};
