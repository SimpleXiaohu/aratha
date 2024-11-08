import { parseSourceFromComponentStack } from "./utils.js";

//Attack String :"at "+" ("*100000+":1"
var str = "at ";
for (var i = 0; i < 100000; i++) {
  str += "aa";
}
str += ":1";

console.log(parseSourceFromComponentStack(str));

// real    0m0.031s
// user    0m0.023s
// sys     0m0.000s