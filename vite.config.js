const {default: tsconfigPaths} = require('vite-tsconfig-paths');

/** @type {import("vite").UserConfig} */
module.exports = {
    plugins: [tsconfigPaths()],
};
