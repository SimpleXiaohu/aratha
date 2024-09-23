"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.EmulatedDevices = exports.DeviceModeModel = void 0;
var e = _interopRequireWildcard(require("../../core/common/common.js"));
var t = _interopRequireWildcard(require("../../core/host/host.js"));
var i = _interopRequireWildcard(require("../../core/i18n/i18n.js"));
var o = _interopRequireWildcard(require("../../core/sdk/sdk.js"));
var a = _interopRequireWildcard(require("../../ui/legacy/legacy.js"));
function _getRequireWildcardCache(e) { if ("function" != typeof WeakMap) return null; var r = new WeakMap(), t = new WeakMap(); return (_getRequireWildcardCache = function _getRequireWildcardCache(e) { return e ? t : r; })(e); }
function _interopRequireWildcard(e, r) { if (!r && e && e.__esModule) return e; if (null === e || "object" != _typeof(e) && "function" != typeof e) return { "default": e }; var t = _getRequireWildcardCache(r); if (t && t.has(e)) return t.get(e); var n = { __proto__: null }, a = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var u in e) if ("default" !== u && {}.hasOwnProperty.call(e, u)) { var i = a ? Object.getOwnPropertyDescriptor(e, u) : null; i && (i.get || i.set) ? Object.defineProperty(n, u, i) : n[u] = e[u]; } return n["default"] = e, t && t.set(e, n), n; }
function _regeneratorRuntime() { "use strict"; /*! regenerator-runtime -- Copyright (c) 2014-present, Facebook, Inc. -- license (MIT): https://github.com/facebook/regenerator/blob/main/LICENSE */ _regeneratorRuntime = function _regeneratorRuntime() { return e; }; var t, e = {}, r = Object.prototype, n = r.hasOwnProperty, o = Object.defineProperty || function (t, e, r) { t[e] = r.value; }, i = "function" == typeof Symbol ? Symbol : {}, a = i.iterator || "@@iterator", c = i.asyncIterator || "@@asyncIterator", u = i.toStringTag || "@@toStringTag"; function define(t, e, r) { return Object.defineProperty(t, e, { value: r, enumerable: !0, configurable: !0, writable: !0 }), t[e]; } try { define({}, ""); } catch (t) { define = function define(t, e, r) { return t[e] = r; }; } function wrap(t, e, r, n) { var i = e && e.prototype instanceof Generator ? e : Generator, a = Object.create(i.prototype), c = new Context(n || []); return o(a, "_invoke", { value: makeInvokeMethod(t, r, c) }), a; } function tryCatch(t, e, r) { try { return { type: "normal", arg: t.call(e, r) }; } catch (t) { return { type: "throw", arg: t }; } } e.wrap = wrap; var h = "suspendedStart", l = "suspendedYield", f = "executing", s = "completed", y = {}; function Generator() {} function GeneratorFunction() {} function GeneratorFunctionPrototype() {} var p = {}; define(p, a, function () { return this; }); var d = Object.getPrototypeOf, v = d && d(d(values([]))); v && v !== r && n.call(v, a) && (p = v); var g = GeneratorFunctionPrototype.prototype = Generator.prototype = Object.create(p); function defineIteratorMethods(t) { ["next", "throw", "return"].forEach(function (e) { define(t, e, function (t) { return this._invoke(e, t); }); }); } function AsyncIterator(t, e) { function invoke(r, o, i, a) { var c = tryCatch(t[r], t, o); if ("throw" !== c.type) { var u = c.arg, h = u.value; return h && "object" == _typeof(h) && n.call(h, "__await") ? e.resolve(h.__await).then(function (t) { invoke("next", t, i, a); }, function (t) { invoke("throw", t, i, a); }) : e.resolve(h).then(function (t) { u.value = t, i(u); }, function (t) { return invoke("throw", t, i, a); }); } a(c.arg); } var r; o(this, "_invoke", { value: function value(t, n) { function callInvokeWithMethodAndArg() { return new e(function (e, r) { invoke(t, n, e, r); }); } return r = r ? r.then(callInvokeWithMethodAndArg, callInvokeWithMethodAndArg) : callInvokeWithMethodAndArg(); } }); } function makeInvokeMethod(e, r, n) { var o = h; return function (i, a) { if (o === f) throw Error("Generator is already running"); if (o === s) { if ("throw" === i) throw a; return { value: t, done: !0 }; } for (n.method = i, n.arg = a;;) { var c = n.delegate; if (c) { var u = maybeInvokeDelegate(c, n); if (u) { if (u === y) continue; return u; } } if ("next" === n.method) n.sent = n._sent = n.arg;else if ("throw" === n.method) { if (o === h) throw o = s, n.arg; n.dispatchException(n.arg); } else "return" === n.method && n.abrupt("return", n.arg); o = f; var p = tryCatch(e, r, n); if ("normal" === p.type) { if (o = n.done ? s : l, p.arg === y) continue; return { value: p.arg, done: n.done }; } "throw" === p.type && (o = s, n.method = "throw", n.arg = p.arg); } }; } function maybeInvokeDelegate(e, r) { var n = r.method, o = e.iterator[n]; if (o === t) return r.delegate = null, "throw" === n && e.iterator["return"] && (r.method = "return", r.arg = t, maybeInvokeDelegate(e, r), "throw" === r.method) || "return" !== n && (r.method = "throw", r.arg = new TypeError("The iterator does not provide a '" + n + "' method")), y; var i = tryCatch(o, e.iterator, r.arg); if ("throw" === i.type) return r.method = "throw", r.arg = i.arg, r.delegate = null, y; var a = i.arg; return a ? a.done ? (r[e.resultName] = a.value, r.next = e.nextLoc, "return" !== r.method && (r.method = "next", r.arg = t), r.delegate = null, y) : a : (r.method = "throw", r.arg = new TypeError("iterator result is not an object"), r.delegate = null, y); } function pushTryEntry(t) { var e = { tryLoc: t[0] }; 1 in t && (e.catchLoc = t[1]), 2 in t && (e.finallyLoc = t[2], e.afterLoc = t[3]), this.tryEntries.push(e); } function resetTryEntry(t) { var e = t.completion || {}; e.type = "normal", delete e.arg, t.completion = e; } function Context(t) { this.tryEntries = [{ tryLoc: "root" }], t.forEach(pushTryEntry, this), this.reset(!0); } function values(e) { if (e || "" === e) { var r = e[a]; if (r) return r.call(e); if ("function" == typeof e.next) return e; if (!isNaN(e.length)) { var o = -1, i = function next() { for (; ++o < e.length;) if (n.call(e, o)) return next.value = e[o], next.done = !1, next; return next.value = t, next.done = !0, next; }; return i.next = i; } } throw new TypeError(_typeof(e) + " is not iterable"); } return GeneratorFunction.prototype = GeneratorFunctionPrototype, o(g, "constructor", { value: GeneratorFunctionPrototype, configurable: !0 }), o(GeneratorFunctionPrototype, "constructor", { value: GeneratorFunction, configurable: !0 }), GeneratorFunction.displayName = define(GeneratorFunctionPrototype, u, "GeneratorFunction"), e.isGeneratorFunction = function (t) { var e = "function" == typeof t && t.constructor; return !!e && (e === GeneratorFunction || "GeneratorFunction" === (e.displayName || e.name)); }, e.mark = function (t) { return Object.setPrototypeOf ? Object.setPrototypeOf(t, GeneratorFunctionPrototype) : (t.__proto__ = GeneratorFunctionPrototype, define(t, u, "GeneratorFunction")), t.prototype = Object.create(g), t; }, e.awrap = function (t) { return { __await: t }; }, defineIteratorMethods(AsyncIterator.prototype), define(AsyncIterator.prototype, c, function () { return this; }), e.AsyncIterator = AsyncIterator, e.async = function (t, r, n, o, i) { void 0 === i && (i = Promise); var a = new AsyncIterator(wrap(t, r, n, o), i); return e.isGeneratorFunction(r) ? a : a.next().then(function (t) { return t.done ? t.value : a.next(); }); }, defineIteratorMethods(g), define(g, u, "Generator"), define(g, a, function () { return this; }), define(g, "toString", function () { return "[object Generator]"; }), e.keys = function (t) { var e = Object(t), r = []; for (var n in e) r.push(n); return r.reverse(), function next() { for (; r.length;) { var t = r.pop(); if (t in e) return next.value = t, next.done = !1, next; } return next.done = !0, next; }; }, e.values = values, Context.prototype = { constructor: Context, reset: function reset(e) { if (this.prev = 0, this.next = 0, this.sent = this._sent = t, this.done = !1, this.delegate = null, this.method = "next", this.arg = t, this.tryEntries.forEach(resetTryEntry), !e) for (var r in this) "t" === r.charAt(0) && n.call(this, r) && !isNaN(+r.slice(1)) && (this[r] = t); }, stop: function stop() { this.done = !0; var t = this.tryEntries[0].completion; if ("throw" === t.type) throw t.arg; return this.rval; }, dispatchException: function dispatchException(e) { if (this.done) throw e; var r = this; function handle(n, o) { return a.type = "throw", a.arg = e, r.next = n, o && (r.method = "next", r.arg = t), !!o; } for (var o = this.tryEntries.length - 1; o >= 0; --o) { var i = this.tryEntries[o], a = i.completion; if ("root" === i.tryLoc) return handle("end"); if (i.tryLoc <= this.prev) { var c = n.call(i, "catchLoc"), u = n.call(i, "finallyLoc"); if (c && u) { if (this.prev < i.catchLoc) return handle(i.catchLoc, !0); if (this.prev < i.finallyLoc) return handle(i.finallyLoc); } else if (c) { if (this.prev < i.catchLoc) return handle(i.catchLoc, !0); } else { if (!u) throw Error("try statement without catch or finally"); if (this.prev < i.finallyLoc) return handle(i.finallyLoc); } } } }, abrupt: function abrupt(t, e) { for (var r = this.tryEntries.length - 1; r >= 0; --r) { var o = this.tryEntries[r]; if (o.tryLoc <= this.prev && n.call(o, "finallyLoc") && this.prev < o.finallyLoc) { var i = o; break; } } i && ("break" === t || "continue" === t) && i.tryLoc <= e && e <= i.finallyLoc && (i = null); var a = i ? i.completion : {}; return a.type = t, a.arg = e, i ? (this.method = "next", this.next = i.finallyLoc, y) : this.complete(a); }, complete: function complete(t, e) { if ("throw" === t.type) throw t.arg; return "break" === t.type || "continue" === t.type ? this.next = t.arg : "return" === t.type ? (this.rval = this.arg = t.arg, this.method = "return", this.next = "end") : "normal" === t.type && e && (this.next = e), y; }, finish: function finish(t) { for (var e = this.tryEntries.length - 1; e >= 0; --e) { var r = this.tryEntries[e]; if (r.finallyLoc === t) return this.complete(r.completion, r.afterLoc), resetTryEntry(r), y; } }, "catch": function _catch(t) { for (var e = this.tryEntries.length - 1; e >= 0; --e) { var r = this.tryEntries[e]; if (r.tryLoc === t) { var n = r.completion; if ("throw" === n.type) { var o = n.arg; resetTryEntry(r); } return o; } } throw Error("illegal catch attempt"); }, delegateYield: function delegateYield(e, r, n) { return this.delegate = { iterator: values(e), resultName: r, nextLoc: n }, "next" === this.method && (this.arg = t), y; } }, e; }
function asyncGeneratorStep(n, t, e, r, o, a, c) { try { var i = n[a](c), u = i.value; } catch (n) { return void e(n); } i.done ? t(u) : Promise.resolve(u).then(r, o); }
function _asyncToGenerator(n) { return function () { var t = this, e = arguments; return new Promise(function (r, o) { var a = n.apply(t, e); function _next(n) { asyncGeneratorStep(a, r, o, _next, _throw, "next", n); } function _throw(n) { asyncGeneratorStep(a, r, o, _next, _throw, "throw", n); } _next(void 0); }); }; }
function _toConsumableArray(r) { return _arrayWithoutHoles(r) || _iterableToArray(r) || _unsupportedIterableToArray(r) || _nonIterableSpread(); }
function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _iterableToArray(r) { if ("undefined" != typeof Symbol && null != r[Symbol.iterator] || null != r["@@iterator"]) return Array.from(r); }
function _arrayWithoutHoles(r) { if (Array.isArray(r)) return _arrayLikeToArray(r); }
function _createForOfIteratorHelper(r, e) { var t = "undefined" != typeof Symbol && r[Symbol.iterator] || r["@@iterator"]; if (!t) { if (Array.isArray(r) || (t = _unsupportedIterableToArray(r)) || e && r && "number" == typeof r.length) { t && (r = t); var _n5 = 0, F = function F() {}; return { s: F, n: function n() { return _n5 >= r.length ? { done: !0 } : { done: !1, value: r[_n5++] }; }, e: function e(r) { throw r; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var o, a = !0, u = !1; return { s: function s() { t = t.call(r); }, n: function n() { var r = t.next(); return a = r.done, r; }, e: function e(r) { u = !0, o = r; }, f: function f() { try { a || null == t["return"] || t["return"](); } finally { if (u) throw o; } } }; }
function _unsupportedIterableToArray(r, a) { if (r) { if ("string" == typeof r) return _arrayLikeToArray(r, a); var t = {}.toString.call(r).slice(8, -1); return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0; } }
function _arrayLikeToArray(r, a) { (null == a || a > r.length) && (a = r.length); for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e]; return n; }
function _callSuper(t, o, e) { return o = _getPrototypeOf(o), _possibleConstructorReturn(t, _isNativeReflectConstruct() ? Reflect.construct(o, e || [], _getPrototypeOf(t).constructor) : o.apply(t, e)); }
function _possibleConstructorReturn(t, e) { if (e && ("object" == _typeof(e) || "function" == typeof e)) return e; if (void 0 !== e) throw new TypeError("Derived constructors may only return object or undefined"); return _assertThisInitialized(t); }
function _assertThisInitialized(e) { if (void 0 === e) throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); return e; }
function _isNativeReflectConstruct() { try { var t = !Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); } catch (t) {} return (_isNativeReflectConstruct = function _isNativeReflectConstruct() { return !!t; })(); }
function _getPrototypeOf(t) { return _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function (t) { return t.__proto__ || Object.getPrototypeOf(t); }, _getPrototypeOf(t); }
function _inherits(t, e) { if ("function" != typeof e && null !== e) throw new TypeError("Super expression must either be null or a function"); t.prototype = Object.create(e && e.prototype, { constructor: { value: t, writable: !0, configurable: !0 } }), Object.defineProperty(t, "prototype", { writable: !1 }), e && _setPrototypeOf(t, e); }
function _setPrototypeOf(t, e) { return _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function (t, e) { return t.__proto__ = e, t; }, _setPrototypeOf(t, e); }
function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); }
function _classCallCheck(a, n) { if (!(a instanceof n)) throw new TypeError("Cannot call a class as a function"); }
function _defineProperties(e, r) { for (var t = 0; t < r.length; t++) { var o = r[t]; o.enumerable = o.enumerable || !1, o.configurable = !0, "value" in o && (o.writable = !0), Object.defineProperty(e, _toPropertyKey(o.key), o); } }
function _createClass(e, r, t) { return r && _defineProperties(e.prototype, r), t && _defineProperties(e, t), Object.defineProperty(e, "prototype", { writable: !1 }), e; }
function _toPropertyKey(t) { var i = _toPrimitive(t, "string"); return "symbol" == _typeof(i) ? i : i + ""; }
function _toPrimitive(t, r) { if ("object" != _typeof(t) || !t) return t; var e = t[Symbol.toPrimitive]; if (void 0 !== e) { var i = e.call(t, r || "default"); if ("object" != _typeof(i)) return i; throw new TypeError("@@toPrimitive must return a primitive value."); } return ("string" === r ? String : Number)(t); }
function _classPrivateFieldInitSpec(e, t, a) { _checkPrivateRedeclaration(e, t), t.set(e, a); }
function _checkPrivateRedeclaration(e, t) { if (t.has(e)) throw new TypeError("Cannot initialize the same private elements twice on an object"); }
function _classPrivateFieldGet(s, a) { return s.get(_assertClassBrand(s, a)); }
function _classPrivateFieldSet(s, a, r) { return s.set(_assertClassBrand(s, a), r), r; }
function _assertClassBrand(e, t, n) { if ("function" == typeof e ? e === t : e.has(t)) return arguments.length < 3 ? t : n; throw new TypeError("Private element is not present on this object"); }
var n = {
    laptopWithTouch: "Laptop with touch",
    laptopWithHiDPIScreen: "Laptop with HiDPI screen",
    laptopWithMDPIScreen: "Laptop with MDPI screen"
  },
  l = i.i18n.registerUIStrings("models/emulation/EmulatedDevices.ts", n),
  r = i.i18n.getLazilyComputedLocalizedString.bind(void 0, l);
