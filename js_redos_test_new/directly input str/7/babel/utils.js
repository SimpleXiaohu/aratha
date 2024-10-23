"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.cleanForBridge = cleanForBridge;
exports.copyWithDelete = copyWithDelete;
exports.copyWithRename = copyWithRename;
exports.copyWithSet = copyWithSet;
exports.formatConsoleArguments = formatConsoleArguments;
exports.formatConsoleArgumentsToSingleString = formatConsoleArgumentsToSingleString;
exports.formatWithStyles = formatWithStyles;
exports.getEffectDurations = getEffectDurations;
exports.gt = gt;
exports.gte = gte;
exports.hasAssignedBackend = hasAssignedBackend;
exports.isReactNativeEnvironment = void 0;
exports.isSynchronousXHRSupported = isSynchronousXHRSupported;
exports.parseSourceFromComponentStack = parseSourceFromComponentStack;
exports.serializeToString = serializeToString;
function _createForOfIteratorHelper(r, e) { var __temp_11__ = "undefined" != typeof Symbol; if (__temp_11__) __temp_11__ = r[Symbol.iterator]; var __temp_12__ = __temp_11__; if (!__temp_12__) __temp_12__ = r["@@iterator"]; var t = __temp_12__; if (!t) { if (Array.isArray(r) || (t = _unsupportedIterableToArray(r)) || e && r && "number" == typeof r.length) { t && (r = t); var _n = 0, F = function F() {}; return { s: F, n: function n() { return _n >= r.length ? { done: !0 } : { done: !1, value: r[_n++] }; }, e: function e(r) { throw r; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var o, a = !0, u = !1; return { s: function s() { t = t.call(r); }, n: function n() { var r = t.next(); return a = r.done, r; }, e: function e(r) { u = !0, o = r; }, f: function f() { try { a || null == t["return"] || t["return"](); } finally { if (u) throw o; } } }; }
function _slicedToArray(r, e) { return _arrayWithHoles(r) || _iterableToArrayLimit(r, e) || _unsupportedIterableToArray(r, e) || _nonIterableRest(); }
function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _iterableToArrayLimit(r, l) { var __temp_9__ = "undefined" != typeof Symbol; if (__temp_9__) __temp_9__ = r[Symbol.iterator]; var __temp_10__ = __temp_9__; if (!__temp_10__) __temp_10__ = r["@@iterator"]; var t = null == r ? null : __temp_10__; if (null != t) { var e, n, i, u, a = [], f = !0, o = !1; try { if (i = (t = t.call(r)).next, 0 === l) { if (Object(t) !== t) return; f = !1; } else for (; !(f = (e = i.call(t)).done) && (a.push(e.value), a.length !== l); f = !0); } catch (r) { o = !0, n = r; } finally { try { if (!f && null != t["return"] && (u = t["return"](), Object(u) !== u)) return; } finally { if (o) throw n; } } return a; } }
function _arrayWithHoles(r) { if (Array.isArray(r)) return r; }
function _toConsumableArray(r) { return _arrayWithoutHoles(r) || _iterableToArray(r) || _unsupportedIterableToArray(r) || _nonIterableSpread(); }
function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _unsupportedIterableToArray(r, a) { if (r) { if ("string" == typeof r) return _arrayLikeToArray(r, a); var t = {}.toString.call(r).slice(8, -1); return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0; } }
function _iterableToArray(r) { if ("undefined" != typeof Symbol && null != r[Symbol.iterator] || null != r["@@iterator"]) return Array.from(r); }
function _arrayWithoutHoles(r) { if (Array.isArray(r)) return _arrayLikeToArray(r); }
function _arrayLikeToArray(r, a) { (null == a || a > r.length) && (a = r.length); for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e]; return n; }
function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); }
function ownKeys(e, r) { var t = Object.keys(e); if (Object.getOwnPropertySymbols) { var o = Object.getOwnPropertySymbols(e); r && (o = o.filter(function (r) { return Object.getOwnPropertyDescriptor(e, r).enumerable; })), t.push.apply(t, o); } return t; }
function _objectSpread(e) { for (var r = 1; r < arguments.length; r++) { var t = null != arguments[r] ? arguments[r] : {}; r % 2 ? ownKeys(Object(t), !0).forEach(function (r) { _defineProperty(e, r, t[r]); }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : ownKeys(Object(t)).forEach(function (r) { Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r)); }); } return e; }
function _defineProperty(e, r, t) { return (r = _toPropertyKey(r)) in e ? Object.defineProperty(e, r, { value: t, enumerable: !0, configurable: !0, writable: !0 }) : e[r] = t, e; }
function _toPropertyKey(t) { var i = _toPrimitive(t, "string"); return "symbol" == _typeof(i) ? i : i + ""; }
function _toPrimitive(t, r) { if ("object" != _typeof(t) || !t) return t; var e = t[Symbol.toPrimitive]; if (void 0 !== e) { var __temp_8__ = r; if (!__temp_8__) __temp_8__ = "default"; var i = e.call(t, __temp_8__); if ("object" != _typeof(i)) return i; throw new TypeError("@@toPrimitive must return a primitive value."); } return ("string" === r ? String : Number)(t); }
/**
/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * 
 */

