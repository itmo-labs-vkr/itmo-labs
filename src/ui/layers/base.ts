import Konva from 'konva';

import {state} from '@labs/state';
import {BaseComponent, Cell, RemoteComponent} from '../components';

type OutlineConfig = {
    width: number;
    color: string;
};

class BaseLayer<
    T extends RequireGeometry<Konva.LabelConfig> = RequireGeometry<Konva.LabelConfig>,
> extends Konva.Layer {
    equipments: Record<string, RemoteComponent> = {};

    protected _cells: Cell[][] = [];
    protected _props: T;

    private _frame: Konva.Rect;

    constructor(props: T) {
        super(props);

        this._props = props;

        const {width, height} = props;

        this.width(width);
        this.height(height);

        this._renderCells();

        this._frame = new Konva.Rect({
            width,
            height,
        });

        this.add(this._frame);
    }

    color(fill: string) {
        this._frame.fill(fill);

        return this;
    }

    outline(config: OutlineConfig) {
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
                if (child instanceof RemoteComponent && !child.isEnvironment) {
                    this.equipments[child.id()] = child;
                }

                const element = child.mount();

                super.add(element);

                return;
            }

            super.add(child);
        });

        return this;
    }

    cell({x, y}: Point2D) {
        return this._cells[x][y];
    }

    protected _getCellFromEvent(event: LayerEvent<Event>) {
        try {
            const {layerX: x, layerY: y} = event;

            // used to correct work of multiple layers
            const {x: cellX, y: cellY} = state.position({
                x: x - this.x(),
                y: y - this.y(),
            });

            const cell = this.cell({x: cellX, y: cellY});

            if (Object.values(this.equipments).find(cell.isInComoponent.bind(cell))) {
                return undefined;
            }

            return cell;
        } catch {
            // to handle outline cells
            return undefined;
        }
    }

    protected _renderCells() {
        const {width: layerWidth, height: layerHeight} = this._props;
        const {
            cell: {height, width},
        } = state.config();

        const x = Math.floor(layerWidth / width);
        const y = Math.ceil(layerHeight / height);

        for (let i = 0; i < x; i++) {
            const row: Cell[] = [];

            for (let j = 0; j < y; j++) {
                const cell = new Cell();

                cell.x(i * width);
                cell.y(j * height);

                row.push(cell);
                this.add(cell);
            }

            this._cells.push(row);
        }
    }
}

export {BaseLayer};
