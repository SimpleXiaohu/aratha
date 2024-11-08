const { diffSentences } = require("./diff.js");

//Attack String :""+" "*100000+" "
var str = "";
for (var i = 0; i < 100000; i++) {
  str += " ";
}
str += " ";

var result = diffSentences(str, "", "");

// real    0m0.151s
// user    0m0.106s
// sys     0m0.020s