// import {compareVersions} from 'compare-versions';
// import {dehydrate} from '../hydration';
// import isArray from 'shared/isArray';

// import {Source} from 'react-devtools-shared/src/shared/types';
// import {DehydratedData} from 'react-devtools-shared/src/frontend/types';

// TODO: update this to the first React version that has a corresponding DevTools backend
var FIRST_DEVTOOLS_BACKEND_LOCKSTEP_VER = '999.9.9';
function hasAssignedBackend(version) {
  if (version == null || version === '') {
    return false;
  }
  return gte(version, FIRST_DEVTOOLS_BACKEND_LOCKSTEP_VER);
}
function cleanForBridge(data, isPathAllowed) {
  var __temp_0__ = arguments.length > 2;
  if (__temp_0__) __temp_0__ = arguments[2] !== undefined;
  var path = __temp_0__ ? arguments[2] : [];
  if (data !== null) {
    var cleanedPaths = [];
    var unserializablePaths = [];
    var cleanedData = dehydrate(data, cleanedPaths, unserializablePaths, path, isPathAllowed);
    return {
      data: cleanedData,
      cleaned: cleanedPaths,
      unserializable: unserializablePaths
    };
  } else {
    return null;
  }
}
function copyWithDelete(obj, path) {
  var __temp_1__ = arguments.length > 2;
  if (__temp_1__) __temp_1__ = arguments[2] !== undefined;
  var index = __temp_1__ ? arguments[2] : 0;
  var key = path[index];
  var updated = isArray(obj) ? obj.slice() : _objectSpread({}, obj);
  if (index + 1 === path.length) {
    if (isArray(updated)) {
      updated.splice(key, 1);
    } else {
      delete updated[key];
    }
  } else {
    // $FlowFixMe[incompatible-use] number or string is fine here
    updated[key] = copyWithDelete(obj[key], path, index + 1);
  }
  return updated;
}

