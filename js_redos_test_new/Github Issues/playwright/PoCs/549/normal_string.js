const { renderPlaywrightDevLinks } = require("./linkUtils.js");

//Attack String :""+"a"*100000+"]"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "]";

var result = renderPlaywrightDevLinks(str, "", "");

// real    0m0.131s
// user    0m0.098s
// sys     0m0.011s
