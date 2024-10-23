import { s } from "./emulation.js";

//Attack String :""+"@url("*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\u0000";

var e = {
  image: str,
};
var obj = new s();
console.log(obj.modeImage(e));

// real    0m0.075s
// user    0m0.063s
// sys     0m0.009s
