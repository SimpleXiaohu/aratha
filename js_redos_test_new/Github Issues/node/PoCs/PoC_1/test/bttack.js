const pacote = require('pacote');

// var str = "";
// for (var i = 0; i < 1000000; i++) {
//   str += "#";
// }
// str += "\n@";

// const spec = {
//   rawSpec: str,
//   hosted: null,
// };

// addGitSha(spec, "");


// pacote.resolve("https://git@github.com/user/repo.git#"+str,"https://git@github.com/user/repo.git#"+str)

pacote.resolve("git+ssh://git@some-host:user/repo#")
  .then(resolved => {
    console.log('Resolved package:', resolved);
  })
  .catch(err => {
    console.error('Error resolving package:', err);
  });