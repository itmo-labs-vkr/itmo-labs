import Konva from 'konva';

export const FONT_SIZE = 14;

declare global {
    export type EventName = keyof GlobalEventHandlersEventMap;
    export type EventCallback<This, Name extends EventName> = Konva.KonvaEventListener<
        This,
        GlobalEventHandlersEventMap[Name]
    >;

    export type Point2D = {
        x: number;
        y: number;
    };

    export type RequireGeometry<T> = T & {
        width: number;
        height: number;
    };
}
