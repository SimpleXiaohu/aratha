const { wrapText } = require("./markdown.js");

//Attack String :""+"a"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\u0000";

const options = {
  flattenText: true,
  maxColumns: 50,
};
var result = wrapText(str, options, "");

// real    0m0.123s
// user    0m0.088s
// sys     0m0.020s
