import Konva from 'konva';

import {Button, Cell} from '@labs/components';
import {BaseLayer} from './base';
import {state} from '@labs/state';

type Props = {
    withWires?: boolean;
};

export class WorkLayer extends BaseLayer {
    private _allowWires: boolean;
    private _areWiresInProgress = false;
    private _wire: Cell[] = [];

    constructor(props: RequireGeometry<Konva.LabelConfig & Props>) {
        super(props);

        this._allowWires = props.withWires || false;

        if (this._allowWires) {
            this._enableWires();
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

                fromComponent?.renderPorts();
                targetComponent?.renderPorts();

                this._wire.length = 0;
                this._areWiresInProgress = false;

                return;
            }

            state.connect(fromComponent!, targetComponent!, [...this._wire]);

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
}
