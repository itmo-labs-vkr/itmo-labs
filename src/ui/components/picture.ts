import Konva from 'konva';
import {BaseComponent} from './base';

type PictureProps = {
    src: string;
};
class Picture extends BaseComponent<PictureProps> {
    build() {
        const image = new Image(this.width(), this.height());

        image.src = this._props.src;
        this.add(new Konva.Image({image, width: this.width(), height: this.height()}));

        return this;
    }
}

export {Picture};
