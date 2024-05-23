type EquipmentPort = {
    /** relative to [0, 0] of EquipmentEntity */
    position: [number, number];
    /**
     * type of connection: wire or other equipment's id
     * if is undefined access via wires only
     */
    access?: string;
};

export type PhysicsNotation = {
    initial?: Record<string, number>;
    /** optional, component may be generator (like battery) */
    dependsOn?: string[];
    /** in system SI */
    constants: Record<string, number>;
    produces: Record<string, string>;
};

export type EquipmentEntity = {
    title?: string;
    count?: number;
    measure: [number, number];
    ports?: EquipmentPort[];
    src: {
        base: string;
        active?: string;
    };
    physics: PhysicsNotation;
};

export type Equipments = Record<string, EquipmentEntity>;

/** [from, to, count of connections] */
export type Connection = [string, string, number | undefined];

export type Config = {
    cell: {
        width: number;
        height: number;
    };
    equipment: Equipments;
    proofOfDone: {
        required: string[];
        connections: Connection[];
    };
    entry: string;
};
