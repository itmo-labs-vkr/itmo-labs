import Konva from 'konva';
import {Button, ConnectableComponent, Frame, TestComponent} from '../ui/components';
import {BaseLayer} from './layers';

type Config = {
    width: number;
    height: number;
    container: string;
};

class App {
    config: Config;
    root: Konva.Stage;
    sizes: Record<'workspace' | 'equipment', {width: number; height: number}>;

    constructor(config: Config) {
        this.config = config;
        this.root = new Konva.Stage(config);

        this.sizes = {
            workspace: {
                width: this.config.width * 0.75,
                height: this.config.height,
            },
            equipment: {
                width: this.config.width * 0.25,
                height: this.config.height,
            },
        };
    }

    initializeBackgroundLayer() {
        const {width, height} = this.config;

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
            width: 100,
            height: 200,
        });

        const connectable2 = new TestComponent(['top-middle', 'bottom-middle'], {
            width: 100,
            height: 200,
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
