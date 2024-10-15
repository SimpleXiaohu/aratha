"use strict";

const _ = require("lodash");
const { BooleanConstraint, TypeConstraint } = require("./constraint");
const { SymbolicValue, Constant, Variable, Temporary } = require("./symbolic");
const { parseModel } = require("./model");
const Type = require("./type");
const sexpr = require("./sexpr");

//FIXME: Really a quick and dirty workaround - only for SMT solvers atm.
var COLLECT_NOGOODS = false
var NOGOODS = {}
function push_nogoods_smt(name) {
    if (!COLLECT_NOGOODS)
        return
    const fs = require('fs');
    let nogoods;
    try {
        nogoods = eval(
            fs.readFileSync('nogoods.json').toString().split('\n')
        )
    }
    catch (e) {
        nogoods = []
    }
    let input = []
    for (let ng of nogoods) {
        try {
            const i = ng.indexOf("{");
            const j = Math.min(ng.lastIndexOf("}") + 1, ng.length);
            const x = ng.slice(i, j);
            if (x)
                input.push(x)
        }
        catch (e) { }
    }
    for (let i in input) {
        const inp = JSON.parse(input[i])
        let a;
        for (let j in inp) {
            if (j.startsWith('var') && +(name[name.length - 1]) >= +(j[j.length - 1])) {
                const val = inp[j]
                switch (typeof val) {
                    case "string":
                        if (a === undefined)
                            a = ['not', ['=', j, ['Str', '"' + val + '"']]]
                        else
                            a = ['or', a, ['not', ['=', j, ['Str', '"' + val + '"']]]]
                        break
                    case "number":
                        if (a === undefined)
                            a = ['not', ["=", j, ['Num', val]]]
                        else
                            a = ['or', a, ['not', ["=", j, ['Num', val]]]]
                        break
                    case "boolean":
                        if (a === undefined)
                            a = ['not', ["=", j, ['Boolean', val]]]
                        else
                            a = ['or', a, ['not', ["=", j, ['Boolean', val]]]]
                        break
                }
            }
        }
        if (a !== undefined) {
            NOGOODS[sexpr.stringify(a)] = a
        }
    }
}

class ExecutionPath {
    constructor(constraints) {
        this.constraints = constraints || [];
    }

    isEmpty() { return this.constraints.length === 0; }

    addConstraint(booleanExpr, result) {
        const constraint = new BooleanConstraint(booleanExpr, result);
        // if (!_.some(this.constraints, constraint)) {
        this.constraints.push(constraint);
        // console.log("adding constraint", constraint.getId());
        // }
    }

    addTypeConstraint(type, subject, value) {
        const constraint = new TypeConstraint(type, subject, value);
        if (!_.some(this.constraints, constraint)) {
            this.constraints.push(constraint);
        }
    }
}

exports.ExecutionPath = ExecutionPath;

class Trie {
    constructor() {
        this._root = {};
    }

    add(s) {
        let isNew = false;
        let node = this._root;
        for (let i = 0; i < s.length; i++) {
            const w = s[i];
            if (!node.hasOwnProperty(w)) {
                node[w] = {};
                isNew = true;
            }
            node = node[w];
        }
        return isNew;
    }

    hasPrefix(s) {
        let node = this._root;
        for (let i = 0; i < s.length; i++) {
            const w = s[i];
            if (!node.hasOwnProperty(w))
                return false;
            node = node[w];
        }
        return true;
    }
}

class ExecutionPathSet {
    constructor() {
        this._paths = new Trie();
    }

    add(path) { return this._paths.add(this._encode(path)); }

    hasPrefix(path) { return this._paths.hasPrefix(this._encode(path)); }

    _encode(path) {
        // return _.map(path, (c) => (c.value ? "" : "!") + c.getId());
        return _.map(path, (c) => c.value);
    }
}
exports.ExecutionPathSet = ExecutionPathSet;

class ConstraintCollector {
    constructor(solver, incremental = false) {
        this.solver = solver;
        this.incremental = incremental;
        this._constraintStack = [];
        this._polarity = [];
        this._unsyncedIndex = 0;

        this._declaredVariables = new Set();
        this._declaredVariablesByConstraint = [];
    }

    _top() { return _.last(this._constraintStack); }