function h(e) {
  return e.replace(/@url\(([^\)]*?)\)/g, function (e, t) {
    return new URL("../../emulated_devices/".concat(t), import.meta.url).toString();
  });
}
var _e = /*#__PURE__*/new WeakMap();
var _t = /*#__PURE__*/new WeakMap();
var s = /*#__PURE__*/function () {
  function s() {
    _classCallCheck(this, s);
    _classPrivateFieldInitSpec(this, _e, void 0);
    _classPrivateFieldInitSpec(this, _t, void 0);
    this.title = "", this.type = p.Unknown, this.vertical = {
      width: 0,
      height: 0,
      outlineInsets: null,
      outlineImage: null,
      hinge: null
    }, this.horizontal = {
      width: 0,
      height: 0,
      outlineInsets: null,
      outlineImage: null,
      hinge: null
    }, this.deviceScaleFactor = 1, this.capabilities = [m.Touch, m.Mobile], this.userAgent = "", this.userAgentMetadata = null, this.modes = [], this.isDualScreen = !1, this.isFoldableScreen = !1, this.verticalSpanned = {
      width: 0,
      height: 0,
      outlineInsets: null,
      outlineImage: null,
      hinge: null
    }, this.horizontalSpanned = {
      width: 0,
      height: 0,
      outlineInsets: null,
      outlineImage: null,
      hinge: null
    }, _classPrivateFieldSet(_e, this, b.Default), _classPrivateFieldSet(_t, this, !0);
  }
  return _createClass(s, [{
    key: "modesForOrientation",
    value: function modesForOrientation(e) {
      var t = [];
      for (var _i = 0; _i < this.modes.length; _i++) this.modes[_i].orientation === e && t.push(this.modes[_i]);
      return t;
    }
  }, {
    key: "getSpanPartner",
    value: function getSpanPartner(e) {
      switch (e.orientation) {
        case c:
          return this.modesForOrientation(g)[0];
        case d:
          return this.modesForOrientation(u)[0];
        case g:
          return this.modesForOrientation(c)[0];
        default:
          return this.modesForOrientation(d)[0];
      }
    }
  }, {
    key: "getRotationPartner",
    value: function getRotationPartner(e) {
      switch (e.orientation) {
        case u:
          return this.modesForOrientation(g)[0];
        case g:
          return this.modesForOrientation(u)[0];
        case d:
          return this.modesForOrientation(c)[0];
        default:
          return this.modesForOrientation(d)[0];
      }
    }
  }, {
    key: "toJSON",
    value: function toJSON() {
      var e = {};
      e.title = this.title, e.type = this.type, e["user-agent"] = this.userAgent, e.capabilities = this.capabilities, e.screen = {
        "device-pixel-ratio": this.deviceScaleFactor,
        vertical: this.orientationToJSON(this.vertical),
        horizontal: this.orientationToJSON(this.horizontal),
        "vertical-spanned": void 0,
        "horizontal-spanned": void 0
      }, (this.isDualScreen || this.isFoldableScreen) && (e.screen["vertical-spanned"] = this.orientationToJSON(this.verticalSpanned), e.screen["horizontal-spanned"] = this.orientationToJSON(this.horizontalSpanned)), e.modes = [];
      for (var _t2 = 0; _t2 < this.modes.length; ++_t2) {
        var _i2 = {
          title: this.modes[_t2].title,
          orientation: this.modes[_t2].orientation,
          insets: {
            left: this.modes[_t2].insets.left,
            top: this.modes[_t2].insets.top,
            right: this.modes[_t2].insets.right,
            bottom: this.modes[_t2].insets.bottom
          },
          image: this.modes[_t2].image || void 0
        };
        e.modes.push(_i2);
      }
      return e["show-by-default"] = _classPrivateFieldGet(_t, this), e["dual-screen"] = this.isDualScreen, e["foldable-screen"] = this.isFoldableScreen, e.show = _classPrivateFieldGet(_e, this), this.userAgentMetadata && (e["user-agent-metadata"] = this.userAgentMetadata), e;
    }
  }, {
    key: "orientationToJSON",
    value: function orientationToJSON(e) {
      var t = {};
      return t.width = e.width, t.height = e.height, e.outlineInsets && (t.outline = {
        insets: {
          left: e.outlineInsets.left,
          top: e.outlineInsets.top,
          right: e.outlineInsets.right,
          bottom: e.outlineInsets.bottom
        },
        image: e.outlineImage
      }), e.hinge && (t.hinge = {
        width: e.hinge.width,
        height: e.hinge.height,
        x: e.hinge.x,
        y: e.hinge.y,
        contentColor: void 0,
        outlineColor: void 0
      }, e.hinge.contentColor && (t.hinge.contentColor = {
        r: e.hinge.contentColor.r,
        g: e.hinge.contentColor.g,
        b: e.hinge.contentColor.b,
        a: e.hinge.contentColor.a
      }), e.hinge.outlineColor && (t.hinge.outlineColor = {
        r: e.hinge.outlineColor.r,
        g: e.hinge.outlineColor.g,
        b: e.hinge.outlineColor.b,
        a: e.hinge.outlineColor.a
      })), t;
    }
  }, {
    key: "modeImage",
    value: function modeImage(e) {
      return e.image ? h(e.image) : "";
    }
  }, {
    key: "outlineImage",
    value: function outlineImage(e) {
      var t = this.orientationByName(e.orientation);
      return t.outlineImage ? h(t.outlineImage) : "";
    }
  }, {
    key: "orientationByName",
    value: function orientationByName(e) {
      switch (e) {
        case g:
          return this.verticalSpanned;
        case u:
          return this.horizontalSpanned;
        case c:
          return this.vertical;
        default:
          return this.horizontal;
      }
    }
  }, {
    key: "show",
    value: function show() {
      return _classPrivateFieldGet(_e, this) === b.Default ? _classPrivateFieldGet(_t, this) : _classPrivateFieldGet(_e, this) === b.Always;
    }
  }, {
    key: "setShow",
    value: function setShow(e) {
      _classPrivateFieldSet(_e, this, e ? b.Always : b.Never);
    }
  }, {
    key: "copyShowFrom",
    value: function copyShowFrom(e) {
      _classPrivateFieldSet(_e, this, _classPrivateFieldGet(_e, e));
    }
  }, {
    key: "touch",
    value: function touch() {
      return -1 !== this.capabilities.indexOf(m.Touch);
    }
  }, {
    key: "mobile",
    value: function mobile() {
      return -1 !== this.capabilities.indexOf(m.Mobile);
    }
  }], [{
    key: "fromJSONV1",
    value: function fromJSONV1(e) {
      try {
        var _t3 = function _t3(e, t, i, o) {
          if ("object" != _typeof(e) || null === e || !e.hasOwnProperty(t)) {
            if (void 0 !== o) return o;
            throw new Error("Emulated device is missing required property '" + t + "'");
          }
          var a = e[t];
          if (_typeof(a) !== i || null === a) throw new Error("Emulated device property '" + t + "' has wrong type '" + _typeof(a) + "'");
          return a;
        };
        var _i3 = function _i3(e, i) {
          var o = _t3(e, i, "number");
          if (o !== Math.abs(o)) throw new Error("Emulated device value '" + i + "' must be integer");
          return o;
        };
        var _a = function _a(e) {
          return new A(_i3(e, "left"), _i3(e, "top"), _i3(e, "right"), _i3(e, "bottom"));
        };
        var _n = function _n(e) {
          var o = {};
          if (o.r = _i3(e, "r"), o.r < 0 || o.r > 255) throw new Error("color has wrong r value: " + o.r);
          if (o.g = _i3(e, "g"), o.g < 0 || o.g > 255) throw new Error("color has wrong g value: " + o.g);
          if (o.b = _i3(e, "b"), o.b < 0 || o.b > 255) throw new Error("color has wrong b value: " + o.b);
          if (o.a = _t3(e, "a", "number"), o.a < 0 || o.a > 1) throw new Error("color has wrong a value: " + o.a);
          return o;
        };
        var _l = function _l(e) {
          var t = {};
          if (t.width = _i3(e, "width"), t.width < 0 || t.width > L) throw new Error("Emulated device has wrong hinge width: " + t.width);
          if (t.height = _i3(e, "height"), t.height < 0 || t.height > L) throw new Error("Emulated device has wrong hinge height: " + t.height);
          if (t.x = _i3(e, "x"), t.x < 0 || t.x > L) throw new Error("Emulated device has wrong x offset: " + t.height);
          if (t.y = _i3(e, "y"), t.x < 0 || t.x > L) throw new Error("Emulated device has wrong y offset: " + t.height);
          return e.contentColor && (t.contentColor = _n(e.contentColor)), e.outlineColor && (t.outlineColor = _n(e.outlineColor)), t;
        };
        var _r = function _r(e) {
          var o = {};
          if (o.width = _i3(e, "width"), o.width < 0 || o.width > L || o.width < T) throw new Error("Emulated device has wrong width: " + o.width);
          if (o.height = _i3(e, "height"), o.height < 0 || o.height > L || o.height < T) throw new Error("Emulated device has wrong height: " + o.height);
          var n = _t3(e.outline, "insets", "object", null);
          if (n) {
            if (o.outlineInsets = _a(n), o.outlineInsets.left < 0 || o.outlineInsets.top < 0) throw new Error("Emulated device has wrong outline insets");
            o.outlineImage = _t3(e.outline, "image", "string");
          }
          return e.hinge && (o.hinge = _l(_t3(e, "hinge", "object", void 0))), o;
        };
        var _h = new s();
        _h.title = _t3(e, "title", "string"), _h.type = _t3(e, "type", "string"), _h.order = _t3(e, "order", "number", 0);
        var _p = _t3(e, "user-agent", "string");
        _h.userAgent = o.NetworkManager.MultitargetNetworkManager.patchUserAgentWithChromeVersion(_p), _h.userAgentMetadata = _t3(e, "user-agent-metadata", "object", null);
        var _m = _t3(e, "capabilities", "object", []);
        if (!Array.isArray(_m)) throw new Error("Emulated device capabilities must be an array");
        _h.capabilities = [];
        for (var _v = 0; _v < _m.length; ++_v) {
          if ("string" != typeof _m[_v]) throw new Error("Emulated device capability must be a string");
          _h.capabilities.push(_m[_v]);
        }
        if (_h.deviceScaleFactor = _t3(e.screen, "device-pixel-ratio", "number"), _h.deviceScaleFactor < 0 || _h.deviceScaleFactor > 100) throw new Error("Emulated device has wrong deviceScaleFactor: " + _h.deviceScaleFactor);
        if (_h.vertical = _r(_t3(e.screen, "vertical", "object")), _h.horizontal = _r(_t3(e.screen, "horizontal", "object")), _h.isDualScreen = _t3(e, "dual-screen", "boolean", !1), _h.isFoldableScreen = _t3(e, "foldable-screen", "boolean", !1), (_h.isDualScreen || _h.isFoldableScreen) && (_h.verticalSpanned = _r(_t3(e.screen, "vertical-spanned", "object", null)), _h.horizontalSpanned = _r(_t3(e.screen, "horizontal-spanned", "object", null))), (_h.isDualScreen || _h.isFoldableScreen) && (!_h.verticalSpanned || !_h.horizontalSpanned)) throw new Error("Emulated device '" + _h.title + "'has dual screen without spanned orientations");
        var _f = _t3(e, "modes", "object", [{
          title: "default",
          orientation: "vertical"
        }, {
          title: "default",
          orientation: "horizontal"
        }]);
        if (!Array.isArray(_f)) throw new Error("Emulated device modes must be an array");
        _h.modes = [];
        for (var _w = 0; _w < _f.length; ++_w) {
          var _S = {};
          if (_S.title = _t3(_f[_w], "title", "string"), _S.orientation = _t3(_f[_w], "orientation", "string"), _S.orientation !== c && _S.orientation !== d && _S.orientation !== g && _S.orientation !== u) throw new Error("Emulated device mode has wrong orientation '" + _S.orientation + "'");
          var _M = _h.orientationByName(_S.orientation);
          if (_S.insets = _a(_t3(_f[_w], "insets", "object", {
            left: 0,
            top: 0,
            right: 0,
            bottom: 0
          })), _S.insets.top < 0 || _S.insets.left < 0 || _S.insets.right < 0 || _S.insets.bottom < 0 || _S.insets.top + _S.insets.bottom > _M.height || _S.insets.left + _S.insets.right > _M.width) throw new Error("Emulated device mode '" + _S.title + "'has wrong mode insets");
          _S.image = _t3(_f[_w], "image", "string", null), _h.modes.push(_S);
        }
        return _classPrivateFieldSet(_t, _h, _t3(e, "show-by-default", "boolean", void 0)), _classPrivateFieldSet(_e, _h, _t3(e, "show", "string", b.Default)), _h;
      } catch (x) {
        return null;
      }
    }
  }, {
    key: "deviceComparator",
    value: function deviceComparator(e, t) {
      var i = e.order || 0,
        o = t.order || 0;
      return i > o ? 1 : o > i || e.title < t.title ? -1 : e.title > t.title ? 1 : 0;
    }
  }]);
}();
var d = "horizontal",
  c = "vertical",
  u = "horizontal-spanned",
  g = "vertical-spanned",
  p = {
    Phone: "phone",
    Tablet: "tablet",
    Notebook: "notebook",
    Desktop: "desktop",
    Unknown: "unknown"
  },
  m = {
    Touch: "touch",
    Mobile: "mobile"
  },
  b = {
    Always: "Always",
    Default: "Default",
    Never: "Never"
  };
