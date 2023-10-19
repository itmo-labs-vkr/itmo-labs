import Konva from 'konva';
import { Button, Frame } from './ui/components';

const workFrame = new Frame({ width: 1200, height: 800, border: { width: 1 } });
const fill = new Frame({ width: 1200, height: 800, border: { width: 1 } });

const stage = new Konva.Stage({
    container: 'container',
    width: 1200,
    height: 800,
});

const work = new Konva.Layer({
    width: stage.width(),
    height: stage.height(),
}).add(new Konva.Rect({
    width: stage.width(),
    height: stage.height(),
    x: 0,
    y: 0,
    stroke: "black",
    strokeWidth: 2
}))

const equipments = new Konva.Layer({
    width: stage.width(),
    height: stage.height(),
}).add(new Konva.Rect({
    x: stage.width() * 0.6,
    y: 0,
    stroke: "black",
    strokeWidth: 2
}))

stage.add(work, equipments);