    _sync() {
        while (this._unsyncedIndex < this._constraintStack.length) {
            const c = this._constraintStack[this._unsyncedIndex];

            const tmp = c.value;
            c.value = this._polarity[this._unsyncedIndex];
            this._activateConstraint(c);
            c.value = tmp;
            this._unsyncedIndex++;
        }
    }

    _activateConstraint(constraint) {
        //        console.log("activating", constraint);
        if (this.incremental || this._unsyncedIndex === 0) {
            this.solver.push(1);
        }
        this._declareVariables(constraint);
        this._defineConstants(constraint);
        this._assertExtraConstraints(constraint);
        this._assert(constraint.toFormula());
    }

    push(constraint) {
        this._constraintStack.push(constraint);
        this._polarity.push(constraint.value);
    }

    pop(n = 1) {
        if (n < 1)
            return;
        const len = this._constraintStack.length;
        const idx = n <= len ? len - n : 0;
        this._constraintStack.length = idx;
        this._polarity.length = idx;

        for (let i = idx; i < this._declaredVariablesByConstraint.length; ++i) {
            for (const el of this._declaredVariablesByConstraint[i]) {
                this._declaredVariables.delete(el);
            }
        }
        this._declaredVariablesByConstraint.length = idx;

        if (idx < this._unsyncedIndex) {
            if (this.incremental) {
                this.solver.pop(this._unsyncedIndex - idx);
                this._unsyncedIndex = idx;
            } else {
                this.solver.pop(1);
                this._unsyncedIndex = 0;
                this._declaredVariables.clear();
                this._declaredVariablesByConstraint.length = 0;
            }
        }
    }

    _collect(expr, f) {
        const stack = [expr];
        while (stack.length > 0) {
            const e = stack.shift();
            if (e instanceof SymbolicValue || e instanceof Temporary) {
                e.visit(f);
            } else if (_.isArray(e)) {
                stack.push(...e);
            } else if (_.isObject(e)) {
                _.forOwn(e, (v) => stack.push(v));
            }
        }
    }

    _declareVariables(expr) {
        const top = new Set();
        this._declaredVariablesByConstraint.push(top);
        this._collect(expr, (expr) => {
            if (expr instanceof Variable) {
                if (!this._declaredVariables.has(expr.name)) {
                    top.add(expr.name);
                    this._declaredVariables.add(expr.name);
                    //huzi add
                    // const isStr = expr.type === Type.STRING
                    // this.solver.declareConst(expr.name, "Val", isStr);
                    this.solver.declareConst(expr.name, "Val");
                    if (expr.type !== Type.TOP)
                        this.solver.assert(new Type(expr.type).constraintFor(expr.toFormula()));
                    push_nogoods_smt(expr.name);
                }
            } else if (expr instanceof Temporary) {
                if (!this._declaredVariables.has(expr.name)) {
                    top.add(expr.name);
                    this._declaredVariables.add(expr.name);
                    this.solver.declareConst(expr.name, expr.sort);
                }
            }
        });
    }

    _defineConstants(expr) {
        this._collect(expr, (expr) => {
            if (expr instanceof Constant && _.isObject(expr.value)) {
                const id = expr.objectId;
                const formula = expr.toObjectFormula();
                // huzi add 
                // this._assert(["=", ["GetProperties", String(id)], formula]);
            }
        });
    }

    _assertExtraConstraints(expr) {
        this._collect(expr, (expr) => {
            if (!(expr instanceof Temporary)) {
                _.forEach(expr.getConstraints(), (c) => this._assert(sexpr.stringify(c)));
            }
        });
    }

    checkSat() {
        this._sync();
        for (let a in NOGOODS) {
            console.log("Adding nogood", a)
            this.solver.assert(NOGOODS[a]);
        }
        return this.solver.checkSat();
    }

    async getModel() {
        let model;
        model = parseModel(await this.solver.getModel());
        this.verifyModel(model);
        return model;
    }

    verifyModel(model) {
        for (let i = 0; i < this._constraintStack.length; ++i) {
            const c = this._constraintStack[i];
            const tmp = c.value;
            c.value = this._polarity[i];
            const result = c.isTrueIn(model);
            if (!result) {
                // huzi add
                console.error(`the expected value is ${c.value}`)
                // throw new Error(`model error: constraint ${c} failed to validate in ${JSON.stringify(model)}`);
                console.error(`model error: constraint ${c} failed to validate in ${JSON.stringify(model)}`);
                //                console.dir(c, {depth:null});
                c.value = tmp;
                return false;
            }
            c.value = tmp;
        }
        return true;
    }

