module.exports = {
  root: false,
  env: {
    browser: true,
    es2022: true,
    node: true
  },
  parserOptions: {
    ecmaVersion: "latest",
    sourceType: "module"
  },
  ignorePatterns: [
    "dist",
    "coverage",
    "node_modules",
    ".next",
    ".dart_tool",
    "build"
  ],
  rules: {
    "no-console": "off"
  }
};
