import Konva from 'konva';
import {Button, Frame} from '@labs/components';
import {BaseLayer} from '@labs/layers';
import {state} from '@labs/state';
import {renderEquipment} from 'ui';

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

    initializeBackgroundLayer() {
        const {
            geometry: {width, height},
        } = state.config();

        const background = new Konva.Layer({width, height});
        const frame = new Frame({
            width,
            height,
            border: {width: 10, color: 'black'},
            fill: '#f3f3f3',
        });

        frame.attach(background);

        return background;
    }

    initializeWorkLayer() {
        const {width, height} = this.sizes.workspace;

        const workLayer = new BaseLayer({width, height});

        workLayer.outlite({width: 2, color: 'black'});

        return workLayer;
    }

    initializeEquipmentLayer() {
        const {width, height} = this.sizes.equipment;

        const equipmentLayer = new Konva.Layer({width, height});
        const frame = new Frame({width, height, border: {width: 2, color: 'black'}});

        frame.attach(equipmentLayer);

        return equipmentLayer;
    }

    async run() {
        await state.setup(this.config);

        const {
            geometry: {width, height},
        } = state.config();

        this.sizes = {
            workspace: {
                width: width * 0.75,
                height: height,
            },
            equipment: {
                width: width * 0.25,
                height: height,
            },
        };

        const backgroundLayer = this.initializeBackgroundLayer();
        const workLayer = this.initializeWorkLayer();
        const equipmentLayer = this.initializeEquipmentLayer();

        equipmentLayer.add();

        const button = new Button({text: 'добавить кнопку', measure: [2, 1], draggable: true});

        button.attach(workLayer, {x: 100, y: 200});

        equipmentLayer.x(this.sizes.workspace.width);

        this.root.add(backgroundLayer, workLayer, equipmentLayer);

        const cat = renderEquipment('cat');
        cat.draggable(true);

        cat.attach(workLayer);
    }
}

export {App};
