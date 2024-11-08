import { migrate_svelte_ignore } from "./extract_svelte_ignore.js";

//Attack String :"aaaaaaaaaaaaaa"+"A"*100000+"-"
var str = "aaaaaaaaaaaaaa";
for (var i = 0; i < 100000; i++) {
  str += "A";
}
str += "-";

var result = migrate_svelte_ignore(str);

// real    0m0.074s
// user    0m0.052s
// sys     0m0.010s
