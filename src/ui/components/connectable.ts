import Konva from 'konva';

import {BaseComponent} from './base';
import {unique} from '../../utils';

type VerticalAxis = 'top' | 'middle' | 'bottom';
type HorizontalAxis = 'left' | 'middle' | 'right';

type ConnectPosition = `${VerticalAxis}-${HorizontalAxis}` | {x: number; y: number};

type AllowedConnections = ConnectPosition[];

type Props = {
    radius?: number;
    fill?: string;
    fillHover?: string;
};

type ConnectionPart = {
    component: ConnectableComponent;
    id: number;
};

type ConnectionCell = {
    usedId: number;
    connectedPoint: Point2D;
    other: ConnectionPart;
};

type RegisteredConnection = {
    first: ConnectionPart;
    second: ConnectionPart;
};

type ConnectionState = {
    inProgress: ConnectionPart | undefined;
    connections: Map<ConnectableComponent, Map<Konva.Line, ConnectionCell>>;
    registered: RegisteredConnection[];
};

class ConnectableComponent<T extends Props = Props> extends BaseComponent<T> {
    private static _connection: ConnectionState = {
        inProgress: undefined,
        connections: new Map(),
        registered: [],
    };

    private static addConnection(
        first: ConnectionPart,
        second: ConnectionPart,
        line: Konva.Line,
        point: Point2D,
    ) {
        const {component: from, id} = first;
        const {connections} = this._connection;
        const oldConnections = connections.get(from);

        if (oldConnections) {
            oldConnections.set(line, {usedId: id, connectedPoint: point, other: second});

            return;
        }

        connections.set(
            from,
            new Map([[line, {usedId: id, connectedPoint: point, other: second}]]),
        );
    }

    protected _allowedConnections: AllowedConnections;
    protected _points: Konva.Circle[] = [];
    protected _shouldRender = false;
    protected _uid: string;

    constructor(allowedConnections: AllowedConnections, props: ComponentProps<T>) {
        super(props);

        this.name(`${this.name()} connectable`);

        this._uid = unique('connectabe');
        this._allowedConnections = allowedConnections;
    }

    onDrag() {
        const connections = ConnectableComponent._connection.connections.get(this);

        if (!connections) {
            return;
        }

        const registered: RegisteredConnection[] = [];

        for (const cell of connections) {
            const [line, {other, usedId}] = cell;

            connections.delete(line);
            ConnectableComponent._connection.connections.get(other.component)!.delete(line);

            line.destroy();

            registered.push({
                first: {
                    id: usedId,
                    component: this,
                },
                second: other,
            });
        }

        while (registered.length) {
            const {first, second} = registered.pop()!;

            this.parent!.add(this.createLine(first, second));
        }
    }

    build() {
        this.addEventListener('dragmove', this.onDrag);
        this._allowedConnections.forEach(this.addPoint.bind(this));

        return this;
    }

    toggle() {
        this._points.forEach((point) => {
            if (this._shouldRender) {
                point.hide();

                return;
            }
            point.show();
        });

        this._shouldRender = !this._shouldRender;
    }

    connect(to: ConnectableComponent, id: number) {
        if (!ConnectableComponent._connection.inProgress) {
            ConnectableComponent._connection.inProgress = {
                component: to,
                id,
            };

            return;
        }

        const {component: from} = ConnectableComponent._connection.inProgress;

        if (from._uid === to._uid) {
            ConnectableComponent._connection.inProgress = undefined;

            return;
        }

        const line = this.createLine(ConnectableComponent._connection.inProgress, {
            component: to,
            id,
        });

        this.parent!.add(line);

        ConnectableComponent._connection.inProgress = undefined;
    }

    protected createLine(first: ConnectionPart, second: ConnectionPart): Konva.Line {
        const {component: from, id: oldId} = first;
        const {component: to, id} = second;

        const startPoint = from._points[oldId];
        const nextPoint = to._points[id];

        const old = startPoint.getAbsoluteTransform().decompose();
        const next = nextPoint.getAbsoluteTransform().decompose();

        const line = new Konva.Line({
            points: [next.x, next.y, old.x, old.y],
            stroke: 'yellow',
            strokeWidth: 10,
        });

        ConnectableComponent.addConnection(first, second, line, next);
        ConnectableComponent.addConnection(second, first, line, old);

        return line;
    }

    private point(at: ConnectPosition): Point2D {
        if (typeof at === 'object') {
            return at;
        }

        const [vertical, horizontal] = at.split('-');

        const verticalAxis: Record<VerticalAxis, number> = {
            top: 0,
            middle: 0.5,
            bottom: 1,
        };

        const horizontalAxis: Record<HorizontalAxis, number> = {
            left: 0,
            middle: 0.5,
            right: 1,
        };

        const y = this.height() * verticalAxis[vertical as VerticalAxis];
        const x = this.width() * horizontalAxis[horizontal as HorizontalAxis];

        return {x, y};
    }

    private addPoint(at: ConnectPosition, id: number) {
        const {x, y} = this.point(at);
        const {radius, fill, fillHover} = this._props;

        const circle = new Konva.Circle({x, y, radius, fill, name: this._uid});

        circle.addEventListener('mouseenter', () => {
            circle.fill(fillHover!);
        });

        circle.addEventListener('mouseleave', () => {
            circle.fill(fill!);
        });

        circle.addEventListener('click', () => {
            this.connect(this, id);
        });

        circle.hide();

        this._points.push(circle);
        this.add(circle);
    }
}

ConnectableComponent.defaultProps = {
    fill: 'red',
    fillHover: 'blue',
    radius: 10,
} satisfies Partial<Props>;

export {ConnectableComponent};

declare global {
    export type Connectable<T> = T & Props;
}
