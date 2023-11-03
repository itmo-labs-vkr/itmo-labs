import {ConnectableComponent} from './connectable';

export class TestComponent extends ConnectableComponent {
    build() {
        this.draggable(true);

        super.build();

        return this;
    }
}
