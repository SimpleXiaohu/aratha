"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.act = act;
exports.actAsync = actAsync;
exports.beforeEachProfiling = beforeEachProfiling;
exports.createDisplayNameFilter = createDisplayNameFilter;
exports.createElementTypeFilter = createElementTypeFilter;
exports.createHOCFilter = createHOCFilter;
exports.createLocationFilter = createLocationFilter;
exports.exportImportHelper = exportImportHelper;
exports.getActDOMImplementation = getActDOMImplementation;
exports.getActTestRendererImplementation = getActTestRendererImplementation;
exports.getLegacyRenderImplementation = getLegacyRenderImplementation;
exports.getModernRenderImplementation = getModernRenderImplementation;
exports.getRendererID = getRendererID;
exports.getVersionedRenderImplementation = void 0;
exports.legacyRender = legacyRender;
exports.normalizeCodeLocInfo = normalizeCodeLocInfo;
exports.overrideFeatureFlags = overrideFeatureFlags;
exports.requireTestRenderer = requireTestRenderer;
exports.withErrorsOrWarningsIgnored = withErrorsOrWarningsIgnored;
var _semver = _interopRequireDefault(require("semver"));
var _ReactVersions = require("../../../../ReactVersions");
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
function _regeneratorRuntime() { "use strict"; /*! regenerator-runtime -- Copyright (c) 2014-present, Facebook, Inc. -- license (MIT): https://github.com/facebook/regenerator/blob/main/LICENSE */ _regeneratorRuntime = function _regeneratorRuntime() { return e; }; var t, e = {}, r = Object.prototype, n = r.hasOwnProperty, o = Object.defineProperty || function (t, e, r) { t[e] = r.value; }, i = "function" == typeof Symbol ? Symbol : {}, a = i.iterator || "@@iterator", c = i.asyncIterator || "@@asyncIterator", u = i.toStringTag || "@@toStringTag"; function define(t, e, r) { return Object.defineProperty(t, e, { value: r, enumerable: !0, configurable: !0, writable: !0 }), t[e]; } try { define({}, ""); } catch (t) { define = function define(t, e, r) { return t[e] = r; }; } function wrap(t, e, r, n) { var i = e && e.prototype instanceof Generator ? e : Generator, a = Object.create(i.prototype), c = new Context(n || []); return o(a, "_invoke", { value: makeInvokeMethod(t, r, c) }), a; } function tryCatch(t, e, r) { try { return { type: "normal", arg: t.call(e, r) }; } catch (t) { return { type: "throw", arg: t }; } } e.wrap = wrap; var h = "suspendedStart", l = "suspendedYield", f = "executing", s = "completed", y = {}; function Generator() {} function GeneratorFunction() {} function GeneratorFunctionPrototype() {} var p = {}; define(p, a, function () { return this; }); var d = Object.getPrototypeOf, v = d && d(d(values([]))); v && v !== r && n.call(v, a) && (p = v); var g = GeneratorFunctionPrototype.prototype = Generator.prototype = Object.create(p); function defineIteratorMethods(t) { ["next", "throw", "return"].forEach(function (e) { define(t, e, function (t) { return this._invoke(e, t); }); }); } function AsyncIterator(t, e) { function invoke(r, o, i, a) { var c = tryCatch(t[r], t, o); if ("throw" !== c.type) { var u = c.arg, h = u.value; return h && "object" == _typeof(h) && n.call(h, "__await") ? e.resolve(h.__await).then(function (t) { invoke("next", t, i, a); }, function (t) { invoke("throw", t, i, a); }) : e.resolve(h).then(function (t) { u.value = t, i(u); }, function (t) { return invoke("throw", t, i, a); }); } a(c.arg); } var r; o(this, "_invoke", { value: function value(t, n) { function callInvokeWithMethodAndArg() { return new e(function (e, r) { invoke(t, n, e, r); }); } return r = r ? r.then(callInvokeWithMethodAndArg, callInvokeWithMethodAndArg) : callInvokeWithMethodAndArg(); } }); } function makeInvokeMethod(e, r, n) { var o = h; return function (i, a) { if (o === f) throw Error("Generator is already running"); if (o === s) { if ("throw" === i) throw a; return { value: t, done: !0 }; } for (n.method = i, n.arg = a;;) { var c = n.delegate; if (c) { var u = maybeInvokeDelegate(c, n); if (u) { if (u === y) continue; return u; } } if ("next" === n.method) n.sent = n._sent = n.arg;else if ("throw" === n.method) { if (o === h) throw o = s, n.arg; n.dispatchException(n.arg); } else "return" === n.method && n.abrupt("return", n.arg); o = f; var p = tryCatch(e, r, n); if ("normal" === p.type) { if (o = n.done ? s : l, p.arg === y) continue; return { value: p.arg, done: n.done }; } "throw" === p.type && (o = s, n.method = "throw", n.arg = p.arg); } }; } function maybeInvokeDelegate(e, r) { var n = r.method, o = e.iterator[n]; if (o === t) return r.delegate = null, "throw" === n && e.iterator["return"] && (r.method = "return", r.arg = t, maybeInvokeDelegate(e, r), "throw" === r.method) || "return" !== n && (r.method = "throw", r.arg = new TypeError("The iterator does not provide a '" + n + "' method")), y; var i = tryCatch(o, e.iterator, r.arg); if ("throw" === i.type) return r.method = "throw", r.arg = i.arg, r.delegate = null, y; var a = i.arg; return a ? a.done ? (r[e.resultName] = a.value, r.next = e.nextLoc, "return" !== r.method && (r.method = "next", r.arg = t), r.delegate = null, y) : a : (r.method = "throw", r.arg = new TypeError("iterator result is not an object"), r.delegate = null, y); } function pushTryEntry(t) { var e = { tryLoc: t[0] }; 1 in t && (e.catchLoc = t[1]), 2 in t && (e.finallyLoc = t[2], e.afterLoc = t[3]), this.tryEntries.push(e); } function resetTryEntry(t) { var e = t.completion || {}; e.type = "normal", delete e.arg, t.completion = e; } function Context(t) { this.tryEntries = [{ tryLoc: "root" }], t.forEach(pushTryEntry, this), this.reset(!0); } function values(e) { if (e || "" === e) { var r = e[a]; if (r) return r.call(e); if ("function" == typeof e.next) return e; if (!isNaN(e.length)) { var o = -1, i = function next() { for (; ++o < e.length;) if (n.call(e, o)) return next.value = e[o], next.done = !1, next; return next.value = t, next.done = !0, next; }; return i.next = i; } } throw new TypeError(_typeof(e) + " is not iterable"); } return GeneratorFunction.prototype = GeneratorFunctionPrototype, o(g, "constructor", { value: GeneratorFunctionPrototype, configurable: !0 }), o(GeneratorFunctionPrototype, "constructor", { value: GeneratorFunction, configurable: !0 }), GeneratorFunction.displayName = define(GeneratorFunctionPrototype, u, "GeneratorFunction"), e.isGeneratorFunction = function (t) { var e = "function" == typeof t && t.constructor; return !!e && (e === GeneratorFunction || "GeneratorFunction" === (e.displayName || e.name)); }, e.mark = function (t) { return Object.setPrototypeOf ? Object.setPrototypeOf(t, GeneratorFunctionPrototype) : (t.__proto__ = GeneratorFunctionPrototype, define(t, u, "GeneratorFunction")), t.prototype = Object.create(g), t; }, e.awrap = function (t) { return { __await: t }; }, defineIteratorMethods(AsyncIterator.prototype), define(AsyncIterator.prototype, c, function () { return this; }), e.AsyncIterator = AsyncIterator, e.async = function (t, r, n, o, i) { void 0 === i && (i = Promise); var a = new AsyncIterator(wrap(t, r, n, o), i); return e.isGeneratorFunction(r) ? a : a.next().then(function (t) { return t.done ? t.value : a.next(); }); }, defineIteratorMethods(g), define(g, u, "Generator"), define(g, a, function () { return this; }), define(g, "toString", function () { return "[object Generator]"; }), e.keys = function (t) { var e = Object(t), r = []; for (var n in e) r.push(n); return r.reverse(), function next() { for (; r.length;) { var t = r.pop(); if (t in e) return next.value = t, next.done = !1, next; } return next.done = !0, next; }; }, e.values = values, Context.prototype = { constructor: Context, reset: function reset(e) { if (this.prev = 0, this.next = 0, this.sent = this._sent = t, this.done = !1, this.delegate = null, this.method = "next", this.arg = t, this.tryEntries.forEach(resetTryEntry), !e) for (var r in this) "t" === r.charAt(0) && n.call(this, r) && !isNaN(+r.slice(1)) && (this[r] = t); }, stop: function stop() { this.done = !0; var t = this.tryEntries[0].completion; if ("throw" === t.type) throw t.arg; return this.rval; }, dispatchException: function dispatchException(e) { if (this.done) throw e; var r = this; function handle(n, o) { return a.type = "throw", a.arg = e, r.next = n, o && (r.method = "next", r.arg = t), !!o; } for (var o = this.tryEntries.length - 1; o >= 0; --o) { var i = this.tryEntries[o], a = i.completion; if ("root" === i.tryLoc) return handle("end"); if (i.tryLoc <= this.prev) { var c = n.call(i, "catchLoc"), u = n.call(i, "finallyLoc"); if (c && u) { if (this.prev < i.catchLoc) return handle(i.catchLoc, !0); if (this.prev < i.finallyLoc) return handle(i.finallyLoc); } else if (c) { if (this.prev < i.catchLoc) return handle(i.catchLoc, !0); } else { if (!u) throw Error("try statement without catch or finally"); if (this.prev < i.finallyLoc) return handle(i.finallyLoc); } } } }, abrupt: function abrupt(t, e) { for (var r = this.tryEntries.length - 1; r >= 0; --r) { var o = this.tryEntries[r]; if (o.tryLoc <= this.prev && n.call(o, "finallyLoc") && this.prev < o.finallyLoc) { var i = o; break; } } i && ("break" === t || "continue" === t) && i.tryLoc <= e && e <= i.finallyLoc && (i = null); var a = i ? i.completion : {}; return a.type = t, a.arg = e, i ? (this.method = "next", this.next = i.finallyLoc, y) : this.complete(a); }, complete: function complete(t, e) { if ("throw" === t.type) throw t.arg; return "break" === t.type || "continue" === t.type ? this.next = t.arg : "return" === t.type ? (this.rval = this.arg = t.arg, this.method = "return", this.next = "end") : "normal" === t.type && e && (this.next = e), y; }, finish: function finish(t) { for (var e = this.tryEntries.length - 1; e >= 0; --e) { var r = this.tryEntries[e]; if (r.finallyLoc === t) return this.complete(r.completion, r.afterLoc), resetTryEntry(r), y; } }, "catch": function _catch(t) { for (var e = this.tryEntries.length - 1; e >= 0; --e) { var r = this.tryEntries[e]; if (r.tryLoc === t) { var n = r.completion; if ("throw" === n.type) { var o = n.arg; resetTryEntry(r); } return o; } } throw Error("illegal catch attempt"); }, delegateYield: function delegateYield(e, r, n) { return this.delegate = { iterator: values(e), resultName: r, nextLoc: n }, "next" === this.method && (this.arg = t), y; } }, e; }
function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); }
function ownKeys(e, r) { var t = Object.keys(e); if (Object.getOwnPropertySymbols) { var o = Object.getOwnPropertySymbols(e); r && (o = o.filter(function (r) { return Object.getOwnPropertyDescriptor(e, r).enumerable; })), t.push.apply(t, o); } return t; }
function _objectSpread(e) { for (var r = 1; r < arguments.length; r++) { var t = null != arguments[r] ? arguments[r] : {}; r % 2 ? ownKeys(Object(t), !0).forEach(function (r) { _defineProperty(e, r, t[r]); }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : ownKeys(Object(t)).forEach(function (r) { Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r)); }); } return e; }
function _defineProperty(e, r, t) { return (r = _toPropertyKey(r)) in e ? Object.defineProperty(e, r, { value: t, enumerable: !0, configurable: !0, writable: !0 }) : e[r] = t, e; }
function _toPropertyKey(t) { var i = _toPrimitive(t, "string"); return "symbol" == _typeof(i) ? i : i + ""; }
function _toPrimitive(t, r) { if ("object" != _typeof(t) || !t) return t; var e = t[Symbol.toPrimitive]; if (void 0 !== e) { var i = e.call(t, r || "default"); if ("object" != _typeof(i)) return i; throw new TypeError("@@toPrimitive must return a primitive value."); } return ("string" === r ? String : Number)(t); }
function _toConsumableArray(r) { return _arrayWithoutHoles(r) || _iterableToArray(r) || _unsupportedIterableToArray(r) || _nonIterableSpread(); }
function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _unsupportedIterableToArray(r, a) { if (r) { if ("string" == typeof r) return _arrayLikeToArray(r, a); var t = {}.toString.call(r).slice(8, -1); return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0; } }
function _iterableToArray(r) { if ("undefined" != typeof Symbol && null != r[Symbol.iterator] || null != r["@@iterator"]) return Array.from(r); }
function _arrayWithoutHoles(r) { if (Array.isArray(r)) return _arrayLikeToArray(r); }
function _arrayLikeToArray(r, a) { (null == a || a > r.length) && (a = r.length); for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e]; return n; }
function asyncGeneratorStep(n, t, e, r, o, a, c) { try { var i = n[a](c), u = i.value; } catch (n) { return void e(n); } i.done ? t(u) : Promise.resolve(u).then(r, o); }
function _asyncToGenerator(n) { return function () { var t = this, e = arguments; return new Promise(function (r, o) { var a = n.apply(t, e); function _next(n) { asyncGeneratorStep(a, r, o, _next, _throw, "next", n); } function _throw(n) { asyncGeneratorStep(a, r, o, _next, _throw, "throw", n); } _next(void 0); }); }; } /**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * 
 */
