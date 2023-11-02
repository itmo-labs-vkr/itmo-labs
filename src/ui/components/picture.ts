import Konva from 'konva';
import {BaseComponent} from './base';

const pictureFactory = (src: string) => {
    const Picture = class extends BaseComponent {
        build() {
            const image = new Image(this.width(), this.height());

            image.src = `assets/${src}`;

            this.add(new Konva.Image({image, width: this.width(), height: this.height()}));

            return this;
        }
    };

    return Picture;
};

const Presets = {
    _Test: pictureFactory('test.png'),
    Battery: pictureFactory('battery.png'),
    from(props: ComponentProps): BaseComponent {
        const Cls = pictureFactory(props.src);

        return new Cls(props);
    },
};

export {Presets};
