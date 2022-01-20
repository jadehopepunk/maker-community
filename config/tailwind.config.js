const { colors } = require("tailwindcss/defaultTheme");
const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: ["./app/helpers/**/*.rb", "./app/javascript/**/*.js", "./app/views/**/*"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        "blue-dark": "#2a3166",
        "blue-dark-highlight": "#4d5ab6",
        sky: "#78CEE1",
        "sky-light": "#94d8e7",
        "pink-dark": "#ee7879",
        "pink-very-dark": "#6D3F46",
        "pink-light": "#f4abaa",
        "teal-dark": "#0D9488",
        gold: "#EFBF6E",
        beige: "#E1A994",
      },
    },
  },
  plugins: [require("@tailwindcss/forms"), require("@tailwindcss/aspect-ratio"), require("@tailwindcss/typography")],
};
