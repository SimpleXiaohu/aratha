"use strict";

const _ = require("lodash");

const {doBinaryOp, doUnaryOp} = require("./ops");

class SymbolicValue {
    visit(visitor) { visitor(this); }

    exprType() {
        return "Val";
    }

    _visitChild(child, visitor) {
        if (child instanceof SymbolicValue) {
            child.visit(visitor);
        } else {
            visitor(child);
        }
    }
}

function evalValue(value, model) {
    return value instanceof SymbolicValue ? value.eval(model) : value;
}

function valueToFormula(value) {
    if (value instanceof SymbolicValue) {
        return value.toFormula();
    }

    switch (typeof value) {
        case "undefined":
            return "undefined";
        case "null":
            return "null";
        case "boolean":
            return ["Boolean", value.toString()];
        case "number":
            if (value >= 0) {
                return ["Num", value.toFixed(19)];
            } else {
                return ["Num", ["-", (-value).toFixed(19)]];
            }
        case "string":
            return ["Str", '"' + value.replace('"', '""') + '"'];
        default:
            throw new Error("values of type " + typeof value + " not implemented");
    }
}

function valueToPropsFormula(value) {
    if (typeof value === "object") {
        let result = "EmptyObject";
        for (const k in value) {
            if (value.hasOwnProperty(k)) {
                result = ["PutField", result, valueToFormula(k), valueToFormula(value[k])];
            }
        }
        return result;
    } else {
        return ["js.ToObject", valueToFormula(value)];
    }
}

function isDistinct(a, b) {
    if (!_.isObject(a) && !_.isObject(b)) {
        return a !== b;
    }

    return false;
}

exports.SymbolicValue = SymbolicValue;

class Variable extends SymbolicValue {
    constructor(name) {
        super();
        this.name = name;
    }

    eval(model) {
        return model[this.name];
    }

    toFormula() { return this.name; }

    toString() { return this.name; }
}

exports.Variable = Variable;

class Binary extends SymbolicValue {
    constructor(op, left, right) {
        super();
        this.op = op;
        this.left = left;
        this.right = right;
    }

    eval(model) {
        return doBinaryOp(this.op, evalValue(this.left, model), evalValue(this.right, model));
    }

    visit(visitor) {
        visitor(this);
        this._visitChild(this.left, visitor);
        this._visitChild(this.right, visitor);
    }

    toFormula() {
        let name = this.op;
        if (name === "|")
            name = "bitor";
        return ["js." + name, valueToFormula(this.left), valueToFormula(this.right)];
    }

    toString() { return `(${this.left} ${this.op} ${this.right})`; }
}

exports.Binary = Binary;

class Unary extends SymbolicValue {
    constructor(op, expr) {
        super();
        this.op = op;
        this.expr = expr;
    }

    visit(visitor) {
        visitor(this);
        this._visitChild(this.expr, visitor);
    }

    eval(model) {
        return doUnaryOp(this.op, evalValue(this.expr, model));
    }

    toFormula() {
        let name = this.op;
        if (name === "+" || name === "-")
            name = "u" + name;
        let expr = this.expr;
        if (expr.exprType() === "Properties") {
            expr = expr.getTopBase();
        }
        return ["js." + name, valueToFormula(expr)];
    }

    toString() { return `(${this.op} ${this.expr})`; }
}

exports.Unary = Unary;

class PutField extends SymbolicValue {
    constructor(base, offset, val) {
        super();
        this.base = base;
        this.offset = offset;
        this.val = val;
    }

    visit(visitor) {
        visitor(this);
        this._visitChild(this.base, visitor);
        this._visitChild(this.offset, visitor);
        this._visitChild(this.val, visitor);
    }

    exprType() {
        return "Properties";
    }

    getTopBase() {
        let node = this.base;
        while (node.base instanceof SymbolicValue) {
            node = node.base;
        }
        return node;
    }

    eval(model) {
        return evalValue(this.getTopBase(), model);
    }

    toObjectFormula() {
        if (this.base instanceof SymbolicValue) {
            const baseFormula = this.base.toFormula();
            const offsetFormula = valueToFormula(this.offset);
            const valFormula = valueToFormula(this.val);
            switch (this.base.exprType()) {
                case "Val":
                    return ["PutField", ["GetProperties", ["id", baseFormula]], offsetFormula, valFormula];
                case "Properties":
                    return ["PutField", baseFormula, offsetFormula, valFormula];
                default:
                    throw new Error("unknown expression type " + this.base.exprType());
            }
        } else {
            throw new Error("not implemented: PutField with concrete base");
        }
    }

    toFormula() {
        return valueToFormula(this.getTopBase());
    }

    toString() { return this.getTopBase().toString(); }
}

exports.PutField = PutField;

class GetField extends SymbolicValue {
    constructor(base, offset) {
        super();
        this.base = base;
        this.offset = offset;
    }

    eval(model) {
        const offset = evalValue(this.offset, model);

        let node = this.base;
        while (node instanceof PutField) {
            if (String(evalValue(node.offset, model)) === offset) {
                return evalValue(node.val, model);
            }

            node = node.base;
        }

        node = evalValue(node, model);

        return node[offset];
    }

    visit(visitor) {
        visitor(this);
        this._visitChild(this.base, visitor);
        this._visitChild(this.offset, visitor);
    }

    _simplify() {
        let node = this.base;
        while (node instanceof PutField) {
            if (_.isEqual(node.offset, this.offset)) {
                return node;
            }

            if (!isDistinct(node.offset, this.offset)) {
                break;
            }

            node = node.base;
        }
    }

    toFormula() {
        if (this.base instanceof SymbolicValue) {
            const resolved = this._simplify();
            if (resolved) {
                return valueToFormula(resolved.val);
            }

            switch (this.base.exprType()) {
                case "Val":
                    return ["GetFieldVal", this.base.toFormula(), valueToFormula(this.offset)];
                case "Properties": {
                    const baseFormula = this.base.toFormula();
                    const ite = ["MutableToProps", baseFormula, this.base.toObjectFormula()];
                    return ["GetFieldProps", ite, valueToFormula(this.offset)];
                }

                default:
                    throw new Error("unknown expression type " + this.base.exprType());
            }
        } else {
            return ["GetFieldProps", valueToPropsFormula(this.base), valueToFormula(this.offset)];
        }
    }

    toString() { return `${this.base}[${this.offset}]`; }
}

exports.GetField = GetField;