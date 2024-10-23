const { replaceBase } = require("./template-common.js");

//Attack String :""+"aaaaaaaaaaaaa"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "aaaaaaaaaaaaa";
}
str += "\u0000";

var result = replaceBase(str);

// real    0m0.230s
// user    0m0.118s
// sys     0m0.010s
