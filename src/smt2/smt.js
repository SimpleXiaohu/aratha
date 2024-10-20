"use strict";

const fs = require("fs");

const _ = require("lodash");

const sexpr = require("../sexpr");
const { myLog } = require("../util/print");

exports.SMTSolver = class SMTSolver {

    constructor(process) {
        this._callbackQueue = [];
        this._commandLogs = [];
        this.output_log = "";

        process.stdout.setEncoding("utf8");
        process.stderr.setEncoding("utf8");

        const parser = new sexpr.Parser();
        process.stdout.on("data", (data) => {
            // record the output of smt solver to the commandlogs files.
            const comments = data.trim().split("\n").map((s) => "; " + s).join("\n") + "\n";
            for (let i = 0; i < this._commandLogs.length; i++) {
                this._commandLogs[i].write(comments, "utf8");
            }
            parser.parse(data, (stmt) => {
                this._consume(stmt);
            });
        });
        // huzi add
        process.stderr.on("data", (data) => {
            throw new Error(data)
        })
        // process.stderr.on("data", console.error);
        process.stdin.on("error", console.error);
        this.process = process;
    }
    
    logCommands(stream) {
        this._commandLogs.push(stream);
    }

    loadFiles(paths) {
        _.forEach(paths, (path) => {
            this._write(fs.readFileSync(path, { encoding: "utf8" }));
        });
    }

    push(n) {
        this._send(["push", n.toString()]);
    }

    pop(n) {
        this._send(["pop", n.toString()]);
    }

    async checkSat() {
        this._send(["check-sat"]);
        return this._getResponse();
    }

    declareConst(name, sort) {
        this._send(["declare-const", name, sort]);
    }

    addSmtLog(log) {
        if (process.env.SMTLOG){
            this._send(["set-info", ":description", '"log:', log, '"'])
        }
    }
    // declareConst(name, sort, isStr) {
    //     this._send(["declare-const", name, sort]);
    //     // huzi add, naive consider all input is string(for ostrich benchmark generation)
    //     if(isStr){
    //         this._send(["assert", ["is-Str", name]]);
    //     }
    //     if(isStr || sort === "String"){
    //         // the unicode \u{0000} is a special char which stand for null res in ostrich.
    //         this._send(["assert", ["str.in_re", ["str", name],
    //             ["re.*", ["re.range", '"\\u{0001}"', '"\\u{FFFF}"']]]])
    //     }
    // }

    assert(formula) {
        this._send(["assert", formula]);
    }

    getValue(vars) {
        this._send(["get-value", vars]);
        return this._getResponse();
    }

    getModel() {
        this._send(["get-model"]);
        return this._getResponse();
    }

    getUnsatCore() {
        this._send(["get-unsat-core"]);
        return this._getResponse();
    }

    close() {
        try {
            this._send(["exit"]);
        } catch (e) {
            console.error("error while closing:", e);
        }
    }

    _send(command) {
        // myLog("sending command: " + sexpr.stringify(command));
        this._write(sexpr.stringify(command) + "\n");
    }

    _write(output) {
        for (let i = 0; i < this._commandLogs.length; i++) {
            this._commandLogs[i].write(output, "utf8");
        }
        // huzi note, pass the input to solver
        this.output_log += output + "\n";
        this.process.stdin.write(output);
    }

    writeRegexConstraint(output) {
        output = output.replace("str.in.re", "str.in_re")+ "\n";
        this.output_log += output + "\n";
        this.process.stdin.write(output);
    }

    async _enqueueCallback(callback) {
        this._callbackQueue.push(callback);
    }

    _consume(stmt) {
        const callback = this._callbackQueue.shift();
        if (callback) {
            callback(stmt);
        } else {
            console.error(`received ${stmt}, but there is no callback`);
        }
    }

    async _getResponse() {
        return new Promise((resolve, reject) => {
            this._enqueueCallback((stmt) => {
                if (stmt[0] !== "error") {
                    resolve(stmt);
                } else {
                   // FIXME: Workaround to avoid Error: write EPIPE
                   // at WriteWrap.afterWrite [as oncomplete]
                   // huzi add
                //    console.log(stmt[1]);
                //    fail
                    // reject(new Error(stmt[1]));
                    throw new Error(stmt[1]);
                }
            });
        });
    }
};
