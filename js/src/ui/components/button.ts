import Konva from 'konva';
import {FONT_SIZE} from '../constants';
import {BaseComponent} from './base';

type ButtonConfig = {
    text: string;
    color?: string;
    fill?: string;
    width?: number;
    height?: number;
};

class Button extends BaseComponent<ButtonConfig> {
    build(): Button {
        this.name('chlen');
        const {fill, color, text} = this._props;

        const message = text.trim();

        const content = new Konva.Text({
            text: message,
            fontSize: FONT_SIZE,
            fill: color,
            align: 'center',
            verticalAlign: 'middle',
        });

        const axis = {
            width: content.width() * 2,
            height: content.height() * 2,
        };

        const background = new Konva.Rect({...axis, fill, cornerRadius: 5});

        content.width(axis.width);
        content.height(axis.height);

        this.add(background);
        this.add(content);

        return this;
    }
}

Button.defaultProps = {
    color: 'white',
    fill: 'black',
} satisfies Partial<ButtonConfig>;

export {Button};
