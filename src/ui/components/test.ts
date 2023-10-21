import {ConnectableComponent} from './connectable';
import {Presets} from './picture';

export class TestComponent extends ConnectableComponent {
    build() {
        this.draggable(true);
        this.render(new Presets._Test({width: this.width()!, height: this.height()!}));

        super.build();

        return this;
    }
}
