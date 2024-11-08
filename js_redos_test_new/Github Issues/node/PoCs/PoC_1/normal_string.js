const addGitSha = require("./add-git-sha.js");

//Attack String :""+"a"*100000+"\n@"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\n@";

const spec = {
  rawSpec: str,
  hosted: null,
};
console.log(addGitSha(spec, ""));

// real    0m0.303s
// user    0m0.147s
// sys     0m0.011s
