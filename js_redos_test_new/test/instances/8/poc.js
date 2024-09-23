"use strict";

var _toWarnDev = require("./toWarnDev.js");
//Attack String :""+"at "*100000+"\n@@"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "at ";
}
str += "\n@@";
var result = (0, _toWarnDev.normalizeCodeLocInfo)(str);
console.log(result);

// real    0m13.810s
// user    0m13.751s
// sys     0m0.040s