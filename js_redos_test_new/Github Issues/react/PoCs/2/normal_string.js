import IssueList from "./IssueList.js";

// Attack String :""+" "*100000+"@"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "a";

var obj = {
  issues: str,
};
console.log(IssueList(obj));


// real    0m0.037s
// user    0m0.014s
// sys     0m0.013s