import Konva from 'konva';

interface IBaseComponent<AddtitionalProperties extends {} = {}> {
    _props: AddtitionalProperties;
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

type BaseProps = {
    width?: number;
    height?: number;
};

class BaseComponent<T extends BaseProps = {}> extends Konva.Group implements IBaseComponent<T> {
    static defaultProps: Record<string, unknown>;

    _handlers: EventHandlers<unknown> = {};
    _props: T;

    protected _element: Konva.Group | undefined;

    constructor(props: Partial<T & Konva.ShapeConfig>) {
        super();

        // ngl this is bad
        // @ts-ignore
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        this._props = applyDefaultProps(props, this.constructor.defaultProps);

        const {width, height} = this._props;

        if (width) {
            this.width(width);
        }

        if (height) {
            this.height(height);
        }
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

    render(component: BaseComponent, at: Point2D = {x: 0, y: 0}): boolean {
        const {x, y} = at;
        const element = component.mount();

        element.x(x).y(y).zIndex(100);

        this.add(element);

        return true;
    }

    attach(layer: Konva.Layer, at: Point2D = {x: 0, y: 0}): boolean {
        const {x, y} = at;
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
