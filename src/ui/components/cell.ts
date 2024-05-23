import Konva from 'konva';

import {BaseComponent} from './base';
import {state} from '@labs/state';
import {RemoteComponent} from './remote';

type CellState = {
    empty: boolean;
    component?: RemoteComponent;
};

class Cell extends BaseComponent<{}, CellState> {
    private _rect!: Konva.Rect;

    constructor() {
        const {cell} = state.config();

        super(cell);
    }

    state(): CellState {
        return {
            empty: true,
        };
    }

    build() {
        this._rect = new Konva.Rect({
            width: this.width(),
            height: this.height(),
            stroke: 'rgba(0, 0, 0, 0.1)',
        });

        this.add(this._rect);

        return this;
    }

    fill(color: string) {
        this._rect.fill(color);
    }

    borrow(component?: RemoteComponent) {
        this._state = {
            empty: typeof component === 'undefined',
            component,
        };

        // this.fill(component ? 'red' : 'white');
    }

    owner() {
        return this._state.component;
    }

    /**
     *
     * @param other cell
     * @returns manhattan distance in cells
     */
    distanceTo(other: Cell): number {
        const [x, y] = [this.x(), this.y()];
        const [otherX, otherY] = [other.x(), other.y()];

        const {x: diffX, y: diffY} = state.position({
            x: Math.abs(x - otherX),
            y: Math.abs(y - otherY),
        });

        return diffX + diffY;
    }

    isInComoponent(component: BaseComponent) {
        if (!component.measure) {
            throw new Error(
                `Unable to check collision: component ${component.name} has no measure`,
            );
        }

        const [cellX, cellY] = [this.x(), this.y()];
        const [x, y] = [component.x(), component.y()];

        const {width, height} = state.size(...component.measure);

        return cellX >= x && cellX < x + width && cellY >= y && cellY < y + height;
    }
}

export {Cell};
