const formatWebpackMessages = require("./formatWebpackMessages.js");

//Attack String :"\n"+"a"*100000+"\u0000"
var str = "\n";
for (var i = 0; i < 100000; i++) {
  str += "aaaaaaaaaaaaaaaaa";
}
str += "\u0000";

const json = {
  errors: ["", str],
  warnings: [],
};
var result = formatWebpackMessages(json);

// real    0m0.143s
// user    0m0.107s
// sys     0m0.018s