var requestedReactVersion = process.env.REACT_VERSION || _ReactVersions.ReactVersion;
function getActDOMImplementation() {
  // This is for React < 17, where act wasn't shipped yet.
  if (_semver["default"].lt(requestedReactVersion, '17.0.0')) {
    require('react-dom/test-utils');
    return function (cb) {
      return cb();
    };
  }

  // This is for React < 18, where act was distributed in react-dom/test-utils.
  if (_semver["default"].lt(requestedReactVersion, '18.0.0')) {
    var ReactDOMTestUtils = require('react-dom/test-utils');
    return ReactDOMTestUtils.act;
  }
  var React = require('react');
  // This is for React 18, where act was distributed in react as unstable.
  if (React.unstable_act) {
    return React.unstable_act;
  }

  // This is for React > 18, where act is marked as stable.
  if (React.act) {
    return React.act;
  }
  throw new Error("Couldn't find any available act implementation");
}
function getActTestRendererImplementation() {
  // This is for React < 17, where act wasn't shipped yet.
  if (_semver["default"].lt(requestedReactVersion, '17.0.0')) {
    require('react-test-renderer');
    return function (cb) {
      return cb();
    };
  }
  var RTR = require('react-test-renderer');
  if (RTR.act) {
    return RTR.act;
  }
  throw new Error("Couldn't find any available act implementation in react-test-renderer");
}
function act(callback) {
  var recursivelyFlush = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;
  // act from react-test-renderer has some side effects on React DevTools
  // it injects the renderer for DevTools, see ReactTestRenderer.js
  var actTestRenderer = getActTestRendererImplementation();
  var actDOM = getActDOMImplementation();
  actDOM(function () {
    actTestRenderer(function () {
      callback();
    });
  });
  if (recursivelyFlush) {
    // Flush Bridge operations
    while (jest.getTimerCount() > 0) {
      actDOM(function () {
        actTestRenderer(function () {
          jest.runAllTimers();
        });
      });
    }
  }
}
function actAsync(_x) {
  return _actAsync.apply(this, arguments);
}
function _actAsync() {
  _actAsync = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee7(cb) {
    var recursivelyFlush,
      actTestRenderer,
      actDOM,
      _args7 = arguments;
    return _regeneratorRuntime().wrap(function _callee7$(_context7) {
      while (1) switch (_context7.prev = _context7.next) {
        case 0:
          recursivelyFlush = _args7.length > 1 && _args7[1] !== undefined ? _args7[1] : true;
          // act from react-test-renderer has some side effects on React DevTools
          // it injects the renderer for DevTools, see ReactTestRenderer.js
          actTestRenderer = getActTestRendererImplementation();
          actDOM = getActDOMImplementation();
          _context7.next = 5;
          return actDOM(/*#__PURE__*/_asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee2() {
            return _regeneratorRuntime().wrap(function _callee2$(_context2) {
              while (1) switch (_context2.prev = _context2.next) {
                case 0:
                  _context2.next = 2;
                  return actTestRenderer(/*#__PURE__*/_asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee() {
                    return _regeneratorRuntime().wrap(function _callee$(_context) {
                      while (1) switch (_context.prev = _context.next) {
                        case 0:
                          _context.next = 2;
                          return cb();
                        case 2:
                        case "end":
                          return _context.stop();
                      }
                    }, _callee);
                  })));
                case 2:
                case "end":
                  return _context2.stop();
              }
            }, _callee2);
          })));
        case 5:
          if (!recursivelyFlush) {
            _context7.next = 13;
            break;
          }
        case 6:
          if (!(jest.getTimerCount() > 0)) {
            _context7.next = 11;
            break;
          }
          _context7.next = 9;
          return actDOM(/*#__PURE__*/_asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee4() {
            return _regeneratorRuntime().wrap(function _callee4$(_context4) {
              while (1) switch (_context4.prev = _context4.next) {
                case 0:
                  _context4.next = 2;
                  return actTestRenderer(/*#__PURE__*/_asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee3() {
                    return _regeneratorRuntime().wrap(function _callee3$(_context3) {
                      while (1) switch (_context3.prev = _context3.next) {
                        case 0:
                          jest.runAllTimers();
                        case 1:
                        case "end":
                          return _context3.stop();
                      }
                    }, _callee3);
                  })));
                case 2:
                case "end":
                  return _context4.stop();
              }
            }, _callee4);
          })));
        case 9:
          _context7.next = 6;
          break;
        case 11:
          _context7.next = 15;
          break;
        case 13:
          _context7.next = 15;
          return actDOM(/*#__PURE__*/_asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee6() {
            return _regeneratorRuntime().wrap(function _callee6$(_context6) {
              while (1) switch (_context6.prev = _context6.next) {
                case 0:
                  _context6.next = 2;
                  return actTestRenderer(/*#__PURE__*/_asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee5() {
                    return _regeneratorRuntime().wrap(function _callee5$(_context5) {
                      while (1) switch (_context5.prev = _context5.next) {
                        case 0:
                          jest.runOnlyPendingTimers();
                        case 1:
                        case "end":
                          return _context5.stop();
                      }
                    }, _callee5);
                  })));
                case 2:
                case "end":
                  return _context6.stop();
              }
            }, _callee6);
          })));
        case 15:
        case "end":
          return _context7.stop();
      }
    }, _callee7);
  }));
  return _actAsync.apply(this, arguments);
}
function getLegacyRenderImplementation() {
  var ReactDOM;
  var container;
  var containersToRemove = [];
  beforeEach(function () {
    ReactDOM = require('react-dom');
    createContainer();
  });
  afterEach(function () {
    containersToRemove.forEach(function (c) {
      return document.body.removeChild(c);
    });
    containersToRemove.splice(0, containersToRemove.length);
    ReactDOM = null;
    container = null;
  });
  function render(elements) {
    withErrorsOrWarningsIgnored(['ReactDOM.render has not been supported since React 18'], function () {
      ReactDOM.render(elements, container);
    });
    return unmount;
  }
  function unmount() {
    ReactDOM.unmountComponentAtNode(container);
  }
  function createContainer() {
    container = document.createElement('div');
    document.body.appendChild(container);
    containersToRemove.push(container);
  }
  function getContainer() {
    return container;
  }
  return {
    render: render,
    unmount: unmount,
    createContainer: createContainer,
    getContainer: getContainer
  };
}
function getModernRenderImplementation() {
  var ReactDOMClient;
  var container;
  var root;
  var containersToRemove = [];
  beforeEach(function () {
    ReactDOMClient = require('react-dom/client');
    createContainer();
  });
  afterEach(function () {
    containersToRemove.forEach(function (c) {
      return document.body.removeChild(c);
    });
    containersToRemove.splice(0, containersToRemove.length);
    ReactDOMClient = null;
    container = null;
    root = null;
  });
  function render(elements) {
    if (root == null) {
      root = ReactDOMClient.createRoot(container);
    }
    root.render(elements);
    return unmount;
  }
  function unmount() {
    root.unmount();
  }
  function createContainer() {
    container = document.createElement('div');
    document.body.appendChild(container);
    root = null;
    containersToRemove.push(container);
  }
  function getContainer() {
    return container;
  }
  return {
    render: render,
    unmount: unmount,
    createContainer: createContainer,
    getContainer: getContainer
  };
}
var getVersionedRenderImplementation = exports.getVersionedRenderImplementation = _semver["default"].lt(requestedReactVersion, '18.0.0') ? getLegacyRenderImplementation : getModernRenderImplementation;
function beforeEachProfiling() {
  // Mock React's timing information so that test runs are predictable.
  jest.mock('scheduler', function () {
    return jest.requireActual('scheduler/unstable_mock');
  });

  // DevTools itself uses performance.now() to offset commit times
  // so they appear relative to when profiling was started in the UI.
  jest.spyOn(performance, 'now').mockImplementation(jest.requireActual('scheduler/unstable_mock').unstable_now);
}
function createDisplayNameFilter(source) {
  var isEnabled = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;
  var Types = require('react-devtools-shared/src/frontend/types');
  var isValid = true;
  try {
    new RegExp(source); // eslint-disable-line no-new
  } catch (error) {
    isValid = false;
  }
  return {
    type: Types.ComponentFilterDisplayName,
    isEnabled: isEnabled,
    isValid: isValid,
    value: source
  };
}
function createHOCFilter() {
  var isEnabled = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : true;
  var Types = require('react-devtools-shared/src/frontend/types');
  return {
    type: Types.ComponentFilterHOC,
    isEnabled: isEnabled,
    isValid: true
  };
}
function createElementTypeFilter(elementType) {
  var isEnabled = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;
  var Types = require('react-devtools-shared/src/frontend/types');
  return {
    type: Types.ComponentFilterElementType,
    isEnabled: isEnabled,
    value: elementType
  };
}
function createLocationFilter(source) {
  var isEnabled = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;
  var Types = require('react-devtools-shared/src/frontend/types');
  var isValid = true;
  try {
    new RegExp(source); // eslint-disable-line no-new
  } catch (error) {
    isValid = false;
  }
  return {
    type: Types.ComponentFilterLocation,
    isEnabled: isEnabled,
    isValid: isValid,
    value: source
  };
}
function getRendererID() {
  if (global.agent == null) {
    throw Error('Agent unavailable.');
  }
  var ids = Object.keys(global.agent._rendererInterfaces);
  var id = ids.find(function (innerID) {
    var rendererInterface = global.agent._rendererInterfaces[innerID];
    return rendererInterface.renderer.rendererPackageName === 'react-dom';
  });
  if (id == null) {
    throw Error('Could not find renderer.');
  }
  return parseInt(id, 10);
}
function legacyRender(elements, container) {
  if (container == null) {
    container = document.createElement('div');
  }
  var ReactDOM = require('react-dom');
  withErrorsOrWarningsIgnored(['ReactDOM.render has not been supported since React 18'], function () {
    ReactDOM.render(elements, container);
  });
  return function () {
    ReactDOM.unmountComponentAtNode(container);
  };
}
function requireTestRenderer() {
  var hook;
  try {
    // Hide the hook before requiring TestRenderer, so we don't end up with a loop.
    hook = global.__REACT_DEVTOOLS_GLOBAL_HOOK__;
    delete global.__REACT_DEVTOOLS_GLOBAL_HOOK__;
    return require('react-test-renderer');
  } finally {
    global.__REACT_DEVTOOLS_GLOBAL_HOOK__ = hook;
  }
}
function exportImportHelper(bridge, store) {
  var _require = require('react-devtools-shared/src/devtools/views/Profiler/utils'),
    prepareProfilingDataExport = _require.prepareProfilingDataExport,
    prepareProfilingDataFrontendFromExport = _require.prepareProfilingDataFrontendFromExport;
  var profilerStore = store.profilerStore;
  expect(profilerStore.profilingData).not.toBeNull();
  var profilingDataFrontendInitial = profilerStore.profilingData;
  expect(profilingDataFrontendInitial.imported).toBe(false);
  var profilingDataExport = prepareProfilingDataExport(profilingDataFrontendInitial);

  // Simulate writing/reading to disk.
  var serializedProfilingDataExport = JSON.stringify(profilingDataExport, null, 2);
  var parsedProfilingDataExport = JSON.parse(serializedProfilingDataExport);
  var profilingDataFrontend = prepareProfilingDataFrontendFromExport(parsedProfilingDataExport);
  expect(profilingDataFrontend.imported).toBe(true);

  // Sanity check that profiling snapshots are serialized correctly.
  expect(profilingDataFrontendInitial.dataForRoots).toEqual(profilingDataFrontend.dataForRoots);
  expect(profilingDataFrontendInitial.timelineData).toEqual(profilingDataFrontend.timelineData);

  // Snapshot the JSON-parsed object, rather than the raw string, because Jest formats the diff nicer.
  // expect(parsedProfilingDataExport).toMatchSnapshot('imported data');

  act(function () {
    // Apply the new exported-then-imported data so tests can re-run assertions.
    profilerStore.profilingData = profilingDataFrontend;
  });
}

