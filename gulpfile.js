"use strict";

const {src, dest, task, parallel, series} = require("gulp");
const htmlmin = require("gulp-htmlmin");
const {minify} = require("terser");
const {resolve} = require("path");
const imagemin = require("gulp-imagemin");
const remove = require("del");
const {optipng} = imagemin;

const HTMLMIN_OPTIONS = {
    caseSensitive: true,
    collapseBooleanAttributes: true,
    collapseInlineTagWhitespace: true,
    collapseWhitespace: true,
    conservativeCollapse: false,
    continueOnParseError: false,
    decodeEntities: true,
    html5: true,
    includeAutoGeneratedTags: false,
    keepClosingSlash: false,
    minifyCSS: true,
    minifyJS: (text) => minify(text).code,
    minifyURLs: true,
    preserveLineBreaks: false,
    preventAttributesEscaping: false,
    processConditionalComments: true,
    processScripts: true,
    quoteCharacter: "'",
    removeAttributeQuotes: true,
    removeComments: true,
    removeEmptyAttributes: true,
    removeEmptyElements: false,
    removeOptionalTags: true,
    removeRedundantAttributes: true,
    removeScriptTypeAttributes: true,
    removeStyleLinkTypeAttributes: true,
    removeTagWhitespace: false,
    sortAttributes: false,
    sortClassName: false,
    useShortDoctype: true
};

const IMAGEMIN_OPTIONS = [
    optipng({
        optimizationLevel: 7
    })
];

task("images", () => {
    return src(resolve("src", "images", "**", "*"))
        .pipe(imagemin(IMAGEMIN_OPTIONS))
        .pipe(dest(resolve("docs", "images")));
});

task("clean", () => {
    return remove([resolve("docs", "**", "*")]);
});
