type EquipmentPort = {
    /** relative to [0, 0] of EquipmentEntity */
    position: [number, number];
    /** type of connection: wire or other equipment's id */
    access: string;
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

export type Configuration = Record<string, EquipmentEntity>;
