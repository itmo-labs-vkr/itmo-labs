import Konva from 'konva';

import {state} from '@labs/state';

import type {BaseLayer} from '@labs/layers';

interface IBaseComponent<
    AddtitionalProperties extends {} = {},
    State extends {} | undefined = undefined,
> {
    _props: AddtitionalProperties & RequiredProps;
    _state: State;
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

class BaseComponent<Props extends {} = RequiredProps, State extends {} | undefined = undefined>
    extends Konva.Group
    implements IBaseComponent<Props, State>
{
    static defaultProps: Record<string, unknown>;

    protected static _extractSizeFromProps(props: RequiredProps) {
        if ('measure' in props) {
            const [widthInCells, heigthInCells] = props.measure;

            return {...state.size(widthInCells, heigthInCells), measure: props.measure};
        }

        return {...props, measure: undefined};
    }

    _handlers: EventHandlers<unknown> = {};
    _props: Props & RequiredProps;
    _state: State;

    /**
     * marks conmponent as part of lab (like Cell, Button)
     */
    isEnvironment = true;

    /**
     * [width, height]
     */
    measure: [number, number] | undefined;

    protected _element: Konva.Group | undefined;

    constructor(props: ComponentProps<Props>) {
        super(props);

        // ngl this is bad
        // @ts-ignore
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        this._props = applyDefaultProps(props, this.constructor.defaultProps);
        this._state = this.state();

        const {width, height, measure} = BaseComponent._extractSizeFromProps(this._props);

        this.measure = measure;

        this.width(width);
        this.height(height);
    }

    movable() {
        this.draggable(true);
        this.registerCallback('dragend', () => {
            const {
                cell: {width, height},
            } = state.config();

            const {x, y} = this.getAbsolutePosition();

            this.x(x - (x % width));
            this.y(y - (y % height));
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

        this.configure();

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

    layer(): BaseLayer {
        const layer = this.getLayer();

        if (!layer) {
            throw new Error('Unbale to get layer');
        }

        return layer as BaseLayer;
    }

    /**
     * Used to configure component's event
     * @returns nothing
     */
    protected configure() {}

    /**
     * used to initialize component's state
     * @returns initial state
     */
    protected state(): State {
        return undefined as State;
    }
}

export {BaseComponent};
