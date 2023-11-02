import Konva from 'konva';
import {state} from '@labs/state';
import {assert} from '@labs/utils';

interface IBaseComponent<AddtitionalProperties extends {} = {}> {
    _props: AddtitionalProperties & RequiredProps;
    defaultProps?: AddtitionalProperties;
    registerCallback<Event extends EventName>(
        name: Event,
        callback: EventCallback<Konva.Group, Event>,
    ): void;
    /**
     * x and y are relative to parent
     * @param component target component
     * @param at position to insert
     * @description renders @type {BaseComponent} element into current elemet
     */
    render(component: BaseComponent, at: Point2D): boolean;

    /**
     *
     * @param layer target layer
     * @param at position to insert
     * @description attaches this component into given layer
     */
    attach(layer: Konva.Layer, at: Point2D): boolean;

    mount(): Konva.Group;
    unmount(): void;
}

type EventHandlers<This> = {
    [name in EventName]?: EventCallback<This, name>[];
};

type Primitive = string | number | boolean;
type Config = Record<string, {} | Primitive | Primitive[]>;

function applyDefaultProps<T extends Config>(props: T, defaultProps: Record<string, unknown>): T {
    if (!defaultProps) {
        return props;
    }

    const result: Record<string, unknown> = {};

    for (const key of Object.keys(defaultProps)) {
        if (Object.hasOwn(props, key)) {
            if (typeof props[key] === 'object' && !Array.isArray(props[key])) {
                // @ts-ignore
                result[key] = applyDefaultProps(props[key], defaultProps[key]);

                continue;
            }

            result[key] = props[key];

            continue;
        }

        result[key] = defaultProps[key];
    }

    for (const key of Object.keys(props)) {
        if (Object.hasOwn(result, key)) {
            continue;
        }

        if (typeof props[key] === 'object' && !Array.isArray(props[key])) {
            // @ts-ignore
            result[key] = applyDefaultProps(props[key], defaultProps[key]);

            continue;
        }

        result[key] = props[key];
    }

    return result as T;
}

class BaseComponent<T extends {} = RequiredProps> extends Konva.Group implements IBaseComponent<T> {
    static defaultProps: Record<string, unknown>;

    protected static _extractSizeFromProps(props: RequiredProps) {
        if ('measure' in props) {
            const [widthInCells, heigthInCells] = props.measure;

            return state.size(widthInCells, heigthInCells);
        }

        return props;
    }

    _handlers: EventHandlers<unknown> = {};
    _props: T & RequiredProps;

    protected _position: Point2D | undefined;
    protected _element: Konva.Group | undefined;

    constructor(props: ComponentProps<T>) {
        super(props);

        // ngl this is bad
        // @ts-ignore
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        this._props = applyDefaultProps(props, this.constructor.defaultProps);

        const {width, height} = BaseComponent._extractSizeFromProps(this._props);

        this.width(width);
        this.height(height);

        this.registerCallback('dragstart', () => {
            assert(typeof this._position === 'undefined');

            this._position = this.getAbsolutePosition();
        });

        this.registerCallback('dragend', () => {
            assert(typeof this._position !== 'undefined');

            const {
                // eslint-disable-next-line @typescript-eslint/no-shadow
                cell: {width, height},
            } = state.config();

            const {x, y} = this.getAbsolutePosition();

            this.x(x - (x % width));
            this.y(y - (y % height));

            this._position = undefined;
        });
    }

    registerCallback<Event extends EventName>(
        name: Event,
        callback: Konva.KonvaEventListener<unknown, GlobalEventHandlersEventMap[Event]>,
    ): void {
        if (!this._handlers[name]) {
            this._handlers[name] = [];
        }

        this._handlers[name]!.push(callback);

        this.on(name, callback);
    }

    render(
        component: BaseComponent | Konva.Group,
        at: Point2D | BoardPosition = {x: 0, y: 0},
    ): boolean {
        const {width: x, height: y} = Array.isArray(at)
            ? state.size(...at)
            : {width: at.x, height: at.y};

        const element = component instanceof BaseComponent ? component.mount() : component;

        element.x(x).y(y);

        this.add(element);

        return true;
    }

    attach(layer: Konva.Layer, at: Point2D | BoardPosition = {x: 0, y: 0}): boolean {
        const {width: x, height: y} = Array.isArray(at)
            ? state.size(...at)
            : {width: at.x, height: at.y};

        const element = this.mount();

        element.x(x).y(y);

        layer.add(element);

        return true;
    }

    mount(): Konva.Group {
        if (this._element) {
            return this._element;
        }

        this._element = this.build();

        return this._element;
    }

    build(): Konva.Group {
        throw new Error('Method build should be implemented in child class');
    }

    unmount(): void {
        for (const [name, callbacks] of Object.entries(this._handlers)) {
            while (callbacks.length) {
                this.off(name, callbacks.pop());
            }
        }

        this.destroy();
    }
}

export {BaseComponent};