// This function expects paths to be the same except for the final value.
// e.g. ['path', 'to', 'foo'] and ['path', 'to', 'bar']
function copyWithRename(obj, oldPath, newPath) {
  var __temp_2__ = arguments.length > 3;
  if (__temp_2__) __temp_2__ = arguments[3] !== undefined;
  var index = __temp_2__ ? arguments[3] : 0;
  var oldKey = oldPath[index];
  var updated = isArray(obj) ? obj.slice() : _objectSpread({}, obj);
  if (index + 1 === oldPath.length) {
    var newKey = newPath[index];
    // $FlowFixMe[incompatible-use] number or string is fine here
    updated[newKey] = updated[oldKey];
    if (isArray(updated)) {
      updated.splice(oldKey, 1);
    } else {
      delete updated[oldKey];
    }
  } else {
    // $FlowFixMe[incompatible-use] number or string is fine here
    updated[oldKey] = copyWithRename(obj[oldKey], oldPath, newPath, index + 1);
  }
  return updated;
}
function copyWithSet(obj, path, value) {
  var __temp_3__ = arguments.length > 3;
  if (__temp_3__) __temp_3__ = arguments[3] !== undefined;
  var index = __temp_3__ ? arguments[3] : 0;
  if (index >= path.length) {
    return value;
  }
  var key = path[index];
  var updated = isArray(obj) ? obj.slice() : _objectSpread({}, obj);
  // $FlowFixMe[incompatible-use] number or string is fine here
  updated[key] = copyWithSet(obj[key], path, value, index + 1);
  return updated;
}
function getEffectDurations(root) {
  // Profiling durations are only available for certain builds.
  // If available, they'll be stored on the HostRoot.
  var effectDuration = null;
  var passiveEffectDuration = null;
  var hostRoot = root.current;
  if (hostRoot != null) {
    var stateNode = hostRoot.stateNode;
    if (stateNode != null) {
      effectDuration = stateNode.effectDuration != null ? stateNode.effectDuration : null;
      passiveEffectDuration = stateNode.passiveEffectDuration != null ? stateNode.passiveEffectDuration : null;
    }
  }
  return {
    effectDuration: effectDuration,
    passiveEffectDuration: passiveEffectDuration
  };
}
function serializeToString(data) {
  if (data === undefined) {
    return 'undefined';
  }
  if (typeof data === 'function') {
    return data.toString();
  }
  var cache = new Set();
  // Use a custom replacer function to protect against circular references.
  return JSON.stringify(data, function (key, value) {
    if (_typeof(value) === 'object' && value !== null) {
      if (cache.has(value)) {
        return;
      }
      cache.add(value);
    }
    if (typeof value === 'bigint') {
      return value.toString() + 'n';
    }
    return value;
  }, 2);
}

// NOTE: KEEP IN SYNC with src/hook.js
// Formats an array of args with a style for console methods, using
// the following algorithm:
//     1. The first param is a string that contains %c
//          - Bail out and return the args without modifying the styles.
//            We don't want to affect styles that the developer deliberately set.
//     2. The first param is a string that doesn't contain %c but contains
//        string formatting
//          - [`%c${args[0]}`, style, ...args.slice(1)]
//          - Note: we assume that the string formatting that the developer uses
//            is correct.
//     3. The first param is a string that doesn't contain string formatting
//        OR is not a string
//          - Create a formatting string where:
//                 boolean, string, symbol -> %s
//                 number -> %f OR %i depending on if it's an int or float
//                 default -> %o
function formatWithStyles(inputArgs, style) {
  if (inputArgs === undefined || inputArgs === null || inputArgs.length === 0 ||
  // Matches any of %c but not %%c
  typeof inputArgs[0] === 'string' && inputArgs[0].match(/([^%]|^)(%c)/g) || style === undefined) {
    return inputArgs;
  }

  // Matches any of %(o|O|d|i|s|f), but not %%(o|O|d|i|s|f)
  var REGEXP = /([^%]|^)((%%)*)(%([oOdisf]))/g;
  if (typeof inputArgs[0] === 'string' && inputArgs[0].match(REGEXP)) {
    return ["%c".concat(inputArgs[0]), style].concat(_toConsumableArray(inputArgs.slice(1)));
  } else {
    var firstArg = inputArgs.reduce(function (formatStr, elem, i) {
      if (i > 0) {
        formatStr += ' ';
      }
      switch (_typeof(elem)) {
        case 'string':
        case 'boolean':
        case 'symbol':
          return formatStr += '%s';
        case 'number':
          var formatting = Number.isInteger(elem) ? '%i' : '%f';
          return formatStr += formatting;
        default:
          return formatStr += '%o';
      }
    }, '%c');
    return [firstArg, style].concat(_toConsumableArray(inputArgs));
  }
}

