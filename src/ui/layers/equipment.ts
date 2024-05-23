import {state} from '@labs/state';
import {BaseLayer} from './base';
import Konva from 'konva';
import {RemoteComponent} from '@labs/components';

type Paddings = {
    startX: number;
    startY: number;
    xAxis: number;
    yAxis: number;
    onDragEnd(event: Konva.KonvaEventObject<unknown>): void;
};

export class EquipmentLayer extends BaseLayer<RequireGeometry<Konva.LabelConfig> & Paddings> {
    paddings: Paddings;
    sizes: [number, number];

    constructor(props: RequireGeometry<Konva.LabelConfig> & Paddings) {
        super(props);

        this.paddings = props;

        this.sizes = [this._cells.length, this._cells[0].length];
    }

    renderEquipemnt() {
        const {equipment} = state.config();

        const {startX, startY, xAxis, yAxis} = this._props;
        let [x, y] = [startX, startY];
        let maxYComponent = 0;

        for (const name of Object.keys(equipment)) {
            const {count = 1} = equipment[name];

            for (let i = 0; i < count; i++) {
                const component = new RemoteComponent({name, onDragEnd: this._props.onDragEnd});
                const [componentX, componentY] = component.measure!;
                const didFit = this.didComponentFit([x, y], component);

                if (didFit) {
                    component.attach(this, [x, y]);
                    x += componentX + xAxis;
                    maxYComponent = Math.max(maxYComponent, componentY);

                    continue;
                }

                y += maxYComponent + yAxis;
                x = startX;

                maxYComponent = 0;

                if (!this.didComponentFit([x, y], component)) {
                    throw new Error('Unable to fit component');
                }

                component.attach(this, [x, y]);
            }
        }
    }

    didComponentFit(at: BoardPosition, component: RemoteComponent): boolean {
        const [x, y] = at;
        const [maxX, maxY] = this.sizes;
        const [componentX, componentY] = component.measure!;

        return x + componentX <= maxX && y + componentY <= maxY;
    }
}
