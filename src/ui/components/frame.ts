import Konva from 'konva';
import {BaseComponent} from './base';

type FrameConfig = {
    width: number;
    height: number;
    fill?: string;
    border?: {
        color?: string;
        width?: number;
    };
};

class Frame extends BaseComponent<FrameConfig> {
    build(): Frame {
        const {width, height, border, fill} = this._props;

        const background = new Konva.Rect({
            width,
            height,
            fill,
            strokeWidth: border?.width,
            stroke: border?.color,
        });

        this.add(background);

        return this;
    }
}

Frame.defaultProps = {
    border: {
        color: 'black',
        width: 2,
    },
} satisfies Partial<FrameConfig>;

export {Frame};