var f;
var _i4 = /*#__PURE__*/new WeakMap();
var _o = /*#__PURE__*/new WeakMap();
var _a2 = /*#__PURE__*/new WeakMap();
var _n2 = /*#__PURE__*/new WeakMap();
var v = /*#__PURE__*/function (_e$ObjectWrapper$Obje) {
  function v() {
    var _this;
    _classCallCheck(this, v);
    _this = _callSuper(this, v), _classPrivateFieldInitSpec(_assertThisInitialized(_this), _i4, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this), _o, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this), _a2, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this), _n2, void 0), _assertThisInitialized(_this), _classPrivateFieldSet(_i4, _assertThisInitialized(_this), e.Settings.Settings.instance().createSetting("standard-emulated-device-list", [])), _classPrivateFieldSet(_o, _assertThisInitialized(_this), new Set()), _this.listFromJSONV1(_classPrivateFieldGet(_i4, _assertThisInitialized(_this)).get(), _classPrivateFieldGet(_o, _assertThisInitialized(_this))), _this.updateStandardDevices(), _classPrivateFieldSet(_a2, _assertThisInitialized(_this), e.Settings.Settings.instance().createSetting("custom-emulated-device-list", [])), _classPrivateFieldSet(_n2, _assertThisInitialized(_this), new Set()), _this.listFromJSONV1(_classPrivateFieldGet(_a2, _assertThisInitialized(_this)).get(), _classPrivateFieldGet(_n2, _assertThisInitialized(_this))) || _this.saveCustomDevices();
    return _this;
  }
  _inherits(v, _e$ObjectWrapper$Obje);
  return _createClass(v, [{
    key: "updateStandardDevices",
    value: function updateStandardDevices() {
      var e = new Set();
      var _iterator = _createForOfIteratorHelper(w),
        _step;
      try {
        for (_iterator.s(); !(_step = _iterator.n()).done;) {
          var _t4 = _step.value;
          var _i5 = s.fromJSONV1(_t4);
          _i5 && e.add(_i5);
        }
      } catch (err) {
        _iterator.e(err);
      } finally {
        _iterator.f();
      }
      this.copyShowValues(_classPrivateFieldGet(_o, this), e), _classPrivateFieldSet(_o, this, e), this.saveStandardDevices();
    }
  }, {
    key: "listFromJSONV1",
    value: function listFromJSONV1(e, t) {
      if (!Array.isArray(e)) return !1;
      var i = !0;
      for (var _o2 = 0; _o2 < e.length; ++_o2) {
        var _a3 = s.fromJSONV1(e[_o2]);
        _a3 ? (t.add(_a3), _a3.modes.length || (_a3.modes.push({
          title: "",
          orientation: d,
          insets: new A(0, 0, 0, 0),
          image: null
        }), _a3.modes.push({
          title: "",
          orientation: c,
          insets: new A(0, 0, 0, 0),
          image: null
        }))) : i = !1;
      }
      return i;
    }
  }, {
    key: "standard",
    value: function standard() {
      return _toConsumableArray(_classPrivateFieldGet(_o, this));
    }
  }, {
    key: "custom",
    value: function custom() {
      return _toConsumableArray(_classPrivateFieldGet(_n2, this));
    }
  }, {
    key: "revealCustomSetting",
    value: function revealCustomSetting() {
      e.Revealer.reveal(_classPrivateFieldGet(_a2, this));
    }
  }, {
    key: "addCustomDevice",
    value: function addCustomDevice(e) {
      _classPrivateFieldGet(_n2, this).add(e), this.saveCustomDevices();
    }
  }, {
    key: "removeCustomDevice",
    value: function removeCustomDevice(e) {
      _classPrivateFieldGet(_n2, this)["delete"](e), this.saveCustomDevices();
    }
  }, {
    key: "saveCustomDevices",
    value: function saveCustomDevices() {
      var e = [];
      _classPrivateFieldGet(_n2, this).forEach(function (t) {
        return e.push(t.toJSON());
      }), _classPrivateFieldGet(_a2, this).set(e), this.dispatchEventToListeners("CustomDevicesUpdated");
    }
  }, {
    key: "saveStandardDevices",
    value: function saveStandardDevices() {
      var e = [];
      _classPrivateFieldGet(_o, this).forEach(function (t) {
        return e.push(t.toJSON());
      }), _classPrivateFieldGet(_i4, this).set(e), this.dispatchEventToListeners("StandardDevicesUpdated");
    }
  }, {
    key: "copyShowValues",
    value: function copyShowValues(e, t) {
      var i = new Map();
      var _iterator2 = _createForOfIteratorHelper(e),
        _step2;
      try {
        for (_iterator2.s(); !(_step2 = _iterator2.n()).done;) {
          var _t5 = _step2.value;
          i.set(_t5.title, _t5);
        }
      } catch (err) {
        _iterator2.e(err);
      } finally {
        _iterator2.f();
      }
      var _iterator3 = _createForOfIteratorHelper(t),
        _step3;
      try {
        for (_iterator3.s(); !(_step3 = _iterator3.n()).done;) {
          var _e2 = _step3.value;
          var _t6 = i.get(_e2.title);
          _t6 && _e2.copyShowFrom(_t6);
        }
      } catch (err) {
        _iterator3.e(err);
      } finally {
        _iterator3.f();
      }
    }
  }], [{
    key: "instance",
    value: function instance() {
      return f || (f = new v()), f;
    }
  }]);
}(e.ObjectWrapper.ObjectWrapper);
var w = [{
  order: 10,
  "show-by-default": !0,
  title: "iPhone SE",
  screen: {
    horizontal: {
      width: 667,
      height: 375
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 375,
      height: 667
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
  type: "phone"
}, {
  order: 12,
  "show-by-default": !0,
  title: "iPhone XR",
  screen: {
    horizontal: {
      width: 896,
      height: 414
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 414,
      height: 896
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
  type: "phone"
}, {
  order: 14,
  "show-by-default": !0,
  title: "iPhone 12 Pro",
  screen: {
    horizontal: {
      width: 844,
      height: 390
    },
    "device-pixel-ratio": 3,
    vertical: {
      width: 390,
      height: 844
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
  type: "phone"
}, {
  order: 15,
  "show-by-default": !0,
  title: "iPhone 14 Pro Max",
  screen: {
    horizontal: {
      width: 932,
      height: 430
    },
    "device-pixel-ratio": 3,
    vertical: {
      width: 430,
      height: 932
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
  type: "phone"
}, {
  order: 16,
  "show-by-default": !1,
  title: "Pixel 3 XL",
  screen: {
    horizontal: {
      width: 786,
      height: 393
    },
    "device-pixel-ratio": 2.75,
    vertical: {
      width: 393,
      height: 786
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 11; Pixel 3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.181 Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "11",
    architecture: "",
    model: "Pixel 3",
    mobile: !0
  },
  type: "phone"
}, {
  order: 18,
  "show-by-default": !0,
  title: "Pixel 7",
  screen: {
    horizontal: {
      width: 915,
      height: 412
    },
    "device-pixel-ratio": 2.625,
    vertical: {
      width: 412,
      height: 915
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "13",
    architecture: "",
    model: "Pixel 5",
    mobile: !0
  },
  type: "phone"
}, {
  order: 20,
  "show-by-default": !0,
  title: "Samsung Galaxy S8+",
  screen: {
    horizontal: {
      width: 740,
      height: 360
    },
    "device-pixel-ratio": 4,
    vertical: {
      width: 360,
      height: 740
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 8.0.0; SM-G955U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "8.0.0",
    architecture: "",
    model: "SM-G955U",
    mobile: !0
  },
  type: "phone"
}, {
  order: 24,
  "show-by-default": !0,
  title: "Samsung Galaxy S20 Ultra",
  screen: {
    horizontal: {
      width: 915,
      height: 412
    },
    "device-pixel-ratio": 3.5,
    vertical: {
      width: 412,
      height: 915
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 13; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "13",
    architecture: "",
    model: "SM-G981B",
    mobile: !0
  },
  type: "phone"
}, {
  order: 26,
  "show-by-default": !0,
  title: "iPad Mini",
  screen: {
    horizontal: {
      width: 1024,
      height: 768
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 768,
      height: 1024
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (iPad; CPU OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
  type: "tablet"
}, {
  order: 28,
  "show-by-default": !0,
  title: "iPad Air",
  screen: {
    horizontal: {
      width: 1180,
      height: 820
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 820,
      height: 1180
    }
  },
  capabilities: ["touch"],
  "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Safari/605.1.15",
  type: "tablet"
}, {
  order: 29,
  "show-by-default": !0,
  title: "iPad Pro",
  screen: {
    horizontal: {
      width: 1366,
      height: 1024
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 1024,
      height: 1366
    }
  },
  capabilities: ["touch"],
  "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Safari/605.1.15",
  type: "tablet"
}, {
  order: 30,
  "show-by-default": !0,
  title: "Surface Pro 7",
  screen: {
    horizontal: {
      width: 1368,
      height: 912
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 912,
      height: 1368
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
  type: "tablet"
}, {
  order: 32,
  "show-by-default": !0,
  "dual-screen": !0,
  title: "Surface Duo",
  screen: {
    horizontal: {
      width: 720,
      height: 540
    },
    "device-pixel-ratio": 2.5,
    vertical: {
      width: 540,
      height: 720
    },
    "vertical-spanned": {
      width: 1114,
      height: 720,
      hinge: {
        width: 34,
        height: 720,
        x: 540,
        y: 0,
        contentColor: {
          r: 38,
          g: 38,
          b: 38,
          a: 1
        }
      }
    },
    "horizontal-spanned": {
      width: 720,
      height: 1114,
      hinge: {
        width: 720,
        height: 34,
        x: 0,
        y: 540,
        contentColor: {
          r: 38,
          g: 38,
          b: 38,
          a: 1
        }
      }
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 11.0; Surface Duo) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "11.0",
    architecture: "",
    model: "Surface Duo",
    mobile: !0
  },
  type: "phone",
  modes: [{
    title: "default",
    orientation: "vertical",
    insets: {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }, {
    title: "default",
    orientation: "horizontal",
    insets: {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }, {
    title: "spanned",
    orientation: "vertical-spanned",
    insets: {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }, {
    title: "spanned",
    orientation: "horizontal-spanned",
    insets: {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }]
}, {
  order: 34,
  "show-by-default": !0,
  "foldable-screen": !0,
  title: "Galaxy Fold",
  screen: {
    horizontal: {
      width: 653,
      height: 280
    },
    "device-pixel-ratio": 3,
    vertical: {
      width: 280,
      height: 653
    },
    "vertical-spanned": {
      width: 717,
      height: 512
    },
    "horizontal-spanned": {
      width: 512,
      height: 717
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 9.0; SAMSUNG SM-F900U Build/PPR1.180610.011) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "9.0",
    architecture: "",
    model: "SM-F900U",
    mobile: !0
  },
  type: "phone",
  modes: [{
    title: "default",
    orientation: "vertical",
    insets: {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }, {
    title: "default",
    orientation: "horizontal",
    insets: {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }, {
    title: "spanned",
    orientation: "vertical-spanned",
    insets: {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }, {
    title: "spanned",
    orientation: "horizontal-spanned",
    insets: {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }]
}, {
  order: 35,
  "show-by-default": !0,
  "foldable-screen": !0,
  title: "Asus Zenbook Fold",
  screen: {
    horizontal: {
      width: 1280,
      height: 853
    },
    "device-pixel-ratio": 1.5,
    vertical: {
      width: 853,
      height: 1280
    },
    "vertical-spanned": {
      width: 1706,
      height: 1280,
      hinge: {
        width: 107,
        height: 1280,
        x: 800,
        y: 0,
        contentColor: {
          r: 38,
          g: 38,
          b: 38,
          a: .2
        },
        outlineColor: {
          r: 38,
          g: 38,
          b: 38,
          a: .7
        }
      }
    },
    "horizontal-spanned": {
      width: 1280,
      height: 1706,
      hinge: {
        width: 1706,
        height: 107,
        x: 0,
        y: 800,
        contentColor: {
          r: 38,
          g: 38,
          b: 38,
          a: .2
        },
        outlineColor: {
          r: 38,
          g: 38,
          b: 38,
          a: .7
        }
      }
    }
  },
  capabilities: ["touch"],
  "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
  "user-agent-metadata": {
    platform: "Windows",
    platformVersion: "11.0",
    architecture: "",
    model: "UX9702AA",
    mobile: !1
  },
  type: "tablet",
  modes: [{
    title: "default",
    orientation: "vertical",
    insets: {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }, {
    title: "default",
    orientation: "horizontal",
    insets: {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }, {
    title: "spanned",
    orientation: "vertical-spanned",
    insets: {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }, {
    title: "spanned",
    orientation: "horizontal-spanned",
    insets: {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }]
}, {
  order: 36,
  "show-by-default": !0,
  title: "Samsung Galaxy A51/71",
  screen: {
    horizontal: {
      width: 914,
      height: 412
    },
    "device-pixel-ratio": 2.625,
    vertical: {
      width: 412,
      height: 914
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 8.0.0; SM-G955U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "8.0.0",
    architecture: "",
    model: "SM-G955U",
    mobile: !0
  },
  type: "phone"
}, {
  order: 52,
  "show-by-default": !0,
  title: "Nest Hub Max",
  screen: {
    horizontal: {
      outline: {
        image: "@url(optimized/google-nest-hub-max-horizontal.avif)",
        insets: {
          left: 92,
          top: 96,
          right: 91,
          bottom: 248
        }
      },
      width: 1280,
      height: 800
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 1280,
      height: 800
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (X11; Linux aarch64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.188 Safari/537.36 CrKey/1.54.250320",
  type: "tablet",
  modes: [{
    title: "default",
    orientation: "horizontal"
  }]
}, {
  order: 50,
  "show-by-default": !0,
  title: "Nest Hub",
  screen: {
    horizontal: {
      outline: {
        image: "@url(optimized/google-nest-hub-horizontal.avif)",
        insets: {
          left: 82,
          top: 74,
          right: 83,
          bottom: 222
        }
      },
      width: 1024,
      height: 600
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 1024,
      height: 600
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.109 Safari/537.36 CrKey/1.54.248666",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "",
    architecture: "",
    model: "",
    mobile: !1
  },
  type: "tablet",
  modes: [{
    title: "default",
    orientation: "horizontal"
  }]
}, {
  order: 129,
  "show-by-default": !1,
  title: "iPhone 4",
  screen: {
    horizontal: {
      width: 480,
      height: 320
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 320,
      height: 480
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53",
  type: "phone"
}, {
  order: 130,
  "show-by-default": !1,
  title: "iPhone 5/SE",
  screen: {
    horizontal: {
      outline: {
        image: "@url(optimized/iPhone5-landscape.avif)",
        insets: {
          left: 115,
          top: 25,
          right: 115,
          bottom: 28
        }
      },
      width: 568,
      height: 320
    },
    "device-pixel-ratio": 2,
    vertical: {
      outline: {
        image: "@url(optimized/iPhone5-portrait.avif)",
        insets: {
          left: 29,
          top: 105,
          right: 25,
          bottom: 111
        }
      },
      width: 320,
      height: 568
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1",
  type: "phone"
}, {
  order: 131,
  "show-by-default": !1,
  title: "iPhone 6/7/8",
  screen: {
    horizontal: {
      outline: {
        image: "@url(optimized/iPhone6-landscape.avif)",
        insets: {
          left: 106,
          top: 28,
          right: 106,
          bottom: 28
        }
      },
      width: 667,
      height: 375
    },
    "device-pixel-ratio": 2,
    vertical: {
      outline: {
        image: "@url(optimized/iPhone6-portrait.avif)",
        insets: {
          left: 28,
          top: 105,
          right: 28,
          bottom: 105
        }
      },
      width: 375,
      height: 667
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
  type: "phone"
}, {
  order: 132,
  "show-by-default": !1,
  title: "iPhone 6/7/8 Plus",
  screen: {
    horizontal: {
      outline: {
        image: "@url(optimized/iPhone6Plus-landscape.avif)",
        insets: {
          left: 109,
          top: 29,
          right: 109,
          bottom: 27
        }
      },
      width: 736,
      height: 414
    },
    "device-pixel-ratio": 3,
    vertical: {
      outline: {
        image: "@url(optimized/iPhone6Plus-portrait.avif)",
        insets: {
          left: 26,
          top: 107,
          right: 30,
          bottom: 111
        }
      },
      width: 414,
      height: 736
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
  type: "phone"
}, {
  order: 133,
  "show-by-default": !1,
  title: "iPhone X",
  screen: {
    horizontal: {
      width: 812,
      height: 375
    },
    "device-pixel-ratio": 3,
    vertical: {
      width: 375,
      height: 812
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
  type: "phone"
}, {
  "show-by-default": !1,
  title: "BlackBerry Z30",
  screen: {
    horizontal: {
      width: 640,
      height: 360
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 360,
      height: 640
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (BB10; Touch) AppleWebKit/537.10+ (KHTML, like Gecko) Version/10.0.9.2372 Mobile Safari/537.10+",
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Nexus 4",
  screen: {
    horizontal: {
      width: 640,
      height: 384
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 384,
      height: 640
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "4.4.2",
    architecture: "",
    model: "Nexus 4",
    mobile: !0
  },
  type: "phone"
}, {
  title: "Nexus 5",
  type: "phone",
  "user-agent": "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "6.0",
    architecture: "",
    model: "Nexus 5",
    mobile: !0
  },
  capabilities: ["touch", "mobile"],
  "show-by-default": !1,
  screen: {
    "device-pixel-ratio": 3,
    vertical: {
      width: 360,
      height: 640
    },
    horizontal: {
      width: 640,
      height: 360
    }
  },
  modes: [{
    title: "default",
    orientation: "vertical",
    insets: {
      left: 0,
      top: 25,
      right: 0,
      bottom: 48
    },
    image: "@url(optimized/google-nexus-5-vertical-default-1x.avif) 1x, @url(optimized/google-nexus-5-vertical-default-2x.avif) 2x"
  }, {
    title: "navigation bar",
    orientation: "vertical",
    insets: {
      left: 0,
      top: 80,
      right: 0,
      bottom: 48
    },
    image: "@url(optimized/google-nexus-5-vertical-navigation-1x.avif) 1x, @url(optimized/google-nexus-5-vertical-navigation-2x.avif) 2x"
  }, {
    title: "keyboard",
    orientation: "vertical",
    insets: {
      left: 0,
      top: 80,
      right: 0,
      bottom: 312
    },
    image: "@url(optimized/google-nexus-5-vertical-keyboard-1x.avif) 1x, @url(optimized/google-nexus-5-vertical-keyboard-2x.avif) 2x"
  }, {
    title: "default",
    orientation: "horizontal",
    insets: {
      left: 0,
      top: 25,
      right: 42,
      bottom: 0
    },
    image: "@url(optimized/google-nexus-5-horizontal-default-1x.avif) 1x, @url(optimized/google-nexus-5-horizontal-default-2x.avif) 2x"
  }, {
    title: "navigation bar",
    orientation: "horizontal",
    insets: {
      left: 0,
      top: 80,
      right: 42,
      bottom: 0
    },
    image: "@url(optimized/google-nexus-5-horizontal-navigation-1x.avif) 1x, @url(optimized/google-nexus-5-horizontal-navigation-2x.avif) 2x"
  }, {
    title: "keyboard",
    orientation: "horizontal",
    insets: {
      left: 0,
      top: 80,
      right: 42,
      bottom: 202
    },
    image: "@url(optimized/google-nexus-5-horizontal-keyboard-1x.avif) 1x, @url(optimized/google-nexus-5-horizontal-keyboard-2x.avif) 2x"
  }]
}, {
  title: "Nexus 5X",
  type: "phone",
  "user-agent": "Mozilla/5.0 (Linux; Android 8.0.0; Nexus 5X Build/OPR4.170623.006) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "8.0.0",
    architecture: "",
    model: "Nexus 5X",
    mobile: !0
  },
  capabilities: ["touch", "mobile"],
  "show-by-default": !1,
  screen: {
    "device-pixel-ratio": 2.625,
    vertical: {
      outline: {
        image: "@url(optimized/Nexus5X-portrait.avif)",
        insets: {
          left: 18,
          top: 88,
          right: 22,
          bottom: 98
        }
      },
      width: 412,
      height: 732
    },
    horizontal: {
      outline: {
        image: "@url(optimized/Nexus5X-landscape.avif)",
        insets: {
          left: 88,
          top: 21,
          right: 98,
          bottom: 19
        }
      },
      width: 732,
      height: 412
    }
  },
  modes: [{
    title: "default",
    orientation: "vertical",
    insets: {
      left: 0,
      top: 24,
      right: 0,
      bottom: 48
    },
    image: "@url(optimized/google-nexus-5x-vertical-default-1x.avif) 1x, @url(optimized/google-nexus-5x-vertical-default-2x.avif) 2x"
  }, {
    title: "navigation bar",
    orientation: "vertical",
    insets: {
      left: 0,
      top: 80,
      right: 0,
      bottom: 48
    },
    image: "@url(optimized/google-nexus-5x-vertical-navigation-1x.avif) 1x, @url(optimized/google-nexus-5x-vertical-navigation-2x.avif) 2x"
  }, {
    title: "keyboard",
    orientation: "vertical",
    insets: {
      left: 0,
      top: 80,
      right: 0,
      bottom: 342
    },
    image: "@url(optimized/google-nexus-5x-vertical-keyboard-1x.avif) 1x, @url(optimized/google-nexus-5x-vertical-keyboard-2x.avif) 2x"
  }, {
    title: "default",
    orientation: "horizontal",
    insets: {
      left: 0,
      top: 24,
      right: 48,
      bottom: 0
    },
    image: "@url(optimized/google-nexus-5x-horizontal-default-1x.avif) 1x, @url(optimized/google-nexus-5x-horizontal-default-2x.avif) 2x"
  }, {
    title: "navigation bar",
    orientation: "horizontal",
    insets: {
      left: 0,
      top: 80,
      right: 48,
      bottom: 0
    },
    image: "@url(optimized/google-nexus-5x-horizontal-navigation-1x.avif) 1x, @url(optimized/google-nexus-5x-horizontal-navigation-2x.avif) 2x"
  }, {
    title: "keyboard",
    orientation: "horizontal",
    insets: {
      left: 0,
      top: 80,
      right: 48,
      bottom: 222
    },
    image: "@url(optimized/google-nexus-5x-horizontal-keyboard-1x.avif) 1x, @url(optimized/google-nexus-5x-horizontal-keyboard-2x.avif) 2x"
  }]
}, {
  "show-by-default": !1,
  title: "Nexus 6",
  screen: {
    horizontal: {
      width: 732,
      height: 412
    },
    "device-pixel-ratio": 3.5,
    vertical: {
      width: 412,
      height: 732
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 7.1.1; Nexus 6 Build/N6F26U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "7.1.1",
    architecture: "",
    model: "Nexus 6",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Nexus 6P",
  screen: {
    horizontal: {
      outline: {
        image: "@url(optimized/Nexus6P-landscape.avif)",
        insets: {
          left: 94,
          top: 17,
          right: 88,
          bottom: 17
        }
      },
      width: 732,
      height: 412
    },
    "device-pixel-ratio": 3.5,
    vertical: {
      outline: {
        image: "@url(optimized/Nexus6P-portrait.avif)",
        insets: {
          left: 16,
          top: 94,
          right: 16,
          bottom: 88
        }
      },
      width: 412,
      height: 732
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 8.0.0; Nexus 6P Build/OPP3.170518.006) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "8.0.0",
    architecture: "",
    model: "Nexus 6P",
    mobile: !0
  },
  type: "phone"
}, {
  order: 120,
  "show-by-default": !1,
  title: "Pixel 2",
  screen: {
    horizontal: {
      width: 731,
      height: 411
    },
    "device-pixel-ratio": 2.625,
    vertical: {
      width: 411,
      height: 731
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 8.0; Pixel 2 Build/OPD3.170816.012) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "8.0",
    architecture: "",
    model: "Pixel 2",
    mobile: !0
  },
  type: "phone"
}, {
  order: 121,
  "show-by-default": !1,
  title: "Pixel 2 XL",
  screen: {
    horizontal: {
      width: 823,
      height: 411
    },
    "device-pixel-ratio": 3.5,
    vertical: {
      width: 411,
      height: 823
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 8.0.0; Pixel 2 XL Build/OPD1.170816.004) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "8.0.0",
    architecture: "",
    model: "Pixel 2 XL",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Pixel 3",
  screen: {
    horizontal: {
      width: 786,
      height: 393
    },
    "device-pixel-ratio": 2.75,
    vertical: {
      width: 393,
      height: 786
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 9; Pixel 3 Build/PQ1A.181105.017.A1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.158 Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "9",
    architecture: "",
    model: "Pixel 3",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Pixel 4",
  screen: {
    horizontal: {
      width: 745,
      height: 353
    },
    "device-pixel-ratio": 3,
    vertical: {
      width: 353,
      height: 745
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 10; Pixel 4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "10",
    architecture: "",
    model: "Pixel 4",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "LG Optimus L70",
  screen: {
    horizontal: {
      width: 640,
      height: 384
    },
    "device-pixel-ratio": 1.25,
    vertical: {
      width: 384,
      height: 640
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; U; Android 4.4.2; en-us; LGMS323 Build/KOT49I.MS32310c) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "4.4.2",
    architecture: "",
    model: "LGMS323",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Nokia N9",
  screen: {
    horizontal: {
      width: 854,
      height: 480
    },
    "device-pixel-ratio": 1,
    vertical: {
      width: 480,
      height: 854
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (MeeGo; NokiaN9) AppleWebKit/534.13 (KHTML, like Gecko) NokiaBrowser/8.5.0 Mobile Safari/534.13",
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Nokia Lumia 520",
  screen: {
    horizontal: {
      width: 533,
      height: 320
    },
    "device-pixel-ratio": 1.5,
    vertical: {
      width: 320,
      height: 533
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; IEMobile/10.0; ARM; Touch; NOKIA; Lumia 520)",
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Microsoft Lumia 550",
  screen: {
    horizontal: {
      width: 640,
      height: 360
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 640,
      height: 360
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Windows Phone 10.0; Android 4.2.1; Microsoft; Lumia 550) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Mobile Safari/537.36 Edge/14.14263",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "4.2.1",
    architecture: "",
    model: "Lumia 550",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Microsoft Lumia 950",
  screen: {
    horizontal: {
      width: 640,
      height: 360
    },
    "device-pixel-ratio": 4,
    vertical: {
      width: 360,
      height: 640
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Windows Phone 10.0; Android 4.2.1; Microsoft; Lumia 950) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Mobile Safari/537.36 Edge/14.14263",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "4.2.1",
    architecture: "",
    model: "Lumia 950",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Galaxy S III",
  screen: {
    horizontal: {
      width: 640,
      height: 360
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 360,
      height: 640
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; U; Android 4.0; en-us; GT-I9300 Build/IMM76D) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "4.0",
    architecture: "",
    model: "GT-I9300",
    mobile: !0
  },
  type: "phone"
}, {
  order: 110,
  "show-by-default": !1,
  title: "Galaxy S5",
  screen: {
    horizontal: {
      width: 640,
      height: 360
    },
    "device-pixel-ratio": 3,
    vertical: {
      width: 360,
      height: 640
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "5.0",
    architecture: "",
    model: "SM-G900P",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Galaxy S8",
  screen: {
    horizontal: {
      width: 740,
      height: 360
    },
    "device-pixel-ratio": 3,
    vertical: {
      width: 360,
      height: 740
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 7.0; SM-G950U Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.84 Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "7.0",
    architecture: "",
    model: "SM-G950U",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Galaxy S9+",
  screen: {
    horizontal: {
      width: 658,
      height: 320
    },
    "device-pixel-ratio": 4.5,
    vertical: {
      width: 320,
      height: 658
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "8.0.0",
    architecture: "",
    model: "SM-G965U",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Galaxy Tab S4",
  screen: {
    horizontal: {
      width: 1138,
      height: 712
    },
    "device-pixel-ratio": 2.25,
    vertical: {
      width: 712,
      height: 1138
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 8.1.0; SM-T837A) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.80 Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "8.1.0",
    architecture: "",
    model: "SM-T837A",
    mobile: !1
  },
  type: "phone"
}, {
  order: 1,
  "show-by-default": !1,
  title: "JioPhone 2",
  screen: {
    horizontal: {
      width: 320,
      height: 240
    },
    "device-pixel-ratio": 1,
    vertical: {
      width: 240,
      height: 320
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Mobile; LYF/F300B/LYF-F300B-001-01-15-130718-i;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "",
    architecture: "",
    model: "LYF/F300B/LYF-F300B-001-01-15-130718-i",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Kindle Fire HDX",
  screen: {
    horizontal: {
      width: 1280,
      height: 800
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 800,
      height: 1280
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; U; en-us; KFAPWI Build/JDQ39) AppleWebKit/535.19 (KHTML, like Gecko) Silk/3.13 Safari/535.19 Silk-Accelerated=true",
  type: "tablet"
}, {
  order: 140,
  "show-by-default": !1,
  title: "iPad",
  screen: {
    horizontal: {
      outline: {
        image: "@url(optimized/iPad-landscape.avif)",
        insets: {
          left: 112,
          top: 56,
          right: 116,
          bottom: 52
        }
      },
      width: 1024,
      height: 768
    },
    "device-pixel-ratio": 2,
    vertical: {
      outline: {
        image: "@url(optimized/iPad-portrait.avif)",
        insets: {
          left: 52,
          top: 114,
          right: 55,
          bottom: 114
        }
      },
      width: 768,
      height: 1024
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (iPad; CPU OS 11_0 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) Version/11.0 Mobile/15A5341f Safari/604.1",
  type: "tablet"
}, {
  order: 141,
  "show-by-default": !1,
  title: "iPad Pro",
  screen: {
    horizontal: {
      width: 1366,
      height: 1024
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 1024,
      height: 1366
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (iPad; CPU OS 11_0 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) Version/11.0 Mobile/15A5341f Safari/604.1",
  type: "tablet"
}, {
  "show-by-default": !1,
  title: "Blackberry PlayBook",
  screen: {
    horizontal: {
      width: 1024,
      height: 600
    },
    "device-pixel-ratio": 1,
    vertical: {
      width: 600,
      height: 1024
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (PlayBook; U; RIM Tablet OS 2.1.0; en-US) AppleWebKit/536.2+ (KHTML like Gecko) Version/7.2.1.0 Safari/536.2+",
  type: "tablet"
}, {
  "show-by-default": !1,
  title: "Nexus 10",
  screen: {
    horizontal: {
      width: 1280,
      height: 800
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 800,
      height: 1280
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 10 Build/MOB31T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "6.0.1",
    architecture: "",
    model: "Nexus 10",
    mobile: !1
  },
  type: "tablet"
}, {
  "show-by-default": !1,
  title: "Nexus 7",
  screen: {
    horizontal: {
      width: 960,
      height: 600
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 600,
      height: 960
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 7 Build/MOB30X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "6.0.1",
    architecture: "",
    model: "Nexus 7",
    mobile: !1
  },
  type: "tablet"
}, {
  "show-by-default": !1,
  title: "Galaxy Note 3",
  screen: {
    horizontal: {
      width: 640,
      height: 360
    },
    "device-pixel-ratio": 3,
    vertical: {
      width: 360,
      height: 640
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; U; Android 4.3; en-us; SM-N900T Build/JSS15J) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "4.3",
    architecture: "",
    model: "SM-N900T",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Galaxy Note II",
  screen: {
    horizontal: {
      width: 640,
      height: 360
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 360,
      height: 640
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; U; Android 4.1; en-us; GT-N7100 Build/JRO03C) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "4.1",
    architecture: "",
    model: "GT-N7100",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: r(n.laptopWithTouch),
  screen: {
    horizontal: {
      width: 1280,
      height: 950
    },
    "device-pixel-ratio": 1,
    vertical: {
      width: 950,
      height: 1280
    }
  },
  capabilities: ["touch"],
  "user-agent": "",
  type: "notebook",
  modes: [{
    title: "default",
    orientation: "horizontal"
  }]
}, {
  "show-by-default": !1,
  title: r(n.laptopWithHiDPIScreen),
  screen: {
    horizontal: {
      width: 1440,
      height: 900
    },
    "device-pixel-ratio": 2,
    vertical: {
      width: 900,
      height: 1440
    }
  },
  capabilities: [],
  "user-agent": "",
  type: "notebook",
  modes: [{
    title: "default",
    orientation: "horizontal"
  }]
}, {
  "show-by-default": !1,
  title: r(n.laptopWithMDPIScreen),
  screen: {
    horizontal: {
      width: 1280,
      height: 800
    },
    "device-pixel-ratio": 1,
    vertical: {
      width: 800,
      height: 1280
    }
  },
  capabilities: [],
  "user-agent": "",
  type: "notebook",
  modes: [{
    title: "default",
    orientation: "horizontal"
  }]
}, {
  "show-by-default": !1,
  title: "Moto G4",
  screen: {
    horizontal: {
      outline: {
        image: "@url(optimized/MotoG4-landscape.avif)",
        insets: {
          left: 91,
          top: 30,
          right: 74,
          bottom: 30
        }
      },
      width: 640,
      height: 360
    },
    "device-pixel-ratio": 3,
    vertical: {
      outline: {
        image: "@url(optimized/MotoG4-portrait.avif)",
        insets: {
          left: 30,
          top: 91,
          right: 30,
          bottom: 74
        }
      },
      width: 360,
      height: 640
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 6.0.1; Moto G (4)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "6.0.1",
    architecture: "",
    model: "Moto G (4)",
    mobile: !0
  },
  type: "phone"
}, {
  "show-by-default": !1,
  title: "Moto G Power",
  screen: {
    "device-pixel-ratio": 1.75,
    horizontal: {
      width: 823,
      height: 412
    },
    vertical: {
      width: 412,
      height: 823
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 11; moto g power (2022)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "11",
    architecture: "",
    model: "moto g power (2022)",
    mobile: !0
  },
  type: "phone"
}, {
  order: 200,
  "show-by-default": !1,
  title: "Facebook on Android",
  screen: {
    horizontal: {
      width: 892,
      height: 412
    },
    "device-pixel-ratio": 3.5,
    vertical: {
      width: 412,
      height: 892
    }
  },
  capabilities: ["touch", "mobile"],
  "user-agent": "Mozilla/5.0 (Linux; Android 12; Pixel 6 Build/SQ3A.220705.004; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/%s Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/407.0.0.0.65;]",
  "user-agent-metadata": {
    platform: "Android",
    platformVersion: "12",
    architecture: "",
    model: "Pixel 6",
    mobile: !0
  },
  type: "phone"
}];
var S = exports.EmulatedDevices = Object.freeze({
  __proto__: null,
  computeRelativeImageURL: h,
  EmulatedDevice: s,
  Horizontal: d,
  Vertical: c,
  HorizontalSpanned: u,
  VerticalSpanned: g,
  Type: p,
  Capability: m,
  _Show: b,
  EmulatedDevicesList: v
});
var M = {
    widthCannotBeEmpty: "Width cannot be empty.",
    widthMustBeANumber: "Width must be a number.",
    widthMustBeLessThanOrEqualToS: "Width must be less than or equal to {PH1}.",
    widthMustBeGreaterThanOrEqualToS: "Width must be greater than or equal to {PH1}.",
    heightCannotBeEmpty: "Height cannot be empty.",
    heightMustBeANumber: "Height must be a number.",
    heightMustBeLessThanOrEqualToS: "Height must be less than or equal to {PH1}.",
    heightMustBeGreaterThanOrEqualTo: "Height must be greater than or equal to {PH1}.",
    devicePixelRatioMustBeANumberOr: "Device pixel ratio must be a number or blank.",
    devicePixelRatioMustBeLessThanOr: "Device pixel ratio must be less than or equal to {PH1}.",
    devicePixelRatioMustBeGreater: "Device pixel ratio must be greater than or equal to {PH1}."
  },
  x = i.i18n.registerUIStrings("models/emulation/DeviceModeModel.ts", M),
  y = i.i18n.getLocalizedString.bind(void 0, x);
var z;
var _l2 = /*#__PURE__*/new WeakMap();
var _r2 = /*#__PURE__*/new WeakMap();
var _h2 = /*#__PURE__*/new WeakMap();
var _s2 = /*#__PURE__*/new WeakMap();
var _d = /*#__PURE__*/new WeakMap();
var _c = /*#__PURE__*/new WeakMap();
var _u = /*#__PURE__*/new WeakMap();
var _g = /*#__PURE__*/new WeakMap();
var _p2 = /*#__PURE__*/new WeakMap();
var _m2 = /*#__PURE__*/new WeakMap();
var _b = /*#__PURE__*/new WeakMap();
var _f2 = /*#__PURE__*/new WeakMap();
var _v3 = /*#__PURE__*/new WeakMap();
var _w2 = /*#__PURE__*/new WeakMap();
var _S2 = /*#__PURE__*/new WeakMap();
var _M2 = /*#__PURE__*/new WeakMap();
var _x = /*#__PURE__*/new WeakMap();
var _y = /*#__PURE__*/new WeakMap();
var _z = /*#__PURE__*/new WeakMap();
var _I = /*#__PURE__*/new WeakMap();
var _A = /*#__PURE__*/new WeakMap();
var _k = /*#__PURE__*/new WeakMap();
var _P = /*#__PURE__*/new WeakMap();
var _T = /*#__PURE__*/new WeakMap();
var _L = /*#__PURE__*/new WeakMap();
var _C = /*#__PURE__*/new WeakMap();
var I = /*#__PURE__*/function (_e$ObjectWrapper$Obje2) {
  function I() {
    var _this2;
    _classCallCheck(this, I);
    _this2 = _callSuper(this, I), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _l2, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _r2, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _h2, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _s2, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _d, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _c, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _u, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _g, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _p2, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _m2, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _b, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _f2, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _v3, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _w2, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _S2, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _M2, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _x, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _y, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _z, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _I, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _A, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _k, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _P, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _T, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _L, void 0), _classPrivateFieldInitSpec(_assertThisInitialized(_this2), _C, void 0), _assertThisInitialized(_this2), _classPrivateFieldSet(_l2, _assertThisInitialized(_this2), new k(0, 0, 1, 1)), _classPrivateFieldSet(_r2, _assertThisInitialized(_this2), new k(0, 0, 1, 1)), _classPrivateFieldSet(_h2, _assertThisInitialized(_this2), new a.Geometry.Size(1, 1)), _classPrivateFieldSet(_s2, _assertThisInitialized(_this2), new a.Geometry.Size(1, 1)), _classPrivateFieldSet(_d, _assertThisInitialized(_this2), !1), _classPrivateFieldSet(_c, _assertThisInitialized(_this2), new a.Geometry.Size(1, 1)), _classPrivateFieldSet(_u, _assertThisInitialized(_this2), window.devicePixelRatio), _classPrivateFieldSet(_g, _assertThisInitialized(_this2), "Desktop"), _classPrivateFieldSet(_p2, _assertThisInitialized(_this2), !!window.visualViewport && "segments" in window.visualViewport), _classPrivateFieldSet(_m2, _assertThisInitialized(_this2), e.Settings.Settings.instance().createSetting("emulation.device-scale", 1)), _classPrivateFieldGet(_m2, _assertThisInitialized(_this2)).get() || _classPrivateFieldGet(_m2, _assertThisInitialized(_this2)).set(1), _classPrivateFieldGet(_m2, _assertThisInitialized(_this2)).addChangeListener(_this2.scaleSettingChanged, _assertThisInitialized(_this2)), _classPrivateFieldSet(_b, _assertThisInitialized(_this2), 1), _classPrivateFieldSet(_f2, _assertThisInitialized(_this2), e.Settings.Settings.instance().createSetting("emulation.device-width", 400)), _classPrivateFieldGet(_f2, _assertThisInitialized(_this2)).get() < T && _classPrivateFieldGet(_f2, _assertThisInitialized(_this2)).set(T), _classPrivateFieldGet(_f2, _assertThisInitialized(_this2)).get() > L && _classPrivateFieldGet(_f2, _assertThisInitialized(_this2)).set(L), _classPrivateFieldGet(_f2, _assertThisInitialized(_this2)).addChangeListener(_this2.widthSettingChanged, _assertThisInitialized(_this2)), _classPrivateFieldSet(_v3, _assertThisInitialized(_this2), e.Settings.Settings.instance().createSetting("emulation.device-height", 0)), _classPrivateFieldGet(_v3, _assertThisInitialized(_this2)).get() && _classPrivateFieldGet(_v3, _assertThisInitialized(_this2)).get() < T && _classPrivateFieldGet(_v3, _assertThisInitialized(_this2)).set(T), _classPrivateFieldGet(_v3, _assertThisInitialized(_this2)).get() > L && _classPrivateFieldGet(_v3, _assertThisInitialized(_this2)).set(L), _classPrivateFieldGet(_v3, _assertThisInitialized(_this2)).addChangeListener(_this2.heightSettingChanged, _assertThisInitialized(_this2)), _classPrivateFieldSet(_w2, _assertThisInitialized(_this2), e.Settings.Settings.instance().createSetting("emulation.device-ua", "Mobile")), _classPrivateFieldGet(_w2, _assertThisInitialized(_this2)).addChangeListener(_this2.uaSettingChanged, _assertThisInitialized(_this2)), _classPrivateFieldSet(_S2, _assertThisInitialized(_this2), e.Settings.Settings.instance().createSetting("emulation.device-scale-factor", 0)), _classPrivateFieldGet(_S2, _assertThisInitialized(_this2)).addChangeListener(_this2.deviceScaleFactorSettingChanged, _assertThisInitialized(_this2)), _classPrivateFieldSet(_M2, _assertThisInitialized(_this2), e.Settings.Settings.instance().moduleSetting("emulation.show-device-outline")), _classPrivateFieldGet(_M2, _assertThisInitialized(_this2)).addChangeListener(_this2.deviceOutlineSettingChanged, _assertThisInitialized(_this2)), _classPrivateFieldSet(_x, _assertThisInitialized(_this2), e.Settings.Settings.instance().createSetting("emulation.toolbar-controls-enabled", !0, "Session")), _classPrivateFieldSet(_y, _assertThisInitialized(_this2), P.None), _classPrivateFieldSet(_z, _assertThisInitialized(_this2), null), _classPrivateFieldSet(_I, _assertThisInitialized(_this2), null), _classPrivateFieldSet(_A, _assertThisInitialized(_this2), 1), _classPrivateFieldSet(_k, _assertThisInitialized(_this2), !1), _classPrivateFieldSet(_P, _assertThisInitialized(_this2), !1), _classPrivateFieldSet(_T, _assertThisInitialized(_this2), null), _classPrivateFieldSet(_L, _assertThisInitialized(_this2), null), o.TargetManager.TargetManager.instance().observeModels(o.EmulationModel.EmulationModel, _assertThisInitialized(_this2));
    return _this2;
  }
  _inherits(I, _e$ObjectWrapper$Obje2);
  return _createClass(I, [{
    key: "scaleSettingInternal",
    get: function get() {
      return _classPrivateFieldGet(_m2, this);
    }
  }, {
    key: "setAvailableSize",
    value: function setAvailableSize(e, t) {
      _classPrivateFieldSet(_h2, this, e), _classPrivateFieldSet(_s2, this, t), _classPrivateFieldSet(_d, this, !0), this.calculateAndEmulate(!1);
    }
  }, {
    key: "emulate",
    value: function emulate(e, i, o, a) {
      var n = _classPrivateFieldGet(_y, this) !== e || _classPrivateFieldGet(_z, this) !== i || _classPrivateFieldGet(_I, this) !== o;
      if (_classPrivateFieldSet(_y, this, e), e === P.Device && i && o) {
        if (console.assert(Boolean(i) && Boolean(o), "Must pass device and mode for device emulation"), _classPrivateFieldSet(_I, this, o), _classPrivateFieldSet(_z, this, i), _classPrivateFieldGet(_d, this)) {
          var _e3 = i.orientationByName(o.orientation);
          _classPrivateFieldGet(_m2, this).set(a || this.calculateFitScale(_e3.width, _e3.height, this.currentOutline(), this.currentInsets()));
        }
      } else _classPrivateFieldSet(_z, this, null), _classPrivateFieldSet(_I, this, null);
      e !== P.None && t.userMetrics.actionTaken(t.UserMetrics.Action.DeviceModeEnabled), this.calculateAndEmulate(n);
    }
  }, {
    key: "setWidth",
    value: function setWidth(e) {
      var t = Math.min(L, this.preferredScaledWidth());
      e = Math.max(Math.min(e, t), 1), _classPrivateFieldGet(_f2, this).set(e);
    }
  }, {
    key: "setWidthAndScaleToFit",
    value: function setWidthAndScaleToFit(e) {
      e = Math.max(Math.min(e, L), 1), _classPrivateFieldGet(_m2, this).set(this.calculateFitScale(e, _classPrivateFieldGet(_v3, this).get())), _classPrivateFieldGet(_f2, this).set(e);
    }
  }, {
    key: "setHeight",
    value: function setHeight(e) {
      var t = Math.min(L, this.preferredScaledHeight());
      (e = Math.max(Math.min(e, t), 0)) === this.preferredScaledHeight() && (e = 0), _classPrivateFieldGet(_v3, this).set(e);
    }
  }, {
    key: "setHeightAndScaleToFit",
    value: function setHeightAndScaleToFit(e) {
      e = Math.max(Math.min(e, L), 0), _classPrivateFieldGet(_m2, this).set(this.calculateFitScale(_classPrivateFieldGet(_f2, this).get(), e)), _classPrivateFieldGet(_v3, this).set(e);
    }
  }, {
    key: "setScale",
    value: function setScale(e) {
      _classPrivateFieldGet(_m2, this).set(e);
    }
  }, {
    key: "device",
    value: function device() {
      return _classPrivateFieldGet(_z, this);
    }
  }, {
    key: "mode",
    value: function mode() {
      return _classPrivateFieldGet(_I, this);
    }
  }, {
    key: "type",
    value: function type() {
      return _classPrivateFieldGet(_y, this);
    }
  }, {
    key: "screenImage",
    value: function screenImage() {
      return _classPrivateFieldGet(_z, this) && _classPrivateFieldGet(_I, this) ? _classPrivateFieldGet(_z, this).modeImage(_classPrivateFieldGet(_I, this)) : "";
    }
  }, {
    key: "outlineImage",
    value: function outlineImage() {
      return _classPrivateFieldGet(_z, this) && _classPrivateFieldGet(_I, this) && _classPrivateFieldGet(_M2, this).get() ? _classPrivateFieldGet(_z, this).outlineImage(_classPrivateFieldGet(_I, this)) : "";
    }
  }, {
    key: "outlineRect",
    value: function outlineRect() {
      return _classPrivateFieldGet(_C, this) || null;
    }
  }, {
    key: "screenRect",
    value: function screenRect() {
      return _classPrivateFieldGet(_l2, this);
    }
  }, {
    key: "visiblePageRect",
    value: function visiblePageRect() {
      return _classPrivateFieldGet(_r2, this);
    }
  }, {
    key: "scale",
    value: function scale() {
      return _classPrivateFieldGet(_b, this);
    }
  }, {
    key: "fitScale",
    value: function fitScale() {
      return _classPrivateFieldGet(_A, this);
    }
  }, {
    key: "appliedDeviceSize",
    value: function appliedDeviceSize() {
      return _classPrivateFieldGet(_c, this);
    }
  }, {
    key: "appliedDeviceScaleFactor",
    value: function appliedDeviceScaleFactor() {
      return _classPrivateFieldGet(_u, this);
    }
  }, {
    key: "appliedUserAgentType",
    value: function appliedUserAgentType() {
      return _classPrivateFieldGet(_g, this);
    }
  }, {
    key: "isFullHeight",
    value: function isFullHeight() {
      return !_classPrivateFieldGet(_v3, this).get();
    }
  }, {
    key: "isMobile",
    value: function isMobile() {
      switch (_classPrivateFieldGet(_y, this)) {
        case P.Device:
          return !!_classPrivateFieldGet(_z, this) && _classPrivateFieldGet(_z, this).mobile();
        case P.None:
          return !1;
        case P.Responsive:
          return "Mobile" === _classPrivateFieldGet(_w2, this).get() || "Mobile (no touch)" === _classPrivateFieldGet(_w2, this).get();
      }
      return !1;
    }
  }, {
    key: "enabledSetting",
    value: function enabledSetting() {
      return e.Settings.Settings.instance().createSetting("emulation.show-device-mode", !1);
    }
  }, {
    key: "scaleSetting",
    value: function scaleSetting() {
      return _classPrivateFieldGet(_m2, this);
    }
  }, {
    key: "uaSetting",
    value: function uaSetting() {
      return _classPrivateFieldGet(_w2, this);
    }
  }, {
    key: "deviceScaleFactorSetting",
    value: function deviceScaleFactorSetting() {
      return _classPrivateFieldGet(_S2, this);
    }
  }, {
    key: "deviceOutlineSetting",
    value: function deviceOutlineSetting() {
      return _classPrivateFieldGet(_M2, this);
    }
  }, {
    key: "toolbarControlsEnabledSetting",
    value: function toolbarControlsEnabledSetting() {
      return _classPrivateFieldGet(_x, this);
    }
  }, {
    key: "reset",
    value: function reset() {
      _classPrivateFieldGet(_S2, this).set(0), _classPrivateFieldGet(_m2, this).set(1), this.setWidth(400), this.setHeight(0), _classPrivateFieldGet(_w2, this).set("Mobile");
    }
  }, {
    key: "modelAdded",
    value: function modelAdded(e) {
      if (e.target() === o.TargetManager.TargetManager.instance().primaryPageTarget() && e.supportsDeviceEmulation()) {
        if (_classPrivateFieldSet(_T, this, e), _classPrivateFieldGet(_L, this)) {
          var _e4 = _classPrivateFieldGet(_L, this);
          _classPrivateFieldSet(_L, this, null), _e4();
        }
        var _t7 = e.target().model(o.ResourceTreeModel.ResourceTreeModel);
        _t7 && (_t7.addEventListener(o.ResourceTreeModel.Events.FrameResized, this.onFrameChange, this), _t7.addEventListener(o.ResourceTreeModel.Events.FrameNavigated, this.onFrameChange, this));
      } else e.emulateTouch(_classPrivateFieldGet(_k, this), _classPrivateFieldGet(_P, this));
    }
  }, {
    key: "modelRemoved",
    value: function modelRemoved(e) {
      _classPrivateFieldGet(_T, this) === e && _classPrivateFieldSet(_T, this, null);
    }
  }, {
    key: "inspectedURL",
    value: function inspectedURL() {
      return _classPrivateFieldGet(_T, this) ? _classPrivateFieldGet(_T, this).target().inspectedURL() : null;
    }
  }, {
    key: "onFrameChange",
    value: function onFrameChange() {
      var e = _classPrivateFieldGet(_T, this) ? _classPrivateFieldGet(_T, this).overlayModel() : null;
      e && this.showHingeIfApplicable(e);
    }
  }, {
    key: "scaleSettingChanged",
    value: function scaleSettingChanged() {
      this.calculateAndEmulate(!1);
    }
  }, {
    key: "widthSettingChanged",
    value: function widthSettingChanged() {
      this.calculateAndEmulate(!1);
    }
  }, {
    key: "heightSettingChanged",
    value: function heightSettingChanged() {
      this.calculateAndEmulate(!1);
    }
  }, {
    key: "uaSettingChanged",
    value: function uaSettingChanged() {
      this.calculateAndEmulate(!0);
    }
  }, {
    key: "deviceScaleFactorSettingChanged",
    value: function deviceScaleFactorSettingChanged() {
      this.calculateAndEmulate(!1);
    }
  }, {
    key: "deviceOutlineSettingChanged",
    value: function deviceOutlineSettingChanged() {
      this.calculateAndEmulate(!1);
    }
  }, {
    key: "preferredScaledWidth",
    value: function preferredScaledWidth() {
      return Math.floor(_classPrivateFieldGet(_s2, this).width / (_classPrivateFieldGet(_m2, this).get() || 1));
    }
  }, {
    key: "preferredScaledHeight",
    value: function preferredScaledHeight() {
      return Math.floor(_classPrivateFieldGet(_s2, this).height / (_classPrivateFieldGet(_m2, this).get() || 1));
    }
  }, {
    key: "currentOutline",
    value: function currentOutline() {
      var e = new A(0, 0, 0, 0);
      if (_classPrivateFieldGet(_y, this) !== P.Device || !_classPrivateFieldGet(_z, this) || !_classPrivateFieldGet(_I, this)) return e;
      var t = _classPrivateFieldGet(_z, this).orientationByName(_classPrivateFieldGet(_I, this).orientation);
      return _classPrivateFieldGet(_M2, this).get() && (e = t.outlineInsets || e), e;
    }
  }, {
    key: "currentInsets",
    value: function currentInsets() {
      return _classPrivateFieldGet(_y, this) === P.Device && _classPrivateFieldGet(_I, this) ? _classPrivateFieldGet(_I, this).insets : new A(0, 0, 0, 0);
    }
  }, {
    key: "getScreenOrientationType",
    value: function getScreenOrientationType() {
      if (!_classPrivateFieldGet(_I, this)) throw new Error("Mode required to get orientation type.");
      switch (_classPrivateFieldGet(_I, this).orientation) {
        case g:
        case c:
          return "portraitPrimary";
        default:
          return "landscapePrimary";
      }
    }
  }, {
    key: "calculateAndEmulate",
    value: function calculateAndEmulate(e) {
      _classPrivateFieldGet(_T, this) || _classPrivateFieldSet(_L, this, this.calculateAndEmulate.bind(this, e));
      var t = this.isMobile(),
        i = _classPrivateFieldGet(_T, this) ? _classPrivateFieldGet(_T, this).overlayModel() : null;
      if (i && this.showHingeIfApplicable(i), _classPrivateFieldGet(_y, this) === P.Device && _classPrivateFieldGet(_z, this) && _classPrivateFieldGet(_I, this)) {
        var _i6 = _classPrivateFieldGet(_z, this).orientationByName(_classPrivateFieldGet(_I, this).orientation),
          _o3 = this.currentOutline(),
          _n3 = this.currentInsets();
        _classPrivateFieldSet(_A, this, this.calculateFitScale(_i6.width, _i6.height, _o3, _n3)), _classPrivateFieldSet(_g, this, t ? _classPrivateFieldGet(_z, this).touch() ? "Mobile" : "Mobile (no touch)" : _classPrivateFieldGet(_z, this).touch() ? "Desktop (touch)" : "Desktop"), this.applyDeviceMetrics(new a.Geometry.Size(_i6.width, _i6.height), _n3, _o3, _classPrivateFieldGet(_m2, this).get(), _classPrivateFieldGet(_z, this).deviceScaleFactor, t, this.getScreenOrientationType(), e, _classPrivateFieldGet(_p2, this)), this.applyUserAgent(_classPrivateFieldGet(_z, this).userAgent, _classPrivateFieldGet(_z, this).userAgentMetadata), this.applyTouch(_classPrivateFieldGet(_z, this).touch(), t);
      } else if (_classPrivateFieldGet(_y, this) === P.None) _classPrivateFieldSet(_A, this, this.calculateFitScale(_classPrivateFieldGet(_h2, this).width, _classPrivateFieldGet(_h2, this).height)), _classPrivateFieldSet(_g, this, "Desktop"), this.applyDeviceMetrics(_classPrivateFieldGet(_h2, this), new A(0, 0, 0, 0), new A(0, 0, 0, 0), 1, 0, t, null, e), this.applyUserAgent("", null), this.applyTouch(!1, !1);else if (_classPrivateFieldGet(_y, this) === P.Responsive) {
        var _i7 = _classPrivateFieldGet(_f2, this).get();
        (!_i7 || _i7 > this.preferredScaledWidth()) && (_i7 = this.preferredScaledWidth());
        var _o4 = _classPrivateFieldGet(_v3, this).get();
        (!_o4 || _o4 > this.preferredScaledHeight()) && (_o4 = this.preferredScaledHeight());
        var _n4 = t ? F : 0;
        _classPrivateFieldSet(_A, this, this.calculateFitScale(_classPrivateFieldGet(_f2, this).get(), _classPrivateFieldGet(_v3, this).get())), _classPrivateFieldSet(_g, this, _classPrivateFieldGet(_w2, this).get()), this.applyDeviceMetrics(new a.Geometry.Size(_i7, _o4), new A(0, 0, 0, 0), new A(0, 0, 0, 0), _classPrivateFieldGet(_m2, this).get(), _classPrivateFieldGet(_S2, this).get() || _n4, t, _o4 >= _i7 ? "portraitPrimary" : "landscapePrimary", e), this.applyUserAgent(t ? K : "", t ? N : null), this.applyTouch("Desktop (touch)" === _classPrivateFieldGet(_w2, this).get() || "Mobile" === _classPrivateFieldGet(_w2, this).get(), "Mobile" === _classPrivateFieldGet(_w2, this).get());
      }
      i && i.setShowViewportSizeOnResize(_classPrivateFieldGet(_y, this) === P.None), this.dispatchEventToListeners("Updated");
    }
  }, {
    key: "calculateFitScale",
    value: function calculateFitScale(e, t, i, o) {
      var a = i ? i.left + i.right : 0,
        n = i ? i.top + i.bottom : 0,
        l = o ? o.left + o.right : 0,
        r = o ? o.top + o.bottom : 0;
      var h = Math.min(e ? _classPrivateFieldGet(_s2, this).width / (e + a) : 1, t ? _classPrivateFieldGet(_s2, this).height / (t + n) : 1);
      h = Math.min(Math.floor(100 * h), 100);
      var s = h;
      for (; s > .7 * h;) {
        var _i8 = !0;
        if (e && (_i8 = _i8 && Number.isInteger((e - l) * s / 100)), t && (_i8 = _i8 && Number.isInteger((t - r) * s / 100)), _i8) return s / 100;
        s -= 1;
      }
      return h / 100;
    }
  }, {
    key: "setSizeAndScaleToFit",
    value: function setSizeAndScaleToFit(e, t) {
      _classPrivateFieldGet(_m2, this).set(this.calculateFitScale(e, t)), this.setWidth(e), this.setHeight(t);
    }
  }, {
    key: "applyUserAgent",
    value: function applyUserAgent(e, t) {
      o.NetworkManager.MultitargetNetworkManager.instance().setUserAgentOverride(e, t);
    }
  }, {
    key: "applyDeviceMetrics",
    value: function applyDeviceMetrics(e, t, i, o, a, n, l, r) {
      var h = arguments.length > 8 && arguments[8] !== undefined ? arguments[8] : !1;
      e.width = Math.max(1, Math.floor(e.width)), e.height = Math.max(1, Math.floor(e.height));
      var s = e.width - t.left - t.right,
        d = e.height - t.top - t.bottom;
      var c = t.left,
        u = t.top,
        g = "landscapePrimary" === l ? 90 : 0;
      if (_classPrivateFieldSet(_c, this, e), _classPrivateFieldSet(_u, this, a || window.devicePixelRatio), _classPrivateFieldSet(_l2, this, new k(Math.max(0, (_classPrivateFieldGet(_h2, this).width - e.width * o) / 2), i.top * o, e.width * o, e.height * o)), _classPrivateFieldSet(_C, this, new k(_classPrivateFieldGet(_l2, this).left - i.left * o, 0, (i.left + e.width + i.right) * o, (i.top + e.height + i.bottom) * o)), _classPrivateFieldSet(_r2, this, new k(c * o, u * o, Math.min(s * o, _classPrivateFieldGet(_h2, this).width - _classPrivateFieldGet(_l2, this).left - c * o), Math.min(d * o, _classPrivateFieldGet(_h2, this).height - _classPrivateFieldGet(_l2, this).top - u * o))), _classPrivateFieldSet(_b, this, o), h || (1 === o && _classPrivateFieldGet(_h2, this).width >= e.width && _classPrivateFieldGet(_h2, this).height >= e.height && (s = 0, d = 0), _classPrivateFieldGet(_r2, this).width === s * o && _classPrivateFieldGet(_r2, this).height === d * o && Number.isInteger(s * o) && Number.isInteger(d * o) && (s = 0, d = 0)), _classPrivateFieldGet(_T, this)) if (r && _classPrivateFieldGet(_T, this).resetPageScaleFactor(), s || d || n || a || 1 !== o || l || h) {
        var _t8 = {
            width: s,
            height: d,
            deviceScaleFactor: a,
            mobile: n,
            scale: o,
            screenWidth: e.width,
            screenHeight: e.height,
            positionX: c,
            positionY: u,
            dontSetVisibleSize: !0,
            displayFeature: void 0,
            devicePosture: void 0,
            screenOrientation: void 0
          },
          _i9 = this.getDisplayFeature();
        _i9 ? (_t8.displayFeature = _i9, _t8.devicePosture = {
          type: "folded"
        }) : _t8.devicePosture = {
          type: "continuous"
        }, l && (_t8.screenOrientation = {
          type: l,
          angle: g
        }), _classPrivateFieldGet(_T, this).emulateDevice(_t8);
      } else _classPrivateFieldGet(_T, this).emulateDevice(null);
    }
  }, {
    key: "exitHingeMode",
    value: function exitHingeMode() {
      var e = _classPrivateFieldGet(_T, this) ? _classPrivateFieldGet(_T, this).overlayModel() : null;
      e && e.showHingeForDualScreen(null);
    }
  }, {
    key: "webPlatformExperimentalFeaturesEnabled",
    value: function webPlatformExperimentalFeaturesEnabled() {
      return _classPrivateFieldGet(_p2, this);
    }
  }, {
    key: "shouldReportDisplayFeature",
    value: function shouldReportDisplayFeature() {
      return _classPrivateFieldGet(_p2, this);
    }
  }, {
    key: "captureScreenshot",
    value: function () {
      var _captureScreenshot = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee(e, t) {
        var i, a, n, l, r, _e5, _t9;
        return _regeneratorRuntime().wrap(function _callee$(_context) {
          while (1) switch (_context.prev = _context.next) {
            case 0:
              i = _classPrivateFieldGet(_T, this) ? _classPrivateFieldGet(_T, this).target().model(o.ScreenCaptureModel.ScreenCaptureModel) : null;
              if (i) {
                _context.next = 3;
                break;
              }
              return _context.abrupt("return", null);
            case 3:
              a = t ? "fromClip" : e ? "fullpage" : "fromViewport";
              n = _classPrivateFieldGet(_T, this) ? _classPrivateFieldGet(_T, this).overlayModel() : null;
              n && n.setShowViewportSizeOnResize(!1);
              _context.next = 8;
              return i.captureScreenshot("png", 100, a, t);
            case 8:
              l = _context.sent;
              r = {
                width: 0,
                height: 0,
                deviceScaleFactor: 0,
                mobile: !1
              };
              if (!(e && _classPrivateFieldGet(_T, this))) {
                _context.next = 14;
                break;
              }
              if (_classPrivateFieldGet(_z, this) && _classPrivateFieldGet(_I, this)) {
                _e5 = _classPrivateFieldGet(_z, this).orientationByName(_classPrivateFieldGet(_I, this).orientation);
                r.width = _e5.width, r.height = _e5.height;
                _t9 = this.getDisplayFeature();
                _t9 && (r.displayFeature = _t9);
              } else r.width = 0, r.height = 0;
              _context.next = 14;
              return _classPrivateFieldGet(_T, this).emulateDevice(r);
            case 14:
              return _context.abrupt("return", (this.calculateAndEmulate(!1), l));
            case 15:
            case "end":
              return _context.stop();
          }
        }, _callee, this);
      }));
      function captureScreenshot(_x2, _x3) {
        return _captureScreenshot.apply(this, arguments);
      }
      return captureScreenshot;
    }()
  }, {
    key: "applyTouch",
    value: function applyTouch(e, t) {
      _classPrivateFieldSet(_k, this, e), _classPrivateFieldSet(_P, this, t);
      var _iterator4 = _createForOfIteratorHelper(o.TargetManager.TargetManager.instance().models(o.EmulationModel.EmulationModel)),
        _step4;
      try {
        for (_iterator4.s(); !(_step4 = _iterator4.n()).done;) {
          var _i10 = _step4.value;
          _i10.emulateTouch(e, t);
        }
      } catch (err) {
        _iterator4.e(err);
      } finally {
        _iterator4.f();
      }
    }
  }, {
    key: "showHingeIfApplicable",
    value: function showHingeIfApplicable(e) {
      var t = _classPrivateFieldGet(_z, this) && _classPrivateFieldGet(_I, this) ? _classPrivateFieldGet(_z, this).orientationByName(_classPrivateFieldGet(_I, this).orientation) : null;
      t && t.hinge ? e.showHingeForDualScreen(t.hinge) : e.showHingeForDualScreen(null);
    }
  }, {
    key: "getDisplayFeatureOrientation",
    value: function getDisplayFeatureOrientation() {
      if (!_classPrivateFieldGet(_I, this)) throw new Error("Mode required to get display feature orientation.");
      switch (_classPrivateFieldGet(_I, this).orientation) {
        case g:
        case c:
          return "vertical";
        default:
          return "horizontal";
      }
    }
  }, {
    key: "getDisplayFeature",
    value: function getDisplayFeature() {
      if (!this.shouldReportDisplayFeature()) return null;
      if (!_classPrivateFieldGet(_z, this) || !_classPrivateFieldGet(_I, this) || _classPrivateFieldGet(_I, this).orientation !== g && _classPrivateFieldGet(_I, this).orientation !== u) return null;
      var e = _classPrivateFieldGet(_z, this).orientationByName(_classPrivateFieldGet(_I, this).orientation);
      if (!e || !e.hinge) return null;
      var t = e.hinge;
      return {
        orientation: this.getDisplayFeatureOrientation(),
        offset: _classPrivateFieldGet(_I, this).orientation === g ? t.x : t.y,
        maskLength: _classPrivateFieldGet(_I, this).orientation === g ? t.width : t.height
      };
    }
  }], [{
    key: "instance",
    value: function instance(e) {
      return z && !(e !== null && e !== void 0 && e.forceNew) || (z = new I()), z;
    }
  }, {
    key: "widthValidator",
    value: function widthValidator(e) {
      var t,
        i = !1;
      return e ? /^[\d]+$/.test(e) ? Number(e) > L ? t = y(M.widthMustBeLessThanOrEqualToS, {
        PH1: L
      }) : Number(e) < T ? t = y(M.widthMustBeGreaterThanOrEqualToS, {
        PH1: T
      }) : i = !0 : t = y(M.widthMustBeANumber) : t = y(M.widthCannotBeEmpty), {
        valid: i,
        errorMessage: t
      };
    }
  }, {
    key: "heightValidator",
    value: function heightValidator(e) {
      var t,
        i = !1;
      return e ? /^[\d]+$/.test(e) ? Number(e) > L ? t = y(M.heightMustBeLessThanOrEqualToS, {
        PH1: L
      }) : Number(e) < T ? t = y(M.heightMustBeGreaterThanOrEqualTo, {
        PH1: T
      }) : i = !0 : t = y(M.heightMustBeANumber) : t = y(M.heightCannotBeEmpty), {
        valid: i,
        errorMessage: t
      };
    }
  }, {
    key: "scaleValidator",
    value: function scaleValidator(e) {
      var t,
        i = !1;
      var o = Number(e.trim());
      return e ? Number.isNaN(o) ? t = y(M.devicePixelRatioMustBeANumberOr) : Number(e) > E ? t = y(M.devicePixelRatioMustBeLessThanOr, {
        PH1: E
      }) : Number(e) < C ? t = y(M.devicePixelRatioMustBeGreater, {
        PH1: C
      }) : i = !0 : i = !0, {
        valid: i,
        errorMessage: t
      };
    }
  }]);
}(e.ObjectWrapper.ObjectWrapper);
var A = /*#__PURE__*/function () {
  function A(e, t, i, o) {
    _classCallCheck(this, A);
    this.left = e, this.top = t, this.right = i, this.bottom = o;
  }
  return _createClass(A, [{
    key: "isEqual",
    value: function isEqual(e) {
      return null !== e && this.left === e.left && this.top === e.top && this.right === e.right && this.bottom === e.bottom;
    }
  }]);
}();
var k = /*#__PURE__*/function () {
  function k(e, t, i, o) {
    _classCallCheck(this, k);
    this.left = e, this.top = t, this.width = i, this.height = o;
  }
  return _createClass(k, [{
    key: "isEqual",
    value: function isEqual(e) {
      return null !== e && this.left === e.left && this.top === e.top && this.width === e.width && this.height === e.height;
    }
  }, {
    key: "scale",
    value: function scale(e) {
      return new k(this.left * e, this.top * e, this.width * e, this.height * e);
    }
  }, {
    key: "relativeTo",
    value: function relativeTo(e) {
      return new k(this.left - e.left, this.top - e.top, this.width, this.height);
    }
  }, {
    key: "rebaseTo",
    value: function rebaseTo(e) {
      return new k(this.left + e.left, this.top + e.top, this.width, this.height);
    }
  }]);
}();
var P;
!function (e) {
  e.None = "None", e.Responsive = "Responsive", e.Device = "Device";
}(P || (P = {}));
var T = 50,
  L = 9999,
  C = 0,
  E = 10,
  K = o.NetworkManager.MultitargetNetworkManager.patchUserAgentWithChromeVersion("Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36"),
  N = {
    platform: "Android",
    platformVersion: "6.0",
    architecture: "",
    model: "Nexus 5",
    mobile: !0
  },
  F = 2;
var G = exports.DeviceModeModel = Object.freeze({
  __proto__: null,
  DeviceModeModel: I,
  Insets: A,
  Rect: k,
  get Type() {
    return P;
  },
  MinDeviceSize: T,
  MaxDeviceSize: L,
  MinDeviceScaleFactor: C,
  MaxDeviceScaleFactor: E,
  MaxDeviceNameLength: 50,
  defaultMobileScaleFactor: F
});