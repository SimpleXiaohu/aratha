import { cliui } from "./index.js";

//Attack String :""+"a"*100000+"!"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "!";

const mixin = {
  stripAnsi: () => {
    return str;
  },
};
const ui = cliui(null, mixin);
console.log(ui.measurePadding(str));

// real    0m0.156s
// user    0m0.107s
// sys     0m0.024s
