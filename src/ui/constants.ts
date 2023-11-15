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

    export type BoardPosition = [number, number];

    export type RequireGeometry<T> = T & {
        width: number;
        height: number;
    };

    type RequiredProps =
        | {
              width: number;
              height: number;
          }
        | {
              measure: [number, number];
          };

    export type ComponentProps<T = {}> = T & RequiredProps & Partial<Konva.ShapeConfig>;

    export type LayerEvent<Event> = Event & {
        layerX: number;
        layerY: number;
    };
}
