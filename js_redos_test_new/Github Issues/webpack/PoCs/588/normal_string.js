const { dashesCamelCase } = require("./conventions.js");

//Attack String :""+"a"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\u0000";

var result = dashesCamelCase(str);

// real    0m0.145s
// user    0m0.102s
// sys     0m0.020s
