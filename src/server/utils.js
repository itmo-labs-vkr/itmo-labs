const filename = (name) => {
    return name.split('.')[0];
};

const assets = {
    base(name) {
        return `assets/${filename(name)}.jpg`;
    },
    active(name) {
        return `assets/${filename(name)}.active.jpg`;
    },
};

module.exports = {
    filename,
    assets,
};
