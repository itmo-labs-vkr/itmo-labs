import Konva from 'konva';

import {state} from '@labs/state';
import {BaseComponent} from '../components';

type OutlineConfig = {
    width: number;
    color: string;
};

class BaseLayer extends Konva.Layer {
    private _frame: Konva.Rect;
    private _props: RequireGeometry<Konva.LabelConfig>;

    constructor(props: RequireGeometry<Konva.LabelConfig>) {
        super(props);

        this._props = props;

        const {width, height} = props;

        this._frame = new Konva.Rect({
            width,
            height,
        });

        this._renderCells();
        this.add(this._frame);
    }

    color(fill: string) {
        this._frame.fill(fill);

        return this;
    }

    outlite(config: OutlineConfig) {
        const {width, color} = config;
        if (width) {
            this._frame.strokeWidth(width);
        }

        if (color) {
            this._frame.stroke(color);
        }

        return this;
    }

    add(...children: (Konva.Group | Konva.Shape | BaseComponent)[]) {
        children.forEach((child) => {
            if (child instanceof BaseComponent) {
                const element = child.mount();

                super.add(element);

                return;
            }

            super.add(child);
        });

        return this;
    }

    private _renderCells() {
        const {width: layerWidth, height: layerHeight} = this._props;
        const {cell} = state.config();

        const x = Math.floor(layerWidth / cell.width);
        const y = Math.ceil(layerHeight / cell.height);

        const {width, height} = cell;

        for (let i = 0; i < x; i++) {
            for (let j = 0; j < y; j++) {
                const rect = new Konva.Rect({
                    width,
                    height,
                    stroke: 'rgba(0, 0, 0, 0.1)',
                });

                rect.x(i * width);
                rect.y(j * height);

                this.add(rect);
            }
        }
    }
}

export {BaseLayer};
