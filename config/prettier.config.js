/** @type {import('prettier').Config} */
module.exports = {
  endOfLine: "lf",
  semi: false,
  singleQuote: false,
  tabWidth: 2,
  trailingComma: "es5",
  printWidth: 140,
  overrides: [
    {
      files: ["**/*.md"],
      options: {
        tabWidth: 4,
      },
    },
  ],
}