/**
 * Runs `fn` while preventing console error and warnings that partially match any given `errorOrWarningMessages` from appearing in the console.
 * @param errorOrWarningMessages Messages are matched partially (i.e. indexOf), pre-formatting.
 * @param fn
 */
function withErrorsOrWarningsIgnored(errorOrWarningMessages, fn) {
  // withErrorsOrWarningsIgnored() may be nested.
  var prev = global._ignoredErrorOrWarningMessages || [];
  var resetIgnoredErrorOrWarningMessages = true;
  try {
    global._ignoredErrorOrWarningMessages = [].concat(_toConsumableArray(prev), _toConsumableArray(errorOrWarningMessages));
    var maybeThenable = fn();
    if (maybeThenable !== undefined && typeof maybeThenable.then === 'function') {
      resetIgnoredErrorOrWarningMessages = false;
      return maybeThenable.then(function () {
        global._ignoredErrorOrWarningMessages = prev;
      }, function () {
        global._ignoredErrorOrWarningMessages = prev;
      });
    }
  } finally {
    if (resetIgnoredErrorOrWarningMessages) {
      global._ignoredErrorOrWarningMessages = prev;
    }
  }
}
function overrideFeatureFlags(overrideFlags) {
  jest.mock('react-devtools-feature-flags', function () {
    var actualFlags = jest.requireActual('react-devtools-feature-flags');
    return _objectSpread(_objectSpread({}, actualFlags), overrideFlags);
  });
}
function normalizeCodeLocInfo(str) {
  if (_typeof(str) === 'object' && str !== null) {
    str = str.stack;
  }
  if (typeof str !== 'string') {
    return str;
  }
  // This special case exists only for the special source location in
  // ReactElementValidator. That will go away if we remove source locations.
  str = str.replace(/Check your code at .+?:\d+/g, 'Check your code at **');
  // V8 format:
  //  at Component (/path/filename.js:123:45)
  // React format:
  //    in Component (at filename.js:123)
  return str.replace(/\n +(?:at|in) ([\S]+)[^\n]*/g, function (m, name) {
    return '\n    in ' + name + ' (at **)';
  });
}