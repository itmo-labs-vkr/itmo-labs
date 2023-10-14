module.exports = {
    extends: '@diplodoc/eslint-config',
    overrides: [
        {
            files: ['*.ts'],
            parser: '@typescript-eslint/parser',
            parserOptions: {
                tsconfigRootDir: __dirname,
                project: ['tsconfig.json'],
            },
        },
    ],
};
