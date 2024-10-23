const pkg = require("./modules.js");
const getForks = pkg.getForks;

//Attack String :""+"/"*100000+"\n@"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "aa";

console.log(getForks("", str, "", ""));


// real    0m0.071s
// user    0m0.041s
// sys     0m0.000s