module.exports = {
  env: {
    browser: true,
    node: true,
    es2021: true,
    jest: true,
  },
  extends: ["eslint:recommended", "plugin:import/errors", "plugin:import/warnings"],
  parserOptions: {
    ecmaVersion: "latest",
    sourceType: "module",
  },
  rules: {
    // Error prevention
    "no-console": ["warn"],
    "no-debugger": ["warn"],
    "no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
    "no-duplicate-imports": ["error"],
    "no-var": ["error"],
    "prefer-const": ["error"],

    // Style consistency
    indent: ["error", 2],
    quotes: ["error", "single", { allowTemplateLiterals: true }],
    semi: ["error", "always"],
    "comma-dangle": ["error", "always-multiline"],
    "arrow-parens": ["error", "always"],
    "max-len": ["warn", { code: 100, ignoreUrls: true }],

    // Import organization
    "import/order": [
      "error",
      {
        groups: ["builtin", "external", "internal", "parent", "sibling", "index"],
        "newlines-between": "always",
        alphabetize: { order: "asc", caseInsensitive: true },
      },
    ],

    // Accessibility
    "jsx-a11y/alt-text": ["error"],
    "jsx-a11y/anchor-has-content": ["error"],
    "jsx-a11y/aria-props": ["error"],
    "jsx-a11y/aria-role": ["error"],
  },
  settings: {
    "import/resolver": {
      node: {
        extensions: [".js", ".jsx", ".ts", ".tsx"],
      },
    },
  },
  overrides: [
    // TypeScript specific rules
    {
      files: ["**/*.ts", "**/*.tsx"],
      extends: ["plugin:@typescript-eslint/recommended", "plugin:import/typescript"],
      parser: "@typescript-eslint/parser",
      rules: {
        "@typescript-eslint/explicit-function-return-type": ["warn"],
        "@typescript-eslint/no-explicit-any": ["warn"],
        "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
      },
    },
    // React specific rules
    {
      files: ["**/*.jsx", "**/*.tsx"],
      extends: [
        "plugin:react/recommended",
        "plugin:react-hooks/recommended",
        "plugin:jsx-a11y/recommended",
      ],
      rules: {
        "react/prop-types": ["warn"],
        "react/react-in-jsx-scope": ["off"],
        "react-hooks/rules-of-hooks": ["error"],
        "react-hooks/exhaustive-deps": ["warn"],
      },
      settings: {
        react: {
          version: "detect",
        },
      },
    },
  ],
};
