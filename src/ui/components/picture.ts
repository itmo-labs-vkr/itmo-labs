import Konva from 'konva';
import {BaseComponent} from './base';

interface PictureConfig {
    src: string;
}

const pictureFactory = (src: string) => {
    const Picture = class extends BaseComponent<PictureConfig> {
        build() {
            const {width, height} = this._props;
            const image = new Image(width, height);

            image.src = `assets/${src}`;

            this.add(new Konva.Image({image, width, height}));

            return this;
        }
    };

    return Picture;
};

const Presets = {
    _Test: pictureFactory('test.png'),
    Battery: pictureFactory('battery.png'),
    from(props: PictureConfig & Konva.ShapeConfig): BaseComponent<PictureConfig> {
        const Cls = pictureFactory(props.src);

        return new Cls(props);
    },
};

export {Presets};
