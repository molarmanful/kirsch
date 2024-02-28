import js from '@eslint/js'
import unocss from '@unocss/eslint-config/flat'
import prettier from 'eslint-config-prettier'
import imprt from 'eslint-plugin-import'
import svelte from 'eslint-plugin-svelte'
import globals from 'globals'
import svelteParser from 'svelte-eslint-parser'

export default [
  {
    ignores: [
      '.svelte-kit/**/*',

      'build/**/*',
      '.DS_Store',
      'node_modules',
      '/build',
      '/.svelte-kit',
      '/package',
      '.env',
      '.env.*',
      '!.env.example',
      'pnpm-lock.yaml',

      'package-lock.json',
      'yarn.lock',
    ],
  },

  js.configs.recommended,

  {
    languageOptions: {
      parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
      },
    },
  },

  {
    files: ['**/*.svelte'],
    languageOptions: {
      parser: svelteParser,
    },
    plugins: {
      svelte,
    },
    rules: {
      ...svelte.configs.base.overrides[0].rules,
      ...svelte.configs.prettier.rules,
      'svelte/sort-attributes': 1,
    },
  },

  {
    languageOptions: {
      globals: {
        ...globals.node,
        ...globals.browser,
      },
    },
    plugins: {
      import: imprt,
    },
    settings: {
      'import/parsers': {
        espree: ['.js'],
      },
    },
    rules: {
      'import/export': 2,
      'import/no-duplicates': 1,
      'import/order': [
        1,
        {
          alphabetize: {
            order: 'asc',

            caseInsensitive: true,
          },
          'newlines-between': 'always',
        },
      ],
      'sort-imports': [
        1,
        {
          ignoreDeclarationSort: true,
        },
      ],
    },
  },

  {
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      globals: {
        ...globals.node,
        ...globals.browser,
      },
    },
    rules: {
      'no-unused-vars': 1,
    },
  },

  unocss,

  prettier,
]
