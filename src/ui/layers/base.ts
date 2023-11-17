import Konva from 'konva';

import {state} from '@labs/state';
import {BaseComponent, Button, Cell} from '../components';

type OutlineConfig = {
    width: number;
    color: string;
};

type Props = {
    withWires?: boolean;
};

class BaseLayer extends Konva.Layer {
    private _frame: Konva.Rect;
    private _props: RequireGeometry<Konva.LabelConfig>;

    private _allowWires: boolean;
    private _areWiresInProgress = false;
    private _cells: Cell[][] = [];
    private _wire: Cell[] = [];

    private equipments: BaseComponent[] = [];

    constructor(props: RequireGeometry<Konva.LabelConfig & Props>) {
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

        this._allowWires = props.withWires || false;

        if (this._allowWires) {
            this._enableWires();
        }
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
                if (!child.isEnvironment) {
                    this.equipments.push(child);
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

    private _renderCells() {
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

    private _enableWires() {
        this.addEventListener('mousedown', (event) => {
            if (!this._allowWires) {
                return;
            }

            const cell = this._getCellFromEvent(event as any);

            if (!cell) {
                return;
            }

            this._areWiresInProgress = true;
        });

        this.addEventListener('mousemove', (event) => {
            if (!this._areWiresInProgress || !this._allowWires) {
                return;
            }

            const cell = this._getCellFromEvent(event as any);

            if (!cell) {
                return;
            }

            if (this._wire.at(-1) !== cell) {
                this._wire.push(cell);
            }

            cell.fill('orange');
        });

        this.addEventListener('mouseup', () => {
            if (!this._wire.length) {
                return;
            }

            let isWireLinked = true;

            for (let i = 0; i < this._wire.length - 1; i++) {
                if (this._wire[i].distanceTo(this._wire[i + 1]) !== 1) {
                    isWireLinked = false;

                    break;
                }
            }

            const fromComponent = this._wire[0].owner();
            const targetComponent = this._wire.at(-1)!.owner();

            const isLinkBetweenComponents = ![fromComponent, targetComponent].includes(undefined);

            if (!isWireLinked || !isLinkBetweenComponents) {
                this._wire.forEach((cell) => {
                    cell.fill('white');
                });
            }

            this._wire.length = 0;
            this._areWiresInProgress = false;
        });

        this._allowWires = false;

        const addWireButton = new Button({text: 'Добавить провод', measure: [4, 2]});

        addWireButton.registerCallback('click', () => {
            this._allowWires = !this._allowWires;
        });

        addWireButton.attach(this, [0, 0]);
    }

    private _getCellFromEvent(event: LayerEvent<Event>) {
        try {
            const {layerX: x, layerY: y} = event;

            // used to correct work of multiple layers
            const {x: cellX, y: cellY} = state.position({
                x: x - this.x(),
                y: y - this.y(),
            });

            const cell = this.cell({x: cellX, y: cellY});

            if (this.equipments.find(cell.isInComoponent.bind(cell))) {
                return undefined;
            }

            return cell;
        } catch {
            // to handle outline cells
            return undefined;
        }
    }
}

export {BaseLayer};
