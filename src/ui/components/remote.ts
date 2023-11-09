import Konva from 'konva';

import {state} from '@labs/state';
import {EquipmentEntity} from '@labs/server';
import {BaseComponent} from './base';
import {Picture} from './picture';

type RemoteProps = {
    name: string;
};

/** Used to render component from server */
class RemoteComponent extends BaseComponent<EquipmentEntity> {
    private _renderedPorts: Konva.Rect[] = [];

    constructor({name}: RemoteProps) {
        const props = state.remote(name);

        super(props);
    }

    configure() {
        this.movable();

        if (this._props.ports) {
            this.name('with-ports');
        }

        this.registerCallback('dragstart', () => {
            this._renderedPorts.forEach((port) => {
                port.fill('white');
            });

            this._renderedPorts.length = 0;
        });

        this.registerCallback('dragend', () => {
            this.renderPorts();
        });
    }

    build() {
        const {src} = this._props;

        this.render(new Picture({src: src.base, width: this.width(), height: this.height()}));

        return this;
    }

    renderPorts() {
        if (!this._props.ports) {
            return;
        }

        const start = state.position(this.getAbsolutePosition());

        for (const port of this._props.ports) {
            const [x, y] = port.position;

            const point = {
                x: start.x + x - 1,
                y: start.y + y - 1,
            };

            const cell = this.layer().cell(point);

            this._renderedPorts.push(cell);
            cell.fill('red');
        }
    }
}

export {RemoteComponent};
