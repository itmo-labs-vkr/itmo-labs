import fs from 'node:fs';
import path from 'node:path';

const equipment = () => {
    return JSON.parse(fs.readFileSync(path.join(__dirname, '_local.json')).toString());
};

export default equipment;
