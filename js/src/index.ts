import Konva from 'konva';
import {Button, Frame} from './ui/components';

const fill = new Frame({width: 400, height: 600, border: {width: 1}});

const stage = new Konva.Stage({
    container: 'container',
    width: window.innerWidth,
    height: window.innerHeight,
});

const background = new Konva.Layer({
    width: stage.width(),
    height: stage.height(),
});

const work = new Konva.Layer({
    width: stage.width(),
    height: stage.height(),
});

fill.attach(background, {x: 0, y: 0});

for (const i of [1, 2, 3, 4, 5]) {
    const button = new Button({text: `hello from ${i}`});

    button.attach(work, {x: 0, y: 100 * i});

    button.registerCallback('click', () => console.log(`hello from ${i}`));
}

fill.registerCallback('click', () => console.log('hello from fill'));

stage.add(background, work);
