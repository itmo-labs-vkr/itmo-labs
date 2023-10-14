import Konva from 'konva';

import {button} from './ui/button';

const testButton = button({
    text: 'hello pidor',
    x: 100,
    y: 100,
    color: 'red',
});


const stage = new Konva.Stage({
    container: 'container',
    width: window.innerWidth,
    height: window.innerHeight,
});

const group = new Konva.Group({});


const leftSide = new Konva.Group({
    width: 400,
    height: 400,
    id: 'pidor1',
}).add(new Konva.Rect({width: 400, height: 400, fill: 'green'}));


const rightSide = new Konva.Group({
    x: 400,
    width: 400,
    height: 400,
    id: 'pidor2',
}).add(new Konva.Rect({width: 400, height: 400, fill: 'red'}));

group.add(leftSide, rightSide, testButton);

testButton.on('click', () => console.log(testButton.getLayer()?.attrs));


