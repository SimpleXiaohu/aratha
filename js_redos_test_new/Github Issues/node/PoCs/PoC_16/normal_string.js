import { Script } from "./profile.mjs";

//Attack String :""+"a"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\u0000";

const script = new Script();
script.update("a", str);
const result = script.ensureSourceMapCalculated();

// real    0m0.118s
// user    0m0.086s
// sys     0m0.008s