    _assert(formula) {
        this.solver.assert(formula);
    }

    // Make sure that the stack consists of length levels, with each level
    // corresponding to the first length constraints.
    //
    // Assumes that the constraints in the longest common prefix of the
    // polarities of the passed constraints and the constraints on the stack are
    // all equal. (This is true for DSE over deterministic programs.)
    _fixSolverStack(constraints, prefixLength) {
        let i;
        for (i = 0; i < prefixLength && i < this._constraintStack.length; i++) {
            const c = constraints[i];
            if (this._polarity[i] !== c.value) {
                break;
            }
        }
        // console.log("popping ", i);
        this.pop(this._constraintStack.length - i);
        for (; i < prefixLength; i++) {
            this.push(constraints[i]);
            //console.log("pushing ", constraints[i]);
        }
    }

    async solvePrefix(constraints, prefixLength, vars) {
        if (prefixLength <= 0)
            return { status: "sat", model: {} };
        this._fixSolverStack(constraints, prefixLength);
        var status;
        status = await this.checkSat();
        if (status !== "sat")
            return { status: status };
        return { status: "sat", model: await this.getModel() };
    }
}

class DSE {
    constructor(solver, program, options) {
        _.defaults(options, {
            incremental: true,
        });
        this._solver = solver;
        this._collector = new ConstraintCollector(solver, options.incremental);
        this._program = program;
        this._inputs = [{ model: {}, step: 0 }];
        this._visitedPaths = new ExecutionPathSet();
        this._workQueue = [];
        this._itemCount = 0;
    }

    async execute() {
        const input = await this._nextInput();
        if (input === undefined)
            return false;
        console.log("testing input: ", input);
        const path = await this._program(input.model);
        console.log("execution complete");

        const constraints = path.constraints;
        if (this._visitedPaths.add(constraints) && input.step < constraints.length) {
            console.log(`adding new constraint set item #${this._itemCount} to work queue`);
            console.log(constraints.length + " constraints in path condition");
                    //    console.dir(constraints, {depth: 2});
            Object.defineProperty(constraints, "length", { configurable: false, writable: false });
            this._workQueue.push({ id: this._itemCount++, step: input.step, constraints: constraints });
        }
        return true;
    }

    isDone() {
        return this._inputs.length === 0 && this._workQueue.length === 0;
    }

    async _nextInput() {
        if (this._inputs.length === 0) {
            await this._generateInput();
        }
        return this._inputs.shift();
    }

    _addInput(input) { this._inputs.push(input); }

    async _generateInput() {
        if (this._workQueue.length === 0)
            throw new Error("_generateInput() called with empty work queue");
        const item = this._workQueue[0];
        let result;
        result = await this._collector.solvePrefix(
            item.constraints, item.step, this._collector._declaredVariables
        );
        if (result.status !== "sat") {
            console.log(`abandoning work item ${item.id}: pre-check failed at step ${item.step}: ${result.status}`);
            // The pre-check must have succeeded with sat for all prior
            // prefixes, so it must be that the last constraint made us
            // unsat/unknown.
            console.log("failed constraint: " + sexpr.stringify(item.constraints[item.step - 1].toFormula()));
            this._workQueue.shift();
            return;
        }
        const lastConstraint = item.constraints[item.step];
        this._solver.addSmtLog("solving item #" + item.id + ", step " + item.step)
        console.log("solving item #" + item.id + ", step " + item.step);
        item.step++;
        lastConstraint.negate();
        if (this._visitedPaths.hasPrefix(item.constraints.slice(0, item.step))) {
            console.error("ERROR: already visited");
            console.dir(item.constraints.slice(0, item.step), { depth: null });
            console.dir(this._visitedPaths, { depth: null });
            throw new Error("_generateInput() called on already visited path condition");
        }
        result = await this._collector.solvePrefix(
            item.constraints, item.step, this._collector._declaredVariables
        );
        lastConstraint.negate();
        if (result.status === "sat")
            this._addInput({ model: result.model, step: item.step });
        if (item.step >= item.constraints.length){
            this._workQueue.shift();
        } else {
            this._workQueue.shift();
            this._workQueue.push(item);
        }
    }
}

exports.DSE = DSE;