// NOTE: KEEP IN SYNC with src/hook.js
// Skips CSS and object arguments, inlines other in the first argument as a template string
function formatConsoleArguments(maybeMessage) {
  for (var _len = arguments.length, inputArgs = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
    inputArgs[_key - 1] = arguments[_key];
  }
  if (inputArgs.length === 0 || typeof maybeMessage !== 'string') {
    return [maybeMessage].concat(inputArgs);
  }
  var args = inputArgs.slice();
  var template = '';
  var argumentsPointer = 0;
  for (var i = 0; i < maybeMessage.length; ++i) {
    var currentChar = maybeMessage[i];
    if (currentChar !== '%') {
      template += currentChar;
      continue;
    }
    var nextChar = maybeMessage[i + 1];
    ++i;

    // Only keep CSS and objects, inline other arguments
    switch (nextChar) {
      case 'c':
      case 'O':
      case 'o':
        {
          ++argumentsPointer;
          template += "%".concat(nextChar);
          break;
        }
      case 'd':
      case 'i':
        {
          var _args$splice = args.splice(argumentsPointer, 1),
            _args$splice2 = _slicedToArray(_args$splice, 1),
            arg = _args$splice2[0];
          template += parseInt(arg, 10).toString();
          break;
        }
      case 'f':
        {
          var _args$splice3 = args.splice(argumentsPointer, 1),
            _args$splice4 = _slicedToArray(_args$splice3, 1),
            _arg = _args$splice4[0];
          template += parseFloat(_arg).toString();
          break;
        }
      case 's':
        {
          var _args$splice5 = args.splice(argumentsPointer, 1),
            _args$splice6 = _slicedToArray(_args$splice5, 1),
            _arg2 = _args$splice6[0];
          template += _arg2.toString();
          break;
        }
      default:
        template += "%".concat(nextChar);
    }
  }
  return [template].concat(_toConsumableArray(args));
}

