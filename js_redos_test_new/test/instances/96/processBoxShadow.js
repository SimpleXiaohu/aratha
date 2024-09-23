"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = processBoxShadow;
function _createForOfIteratorHelper(r, e) { var t = "undefined" != typeof Symbol && r[Symbol.iterator] || r["@@iterator"]; if (!t) { if (Array.isArray(r) || (t = _unsupportedIterableToArray(r)) || e && r && "number" == typeof r.length) { t && (r = t); var _n = 0, F = function F() {}; return { s: F, n: function n() { return _n >= r.length ? { done: !0 } : { done: !1, value: r[_n++] }; }, e: function e(r) { throw r; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var o, a = !0, u = !1; return { s: function s() { t = t.call(r); }, n: function n() { var r = t.next(); return a = r.done, r; }, e: function e(r) { u = !0, o = r; }, f: function f() { try { a || null == t["return"] || t["return"](); } finally { if (u) throw o; } } }; }
function _unsupportedIterableToArray(r, a) { if (r) { if ("string" == typeof r) return _arrayLikeToArray(r, a); var t = {}.toString.call(r).slice(8, -1); return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0; } }
function _arrayLikeToArray(r, a) { (null == a || a > r.length) && (a = r.length); for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e]; return n; }
/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * 
 * @format
 * @oncall react-native
 */

// import type {ProcessedColorValue} from './processColor';
// import type {BoxShadowPrimitive} from './StyleSheetTypes';

// import processColor from './processColor';

// export type ParsedBoxShadow = {
//   offsetX: number,
//   offsetY: number,
//   color?: ProcessedColorValue,
//   blurRadius?: number,
//   spreadDistance?: number,
//   inset?: boolean,
// };

function processBoxShadow(rawBoxShadows) {
  var result = [];
  if (rawBoxShadows == null) {
    return result;
  }
  var boxShadowList = typeof rawBoxShadows === 'string' ? parseBoxShadowString(rawBoxShadows) : rawBoxShadows;

  // for (const rawBoxShadow of boxShadowList) {
  //   const parsedBoxShadow = {
  //     offsetX: 0,
  //     offsetY: 0,
  //   };

  //   let value;
  //   for (const arg in rawBoxShadow) {
  //     switch (arg) {
  //       case 'offsetX':
  //         value =
  //           typeof rawBoxShadow.offsetX === 'string'
  //             ? parseLength(rawBoxShadow.offsetX)
  //             : rawBoxShadow.offsetX;
  //         if (value == null) {
  //           return [];
  //         }

  //         parsedBoxShadow.offsetX = value;
  //         break;
  //       case 'offsetY':
  //         value =
  //           typeof rawBoxShadow.offsetY === 'string'
  //             ? parseLength(rawBoxShadow.offsetY)
  //             : rawBoxShadow.offsetY;
  //         if (value == null) {
  //           return [];
  //         }

  //         parsedBoxShadow.offsetY = value;
  //         break;
  //       case 'spreadDistance':
  //         value =
  //           typeof rawBoxShadow.spreadDistance === 'string'
  //             ? parseLength(rawBoxShadow.spreadDistance)
  //             : rawBoxShadow.spreadDistance;
  //         if (value == null) {
  //           return [];
  //         }

  //         parsedBoxShadow.spreadDistance = value;
  //         break;
  //       case 'blurRadius':
  //         value =
  //           typeof rawBoxShadow.blurRadius === 'string'
  //             ? parseLength(rawBoxShadow.blurRadius)
  //             : rawBoxShadow.blurRadius;
  //         if (value == null || value < 0) {
  //           return [];
  //         }

  //         parsedBoxShadow.blurRadius = value;
  //         break;
  //       case 'color':
  //         const color = processColor(rawBoxShadow.color);
  //         if (color == null) {
  //           return [];
  //         }

  //         parsedBoxShadow.color = color;
  //         break;
  //       case 'inset':
  //         parsedBoxShadow.inset = rawBoxShadow.inset;
  //     }
  //   }
  //   result.push(parsedBoxShadow);
  // }
  // return result;
}
function parseBoxShadowString(rawBoxShadows) {
  var result = [];
  var _iterator = _createForOfIteratorHelper(rawBoxShadows.split(/,(?![^()]*\))/) // split by comma that is not in parenthesis
    .map(function (bS) {
      return bS.trim();
    }).filter(function (bS) {
      return bS !== '';
    })),
    _step;
  try {
    for (_iterator.s(); !(_step = _iterator.n()).done;) {
      var rawBoxShadow = _step.value;
      var boxShadow = {
        offsetX: 0,
        offsetY: 0
      };
      var offsetX = void 0;
      var offsetY = void 0;
      var keywordDetectedAfterLength = false;
      var lengthCount = 0;

      // split rawBoxShadow string by all whitespaces that are not in parenthesis
      var args = rawBoxShadow.split(/\s+(?![^(]*\))/);
      //   for (const arg of args) {
      //     const processedColor = processColor(arg);
      //     if (processedColor != null) {
      //       if (boxShadow.color != null) {
      //         return [];
      //       }
      //       if (offsetX != null) {
      //         keywordDetectedAfterLength = true;
      //       }
      //       boxShadow.color = arg;
      //       continue;
      //     }

      //     if (arg === 'inset') {
      //       if (boxShadow.inset != null) {
      //         return [];
      //       }
      //       if (offsetX != null) {
      //         keywordDetectedAfterLength = true;
      //       }
      //       boxShadow.inset = true;
      //       continue;
      //     }

      //     switch (lengthCount) {
      //       case 0:
      //         offsetX = arg;
      //         lengthCount++;
      //         break;
      //       case 1:
      //         if (keywordDetectedAfterLength) {
      //           return [];
      //         }
      //         offsetY = arg;
      //         lengthCount++;
      //         break;
      //       case 2:
      //         if (keywordDetectedAfterLength) {
      //           return [];
      //         }
      //         boxShadow.blurRadius = arg;
      //         lengthCount++;
      //         break;
      //       case 3:
      //         if (keywordDetectedAfterLength) {
      //           return [];
      //         }
      //         boxShadow.spreadDistance = arg;
      //         lengthCount++;
      //         break;
      //       default:
      //         return [];
      //     }
      //   }

      //   if (offsetX == null || offsetY == null) {
      //     return [];
      //   }

      //   boxShadow.offsetX = offsetX;
      //   boxShadow.offsetY = offsetY;

      //   result.push(boxShadow);
    }
    // return result;
  } catch (err) {
    _iterator.e(err);
  } finally {
    _iterator.f();
  }
}

// function parseLength(length: string): ?number {
//   // matches on args with units like "1.5 5% -80deg"
//   const argsWithUnitsRegex = /([+-]?\d*(\.\d+)?)([\w\W]+)?/g;
//   const match = argsWithUnitsRegex.exec(length);

//   if (!match || Number.isNaN(match[1])) {
//     return null;
//   }

//   if (match[3] != null && match[3] !== 'px') {
//     return null;
//   }

//   return Number(match[1]);
// }