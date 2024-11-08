import { splitCR } from "./util.js";

//Attack String :""+"a"*100000+"◎"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "◎";

console.log(splitCR(str));

// real    0m0.145s
// user    0m0.111s
// sys     0m0.010s
