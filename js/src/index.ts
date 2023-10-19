import Konva from 'konva';
import {Button, Frame} from './ui/components';

const work = new Frame({width: 400, height: 600, border: {width: 1}});
const button = new Button({text: 'i am button', color: 'red'});

work.render(button, {x: 40, y: 200});

const stage = new Konva.Stage({
    container: 'container',
    width: window.innerWidth,
    height: window.innerHeight,
});

const layer = new Konva.Layer({
    width: stage.width(),
    height: stage.height(),
});

work.attach(layer, {x: 0, y: 0});

stage.add(layer);
