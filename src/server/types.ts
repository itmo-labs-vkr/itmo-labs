type EquipmentPort = {
    /** relative to [0, 0] of EquipmentEntity */
    position: [number, number];
    /**
     * type of connection: wire or other equipment's id
     * if is undefined access via wires only
     */
    access?: string;
};

export type EquipmentEntity = {
    name: string;
    measure: [number, number];
    ports?: EquipmentPort[];
    src: {
        base: string;
        active?: string;
    };
};

export type Equipments = Record<string, EquipmentEntity>;
export type Config = {
    cell: {
        width: number;
        height: number;
    };
    equipment: Equipments;
};
