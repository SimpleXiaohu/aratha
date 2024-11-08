import Demo from "./Demo.js";

//Attack String :""+"a"*100000+"\n@"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "a";
}
str += "\n@.ts";

const porps = {
  demo: "",
  demoOptions: {
    hideToolbar: "a",
    demo: str,
    defaultCodeOpen: false,
    disableAd: false,
  },
  disableAd: "",
  githubLocation: "",
  mode: "",
};

var result = Demo(porps);

// real    0m0.195s
// user    0m0.062s
// sys     0m0.009s
