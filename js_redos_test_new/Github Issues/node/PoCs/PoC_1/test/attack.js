const addGitSha = require('pacote/lib/util/add-git-sha');

var str = "";
for (var i = 0; i < 1000000; i++) {
  str += "#";
}
str += "\n@";

const spec = {
  rawSpec: str,
  hosted: null,
};

addGitSha(spec, "");