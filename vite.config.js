const {default: tsconfigPaths} = require('vite-tsconfig-paths');
const {viteCommonjs} = require('@originjs/vite-plugin-commonjs');

/** @type {import("vite").UserConfig} */
module.exports = {
    plugins: [tsconfigPaths(), viteCommonjs()],
};