// based on https://github.com/tmpfs/format-util/blob/0e62d430efb0a1c51448709abd3e2406c14d8401/format.js#L1
// based on https://developer.mozilla.org/en-US/docs/Web/API/console#Using_string_substitutions
// Implements s, d, i and f placeholders
function formatConsoleArgumentsToSingleString(maybeMessage) {
  for (var _len2 = arguments.length, inputArgs = new Array(_len2 > 1 ? _len2 - 1 : 0), _key2 = 1; _key2 < _len2; _key2++) {
    inputArgs[_key2 - 1] = arguments[_key2];
  }
  var args = inputArgs.slice();
  var formatted = String(maybeMessage);

  // If the first argument is a string, check for substitutions.
  if (typeof maybeMessage === 'string') {
    if (args.length) {
      var REGEXP = /(%?)(%([jds]))/g;
      formatted = formatted.replace(REGEXP, function (match, escaped, ptn, flag) {
        var arg = args.shift();
        switch (flag) {
          case 's':
            arg += '';
            break;
          case 'd':
          case 'i':
            arg = parseInt(arg, 10).toString();
            break;
          case 'f':
            arg = parseFloat(arg).toString();
            break;
        }
        if (!escaped) {
          return arg;
        }
        args.unshift(arg);
        return match;
      });
    }
  }

  // Arguments that remain after formatting.
  if (args.length) {
    for (var i = 0; i < args.length; i++) {
      formatted += ' ' + String(args[i]);
    }
  }

  // Update escaped %% values.
  formatted = formatted.replace(/%{2,2}/g, '%');
  return String(formatted);
}
function isSynchronousXHRSupported() {
  return !!(window.document && window.document.featurePolicy && window.document.featurePolicy.allowsFeature('sync-xhr'));
}
function gt() {
  var __temp_4__ = arguments.length > 0;
  if (__temp_4__) __temp_4__ = arguments[0] !== undefined;
  var a = __temp_4__ ? arguments[0] : '';
  var __temp_5__ = arguments.length > 1;
  if (__temp_5__) __temp_5__ = arguments[1] !== undefined;
  var b = __temp_5__ ? arguments[1] : '';
  return compareVersions(a, b) === 1;
}
function gte() {
  var __temp_6__ = arguments.length > 0;
  if (__temp_6__) __temp_6__ = arguments[0] !== undefined;
  var a = __temp_6__ ? arguments[0] : '';
  var __temp_7__ = arguments.length > 1;
  if (__temp_7__) __temp_7__ = arguments[1] !== undefined;
  var b = __temp_7__ ? arguments[1] : '';
  return compareVersions(a, b) > -1;
}
var isReactNativeEnvironment = exports.isReactNativeEnvironment = function isReactNativeEnvironment() {
  // We've been relying on this for such a long time
  // We should probably define the client for DevTools on the backend side and share it with the frontend
  return window.document == null;
};
function extractLocation(url) {
  if (url.indexOf(":") === -1) {
    return null;
  }
  // remove any parentheses from start and end
  var withoutParentheses = url.replace(/^\(+/, "").replace(/\)+$/, "");
  var locationParts = /(at )?(.+?)(?::(\d+))?(?::(\d+))?$/.exec(withoutParentheses);
  if (locationParts == null) {
    return null;
  }
  var _locationParts = _slicedToArray(locationParts, 5),
    sourceURL = _locationParts[2],
    line = _locationParts[3],
    column = _locationParts[4];
  return {
    sourceURL: sourceURL,
    line: line,
    column: column
  };
}
var CHROME_STACK_REGEXP = /^\s*at .*(\S+:\d+|\(native\))/m;
function parseSourceFromChromeStack(stack) {
  var frames = stack.split('\n');
  // eslint-disable-next-line no-for-of-loops/no-for-of-loops
  var _iterator = _createForOfIteratorHelper(frames),
    _step;
  try {
    for (_iterator.s(); !(_step = _iterator.n()).done;) {
      var frame = _step.value;
      var sanitizedFrame = frame.trim();
      var locationInParenthesesMatch = sanitizedFrame.match(/ (\(.+\)$)/);
      var possibleLocation = locationInParenthesesMatch ? locationInParenthesesMatch[1] : sanitizedFrame;
      var location = extractLocation(possibleLocation);
      // Continue the search until at least sourceURL is found
      if (location == null) {
        continue;
      }
      var sourceURL = location.sourceURL,
        _location$line = location.line,
        line = _location$line === void 0 ? '1' : _location$line,
        _location$column = location.column,
        column = _location$column === void 0 ? '1' : _location$column;
      return {
        sourceURL: sourceURL,
        line: parseInt(line, 10),
        column: parseInt(column, 10)
      };
    }
  } catch (err) {
    _iterator.e(err);
  } finally {
    _iterator.f();
  }
  return null;
}
function parseSourceFromFirefoxStack(stack) {
  var frames = stack.split('\n');
  // eslint-disable-next-line no-for-of-loops/no-for-of-loops
  var _iterator2 = _createForOfIteratorHelper(frames),
    _step2;
  try {
    for (_iterator2.s(); !(_step2 = _iterator2.n()).done;) {
      var frame = _step2.value;
      var sanitizedFrame = frame.trim();
      var frameWithoutFunctionName = sanitizedFrame.replace(/((.*".+"[^@]*)?[^@]*)(?:@)/, '');
      var location = extractLocation(frameWithoutFunctionName);
      // Continue the search until at least sourceURL is found
      if (location == null) {
        continue;
      }
      var sourceURL = location.sourceURL,
        _location$line2 = location.line,
        line = _location$line2 === void 0 ? '1' : _location$line2,
        _location$column2 = location.column,
        column = _location$column2 === void 0 ? '1' : _location$column2;
      return {
        sourceURL: sourceURL,
        line: parseInt(line, 10),
        column: parseInt(column, 10)
      };
    }
  } catch (err) {
    _iterator2.e(err);
  } finally {
    _iterator2.f();
  }
  return null;
}
function parseSourceFromComponentStack(componentStack) {
  if (componentStack.match(/^\s*at .*(\S+:\d+|\(native\))/m)) {
    return parseSourceFromChromeStack(componentStack);
  }
  return parseSourceFromFirefoxStack(componentStack);
}