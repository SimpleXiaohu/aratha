const htmlToText = require("./jsHtmlToText.js");

//Attack String :""+"aaaa"*100000+""
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "aaaa";
}
str += "";

var result = htmlToText(str, "");

// real    0m0.117s
// user    0m0.073s
// sys     0m0.032s
