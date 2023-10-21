import Konva from 'konva';
import {Button, ConnectableComponent, Frame, TestComponent} from '@labs/components';
import {BaseLayer} from '@labs/layers';
import {state} from '@labs/state';

type Config = {
    width: number;
    height: number;
    container: string;
};

class App {
    root: Konva.Stage;
    sizes: Record<'workspace' | 'equipment', {width: number; height: number}>;

    constructor(config: Config) {
        this.root = new Konva.Stage(config);

        state.setup(config);

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

    run() {
        const backgroundLayer = this.initializeBackgroundLayer();
        const workLayer = this.initializeWorkLayer();
        const equipmentLayer = this.initializeEquipmentLayer();

        equipmentLayer.add();

        const button = new Button({text: 'добавить кнопку'});

        button.attach(workLayer, {x: 100, y: 200});

        equipmentLayer.x(this.sizes.workspace.width);

        this.root.add(backgroundLayer, workLayer, equipmentLayer);

        const connectable1 = new TestComponent(['top-middle', 'bottom-middle'], {
            width: 1,
            height: 2,
            radius: 100,
        });

        const connectable2 = new TestComponent(['top-middle', 'bottom-middle'], {
            width: 2,
            height: 2,
        });

        connectable1.attach(workLayer, {x: 100, y: 300});
        connectable2.attach(workLayer, {x: 400, y: 300});

        const test = this.root.find('.connectable') as ConnectableComponent[];

        button.registerCallback('click', () => {
            test.forEach((node) => (node as ConnectableComponent).toggle());
        });
    }
}

export {App};
