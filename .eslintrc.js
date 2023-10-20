/** @type {import('eslint-define-config').ESLintConfig}*/
module.exports = {
    extends: ['@diplodoc/eslint-config', '@diplodoc/eslint-config/prettier'],
    overrides: [
        {
            files: ['*.ts'],
            parser: '@typescript-eslint/parser',
            rules: {
                '@typescript-eslint/no-non-null-assertion': 'off',
            },
            parserOptions: {
                tsconfigRootDir: __dirname,
                project: ['tsconfig.json'],
            },
        },
    ],
};
