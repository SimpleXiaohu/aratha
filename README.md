# Aratha based on ostrich

## Running the analysis

First, install the dependencies by running
```
$ npm install
```
from this directory. To analyze a script, run
```
$ npm run analyze -- <path to script>
```
from this directory.

### OSTRICH_PATH

The default solver is G-Strings. 
Alternatively, you can use an SMT solver by setting environment variables `SOLVER=ostrich` and `OSTRICH_PATH` to the executable file of [ostrich](https://github.com/uuverifiers/ostrich).
```
$ export SOLVER=ostrich
$ export OSTRICH_PATH=executable-file-of-ostrich
```
## Tests
The tests are written with [Mocha](https://mochajs.org/). To run them, run
`npm test` from this directory.
