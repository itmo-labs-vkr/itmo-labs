import {ConnectableComponent} from './connectable';
import {Presets} from './picture';

type Props = {
    width: number;
    height: number;
};

export class TestComponent<T extends Props> extends ConnectableComponent<T> {
    build() {
        this.draggable(true);
        this.render(new Presets.Battery({width: this.width(), height: this.height()}));

        super.build();

        return this;
    }
}
