"use strict";

var _stringUtils = _interopRequireDefault(require("./stringUtils.js"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
//Attack String :"[ "+"]("*100000+"◎"
var str = "[ ";
for (var i = 0; i < 100000; i++) {
  str += "](";
}
str += "◎";
console.log(_stringUtils["default"].stripMarkdown(str));

// real    0m17.896s
// user    0m17.844s
// sys     0m0.040s