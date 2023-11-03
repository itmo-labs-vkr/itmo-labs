const s3 = require('./s3');
const utils = require('./utils');

const equipment = async () => {
    const entities = await s3.folder('equipment');
    const result = [];

    for (const [name, file] of entities) {
        const speca = JSON.parse(await s3.get(file.Key));

        speca.name = utils.filename(name);

        speca.src = {
            base: await s3.get(utils.assets.base(name), 'link'),
            active: await s3.get(utils.assets.active(name), 'link'),
        };

        result.push(speca);
    }

    return result;
};

module.exports = equipment;
