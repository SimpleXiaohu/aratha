const ProgressPlugin = require("./ProgressPlugin.js");

//Attack String :""+"a"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\u0000";

var result = ProgressPlugin.createDefaultHandler(true, "a")(1, str);

// real    0m0.164s
// user    0m0.127s
// sys     0m0.009s
