type Geometry = {
    width: number;
    height: number;
};

const config = {
    cell: {
        width: 100,
        height: 100,
    },
    geometry: {} as Geometry,
};

function setup(geometry: Geometry) {
    Object.assign(config.geometry, geometry);
}

function size(xCells: number, yCells: number): Geometry {
    const {width, height} = config.cell;

    return {
        width: width * xCells,
        height: height * yCells,
    };
}

const state = {
    setup,
    size,
    config() {
        return config;
    },
};

export {state};
