"use strict";

var _utils = require("./utils.js");
//Attack String :""+"Check your code at 1:"*100000+"a@"
var String = "";
for (var i = 0; i < 100000; i++) {
  String += "Check your code at 1:";
}
String += "a@";
var result = (0, _utils.normalizeCodeLocInfo)(String);
console.log(result);

// real    1m46.375s
// user    1m44.974s
// sys     0m0.010s

//但属于__test__