import Konva from 'konva';

type OutlineConfig = {
    width: number;
    color: string;
};

class BaseLayer extends Konva.Layer {
    private _frame: Konva.Rect;

    constructor(props: Konva.LabelConfig) {
        super(props);

        this._frame = new Konva.Rect({
            width: props.width,
            height: props.height,
        });

        this.add(this._frame);
    }

    color(fill: string) {
        this._frame.fill(fill);

        return this;
    }

    outlite({width, color}: OutlineConfig) {
        if (width) {
            this._frame.strokeWidth(width);
        }

        if (color) {
            this._frame.stroke(color);
        }

        return this;
    }
}

export {BaseLayer};
