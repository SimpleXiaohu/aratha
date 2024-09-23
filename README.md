# Aratha_Redos

A tool to analyze regular expressions for ReDoS vulnerabilities in JavaScript.

## Before Running
You should install the path of related tools by the following cmd:
```
$ ./importToolPath.sh
```

## Running the analysis

First, install the dependencies by running
```
$ npm install
```
from this directory. To analyze a script, run
```
$ npm run analyze -- <path to script>
```


### Arguments

```
$ SOLVER=<solver> npm run analyze -- <path to script>
```
Four solvers are available: cvc5, z3, z3str3, and ostrich. The default solver is ostrich.

### A simple example

To analyze the script `string_test\redos.js`, run 
```
$ npm run analyze -- string_test\redos.js
```

### Runing the tests

To run the tests, run
```
$ npm test
```

### On going

We are currently working on including more features and improving the performance of the tool.



