import Konva from 'konva';
import {BaseComponent} from './base';

type PictureProps = {
    src: string;
};

class Picture extends BaseComponent<PictureProps> {
    private _image!: Konva.Image;

    build() {
        const image = new Image(this.width(), this.height());

        image.src = this._props.src;

        this._image = new Konva.Image({image, width: this.width(), height: this.height()});
        this.add(this._image);

        return this;
    }

    image(value: string) {
        const image = new Image(this.width(), this.height());
        image.src = value;

        this._image.image(image);
    }
}

export {Picture};
