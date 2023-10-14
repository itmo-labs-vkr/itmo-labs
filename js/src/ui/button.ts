import Konva from 'konva';
import {FONT_SIZE} from './constants';

type ButtonConfig = {
    x: number;
    y: number;
    text: string;
    color?: string;
    fill?: string;
};

const button = ({x, y, text, color, fill}: ButtonConfig): Konva.Group => {
    const message = text.trim();

    const content = new Konva.Text({
        text: message,
        fontSize: FONT_SIZE,
        fill: color || 'white',
        align: 'center',
        verticalAlign: 'middle',
    });

    const axis = {
        width: content.width() * 2,
        height: content.height() * 2,
    };

    const background = new Konva.Rect({...axis, fill: fill || 'black', cornerRadius: 5});
    const group = new Konva.Group({x, y, ...axis, draggable: true});

    content.width(axis.width);
    content.height(axis.height);

    group.add(background);
    group.add(content);

    return group;
};


export {button};
