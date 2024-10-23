const { argument } = require("./escape.js");

//Attack String :""+"a"*100000+"◎"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "◎";

console.log(argument(str));

// real    0m0.123s
// user    0m0.093s
// sys     0m0.009s
