import {state} from '@labs/state';
import {EquipmentEntity} from '@labs/server';
import {BaseComponent} from './base';
import {Picture} from './picture';

type RemoteProps = {
    name: string;
};

/** Used to render component from server */
class RemoteComponent extends BaseComponent<EquipmentEntity> {
    constructor({name}: RemoteProps) {
        const props = state.remote(name);

        super(props);
    }

    build() {
        const {src} = this._props;

        this.render(new Picture({src: src.base, width: this.width(), height: this.height()}));

        return this;
    }
}

export {RemoteComponent};
