import { createLogAssertion } from "./consoleMock.js";

//Attack String :""+"Check your code at "*100000+"\u0000"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "aaaaaaaaaaaaaaaaaaa";
}
str += "a";

//成功的调用路径：createLogAssertion(将__DEV__改为了true)
const callback = () => {
  return [[1, 2], ""];
};
const myFunc = createLogAssertion("", "b", callback);
console.log(myFunc([str]));

// real    0m0.035s
// user    0m0.019s
// sys     0m0.009s
