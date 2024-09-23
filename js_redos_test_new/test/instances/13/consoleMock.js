"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.assertConsoleLogsCleared = assertConsoleLogsCleared;
exports.clearErrors = clearErrors;
exports.clearLogs = clearLogs;
exports.clearWarnings = clearWarnings;
exports.createLogAssertion = createLogAssertion;
var _chalk = _interopRequireDefault(require("chalk"));
var _util = _interopRequireDefault(require("util"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
function _toConsumableArray(r) { return _arrayWithoutHoles(r) || _iterableToArray(r) || _unsupportedIterableToArray(r) || _nonIterableSpread(); }
function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _arrayWithoutHoles(r) { if (Array.isArray(r)) return _arrayLikeToArray(r); }
function _toArray(r) { return _arrayWithHoles(r) || _iterableToArray(r) || _unsupportedIterableToArray(r) || _nonIterableRest(); }
function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _unsupportedIterableToArray(r, a) { if (r) { if ("string" == typeof r) return _arrayLikeToArray(r, a); var t = {}.toString.call(r).slice(8, -1); return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0; } }
function _arrayLikeToArray(r, a) { (null == a || a > r.length) && (a = r.length); for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e]; return n; }
function _iterableToArray(r) { if ("undefined" != typeof Symbol && null != r[Symbol.iterator] || null != r["@@iterator"]) return Array.from(r); }
function _arrayWithHoles(r) { if (Array.isArray(r)) return r; }
function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); } // /**
//  * Copyright (c) Meta Platforms, Inc. and affiliates.
//  *
//  * This source code is licensed under the MIT license found in the
//  * LICENSE file in the root directory of this source tree.
//  */
// /* eslint-disable react-internal/no-production-logging */
// const chalk = require('chalk');
// const shouldIgnoreConsoleError = require('./shouldIgnoreConsoleError');
// const shouldIgnoreConsoleWarn = require('./shouldIgnoreConsoleWarn');
// import {diff} from 'jest-diff';
// import {printReceived} from 'jest-matcher-utils';

// // Annoying: need to store the log array on the global or it would
// // change reference whenever you call jest.resetModules after patch.
// const loggedErrors = (global.__loggedErrors = global.__loggedErrors || []);
// const loggedWarns = (global.__loggedWarns = global.__loggedWarns || []);
// const loggedLogs = (global.__loggedLogs = global.__loggedLogs || []);

// // TODO: delete these after code modding away from toWarnDev.
// const unexpectedErrorCallStacks = (global.__unexpectedErrorCallStacks =
//   global.__unexpectedErrorCallStacks || []);
// const unexpectedWarnCallStacks = (global.__unexpectedWarnCallStacks =
//   global.__unexpectedWarnCallStacks || []);
// const unexpectedLogCallStacks = (global.__unexpectedLogCallStacks =
//   global.__unexpectedLogCallStacks || []);

// const patchConsoleMethod = (
//   methodName,
//   unexpectedConsoleCallStacks,
//   logged,
// ) => {
//   const newMethod = function (format, ...args) {
//     // Ignore uncaught errors reported by jsdom
//     // and React addendums because they're too noisy.
//     if (shouldIgnoreConsoleError(format, args)) {
//       return;
//     }

//     // Ignore certain React warnings causing test failures
//     if (methodName === 'warn' && shouldIgnoreConsoleWarn(format)) {
//       return;
//     }

//     // Append Component Stacks. Simulates a framework or DevTools appending them.
//     if (
//       typeof format === 'string' &&
//       (methodName === 'error' || methodName === 'warn')
//     ) {
//       const React = require('react');
//       if (React.captureOwnerStack) {
//         // enableOwnerStacks enabled. When it's always on, we can assume this case.
//         const stack = React.captureOwnerStack();
//         if (stack) {
//           format += '%s';
//           args.push(stack);
//         }
//       } else {
//         // Otherwise we have to use internals to emulate parent stacks.
//         const ReactSharedInternals =
//           React.__CLIENT_INTERNALS_DO_NOT_USE_OR_WARN_USERS_THEY_CANNOT_UPGRADE ||
//           React.__SERVER_INTERNALS_DO_NOT_USE_OR_WARN_USERS_THEY_CANNOT_UPGRADE;
//         if (ReactSharedInternals && ReactSharedInternals.getCurrentStack) {
//           const stack = ReactSharedInternals.getCurrentStack();
//           if (stack !== '') {
//             format += '%s';
//             args.push(stack);
//           }
//         }
//       }
//     }

//     // Capture the call stack now so we can warn about it later.
//     // The call stack has helpful information for the test author.
//     // Don't throw yet though b'c it might be accidentally caught and suppressed.
//     const stack = new Error().stack;
//     unexpectedConsoleCallStacks.push([
//       stack.slice(stack.indexOf('\n') + 1),
//       util.format(format, ...args),
//     ]);
//     logged.push([format, ...args]);
//   };

//   console[methodName] = newMethod;

//   return newMethod;
// };

// const flushUnexpectedConsoleCalls = (
//   mockMethod,
//   methodName,
//   expectedMatcher,
//   unexpectedConsoleCallStacks,
// ) => {
//   if (
//     console[methodName] !== mockMethod &&
//     !jest.isMockFunction(console[methodName])
//   ) {
//     // throw new Error(
//     //  `Test did not tear down console.${methodName} mock properly.`
//     // );
//   }
//   if (unexpectedConsoleCallStacks.length > 0) {
//     const messages = unexpectedConsoleCallStacks.map(
//       ([stack, message]) =>
//         `${chalk.red(message)}\n` +
//         `${stack
//           .split('\n')
//           .map(line => chalk.gray(line))
//           .join('\n')}`,
//     );

//     const type = methodName === 'log' ? 'log' : 'warning';
//     const message =
//       `Expected test not to call ${chalk.bold(
//         `console.${methodName}()`,
//       )}.\n\n` +
//       `If the ${type} is expected, test for it explicitly by:\n` +
//       `1. Using ${chalk.bold(expectedMatcher + '()')} or...\n` +
//       `2. Mock it out using ${chalk.bold(
//         'spyOnDev',
//       )}(console, '${methodName}') or ${chalk.bold(
//         'spyOnProd',
//       )}(console, '${methodName}'), and test that the ${type} occurs.`;

//     throw new Error(`${message}\n\n${messages.join('\n\n')}`);
//   }
// };

// let errorMethod;
// let warnMethod;
// let logMethod;
// export function patchConsoleMethods({includeLog} = {includeLog: false}) {
//   errorMethod = patchConsoleMethod(
//     'error',
//     unexpectedErrorCallStacks,
//     loggedErrors,
//   );
//   warnMethod = patchConsoleMethod(
//     'warn',
//     unexpectedWarnCallStacks,
//     loggedWarns,
//   );

//   // Only assert console.log isn't called in CI so you can debug tests in DEV.
//   // The matchers will still work in DEV, so you can assert locally.
//   if (includeLog) {
//     logMethod = patchConsoleMethod('log', unexpectedLogCallStacks, loggedLogs);
//   }
// }

// export function flushAllUnexpectedConsoleCalls() {
//   flushUnexpectedConsoleCalls(
//     errorMethod,
//     'error',
//     'assertConsoleErrorDev',
//     unexpectedErrorCallStacks,
//   );
//   flushUnexpectedConsoleCalls(
//     warnMethod,
//     'warn',
//     'assertConsoleWarnDev',
//     unexpectedWarnCallStacks,
//   );
//   if (logMethod) {
//     flushUnexpectedConsoleCalls(
//       logMethod,
//       'log',
//       'assertConsoleLogDev',
//       unexpectedLogCallStacks,
//     );
//     unexpectedLogCallStacks.length = 0;
//   }
//   unexpectedErrorCallStacks.length = 0;
//   unexpectedWarnCallStacks.length = 0;
// }

// export function resetAllUnexpectedConsoleCalls() {
//   loggedErrors.length = 0;
//   loggedWarns.length = 0;
//   unexpectedErrorCallStacks.length = 0;
//   unexpectedWarnCallStacks.length = 0;
//   if (logMethod) {
//     loggedLogs.length = 0;
//     unexpectedLogCallStacks.length = 0;
//   }
// }

function clearLogs() {
  var logs = Array.from(loggedLogs);
  unexpectedLogCallStacks.length = 0;
  loggedLogs.length = 0;
  return logs;
}
function clearWarnings() {
  var warnings = Array.from(loggedWarns);
  unexpectedWarnCallStacks.length = 0;
  loggedWarns.length = 0;
  return warnings;
}
function clearErrors() {
  var errors = Array.from(loggedErrors);
  unexpectedErrorCallStacks.length = 0;
  loggedErrors.length = 0;
  return errors;
}
function assertConsoleLogsCleared() {
  var logs = clearLogs();
  var warnings = clearWarnings();
  var errors = clearErrors();
  if (logs.length > 0 || errors.length > 0 || warnings.length > 0) {
    var message = "".concat(_chalk["default"].dim('asserConsoleLogsCleared'), "(").concat(_chalk["default"].red('expected'), ")\n");
    if (logs.length > 0) {
      message += "\nconsole.log was called without assertConsoleLogDev:\n".concat(diff('', logs.join('\n'), {
        omitAnnotationLines: true
      }), "\n");
    }
    if (warnings.length > 0) {
      message += "\nconsole.warn was called without assertConsoleWarnDev:\n".concat(diff('', warnings.map(normalizeComponentStack).join('\n'), {
        omitAnnotationLines: true
      }), "\n");
    }
    if (errors.length > 0) {
      message += "\nconsole.error was called without assertConsoleErrorDev:\n".concat(diff('', errors.map(normalizeComponentStack).join('\n'), {
        omitAnnotationLines: true
      }), "\n");
    }
    message += "\nYou must call one of the assertConsoleDev helpers between each act call.";
    var error = Error(message);
    Error.captureStackTrace(error, assertConsoleLogsCleared);
    throw error;
  }
}
function normalizeCodeLocInfo(str) {
  if (typeof str !== "string") {
    return str;
  }
  // This special case exists only for the special source location in
  // ReactElementValidator. That will go away if we remove source locations.
  str = str.replace(/Check your code at .+?:\d+/g, "Check your code at **");
  // V8 format:
  //  at Component (/path/filename.js:123:45)
  // React format:
  //    in Component (at filename.js:123)
  return str.replace(/\n +(?:at|in) ([\S]+)[^\n]*/g, function (m, name) {
    if (name.endsWith(".render")) {
      // Class components will have the `render` method as part of their stack trace.
      // We strip that out in our normalization to make it look more like component stacks.
      name = name.slice(0, name.length - 7);
    }
    return "\n    in " + name + " (at **)";
  });
}
function normalizeComponentStack(entry) {
  if (typeof entry[0] === 'string' && entry[0].endsWith('%s') && isLikelyAComponentStack(entry[entry.length - 1])) {
    var clone = entry.slice(0);
    clone[clone.length - 1] = normalizeCodeLocInfo(entry[entry.length - 1]);
    return clone;
  }
  return entry;
}

// const isLikelyAComponentStack = message =>
//   typeof message === 'string' &&
//   (message.indexOf('<component stack>') > -1 ||
//     message.includes('\n    in ') ||
//     message.includes('\n    at '));

function createLogAssertion(consoleMethod, matcherName, clearObservedErrors) {
  function logName() {
    switch (consoleMethod) {
      case 'log':
        return 'log';
      case 'error':
        return 'error';
      case 'warn':
        return 'warning';
    }
  }
  return function assertConsoleLog(expectedMessages) {
    var options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
    if (true) {
      // eslint-disable-next-line no-inner-declarations
      var throwFormattedError = function throwFormattedError(message) {
        var error = new Error("".concat(_chalk["default"].dim(matcherName), "(").concat(_chalk["default"].red('expected'), ")\n\n").concat(message.trim()));
        Error.captureStackTrace(error, assertConsoleLog);
        throw error;
      }; // Warn about incorrect usage first arg.
      // Helper for pretty printing diffs consistently.
      // We inline multi-line logs for better diff printing.
      // eslint-disable-next-line no-inner-declarations
      var printDiff = function printDiff() {
        return "".concat(diff(expectedMessages.map(function (messageOrTuple) {
          var message = Array.isArray(messageOrTuple) ? messageOrTuple[0] : messageOrTuple;
          return message.replace('\n', ' ');
        }).join('\n'), receivedLogs.map(function (message) {
          return message.replace('\n', ' ');
        }).join('\n'), {
          aAnnotation: "Expected ".concat(logName(), "s"),
          bAnnotation: "Received ".concat(logName(), "s")
        }));
      }; // Any unexpected warnings should be treated as a failure.
      if (!Array.isArray(expectedMessages)) {
        throwFormattedError("Expected messages should be an array of strings " + "but was given type \"".concat(_typeof(expectedMessages), "\"."));
      }

      // Warn about incorrect usage second arg.
      if (options != null) {
        if (_typeof(options) !== 'object' || Array.isArray(options)) {
          throwFormattedError("The second argument should be an object. " + 'Did you forget to wrap the messages into an array?');
        }
      }
      var withoutStack = options.withoutStack;

      // Warn about invalid global withoutStack values.
      if (consoleMethod === 'log' && withoutStack !== undefined) {
        throwFormattedError("Do not pass withoutStack to assertConsoleLogDev, console.log does not have component stacks.");
      } else if (withoutStack !== undefined && withoutStack !== true) {
        // withoutStack can only have a value true.
        throwFormattedError("The second argument must be {withoutStack: true}." + "\n\nInstead received ".concat(JSON.stringify(options), "."));
      }
      var observedLogs = clearObservedErrors();
      var receivedLogs = [];
      var missingExpectedLogs = Array.from(expectedMessages);
      var unexpectedLogs = [];
      var unexpectedMissingComponentStack = [];
      var unexpectedIncludingComponentStack = [];
      var logsMismatchingFormat = [];
      var logsWithExtraComponentStack = [];

      // Loop over all the observed logs to determine:
      //   - Which expected logs are missing
      //   - Which received logs are unexpected
      //   - Which logs have a component stack
      //   - Which logs have the wrong format
      //   - Which logs have extra stacks
      var _loop = function _loop() {
        var log = observedLogs[index];
        var _log = _toArray(log),
          format = _log[0],
          args = _log.slice(1);
        var message = _util["default"].format.apply(_util["default"], [format].concat(_toConsumableArray(args)));

        // Ignore uncaught errors reported by jsdom
        // and React addendums because they're too noisy.
        // if (shouldIgnoreConsoleError(format, args)) {
        //   return;
        // }

        var expectedMessage;
        var expectedWithoutStack;
        var expectedMessageOrArray = expectedMessages[index];
        if (expectedMessageOrArray != null && Array.isArray(expectedMessageOrArray)) {
          // Should be in the local form assert([['log', {withoutStack: true}]])

          // Some validations for common mistakes.
          if (expectedMessageOrArray.length === 1) {
            throwFormattedError("Did you forget to remove the array around the log?" + "\n\nThe expected message for ".concat(matcherName, "() must be a string or an array of length 2, but there's only one item in the array. If this is intentional, remove the extra array."));
          } else if (expectedMessageOrArray.length !== 2) {
            throwFormattedError("The expected message for ".concat(matcherName, "() must be a string or an array of length 2. ") + "Instead received ".concat(expectedMessageOrArray, "."));
          } else if (consoleMethod === 'log') {
            // We don't expect any console.log calls to have a stack.
            throwFormattedError("Do not pass withoutStack to assertConsoleLogDev logs, console.log does not have component stacks.");
          }

          // Format is correct, check the values.
          var currentExpectedMessage = expectedMessageOrArray[0];
          var currentExpectedOptions = expectedMessageOrArray[1];
          if (typeof currentExpectedMessage !== 'string' || _typeof(currentExpectedOptions) !== 'object' || currentExpectedOptions.withoutStack !== true) {
            throwFormattedError("Log entries that are arrays must be of the form [string, {withoutStack: true}]" + "\n\nInstead received [".concat(_typeof(currentExpectedMessage), ", ").concat(JSON.stringify(currentExpectedOptions), "]."));
          }
          expectedMessage = normalizeCodeLocInfo(currentExpectedMessage);
          expectedWithoutStack = expectedMessageOrArray[1].withoutStack;
        } else if (typeof expectedMessageOrArray === 'string') {
          // Should be in the form assert(['log']) or assert(['log'], {withoutStack: true})
          expectedMessage = normalizeCodeLocInfo(expectedMessageOrArray);
          if (consoleMethod === 'log') {
            expectedWithoutStack = true;
          } else {
            expectedWithoutStack = withoutStack;
          }
        } else if (_typeof(expectedMessageOrArray) === 'object' && expectedMessageOrArray != null && expectedMessageOrArray.withoutStack != null) {
          // Special case for common case of a wrong withoutStack value.
          throwFormattedError("Did you forget to wrap a log with withoutStack in an array?" + "\n\nThe expected message for ".concat(matcherName, "() must be a string or an array of length 2.") + "\n\nInstead received ".concat(JSON.stringify(expectedMessageOrArray), "."));
        } else if (expectedMessageOrArray != null) {
          throwFormattedError("The expected message for ".concat(matcherName, "() must be a string or an array of length 2. ") + "Instead received ".concat(JSON.stringify(expectedMessageOrArray), "."));
        }
        var normalizedMessage = normalizeCodeLocInfo(message);
        receivedLogs.push(normalizedMessage);

        // Check the number of %s interpolations.
        // We'll fail the test if they mismatch.
        var argIndex = 0;
        // console.* could have been called with a non-string e.g. `console.error(new Error())`
        // eslint-disable-next-line react-internal/safe-string-coercion
        String(format).replace(/%s|%c/g, function () {
          return argIndex++;
        });
        if (argIndex !== args.length) {
          if (format.includes('%c%s')) {
            // We intentionally use mismatching formatting when printing badging because we don't know
            // the best default to use for different types because the default varies by platform.
          } else {
            logsMismatchingFormat.push({
              format: format,
              args: args,
              expectedArgCount: argIndex
            });
          }
        }

        // Check for extra component stacks
        if (args.length >= 2 && isLikelyAComponentStack(args[args.length - 1]) && isLikelyAComponentStack(args[args.length - 2])) {
          logsWithExtraComponentStack.push({
            format: format
          });
        }

        // Main logic to check if log is expected, with the component stack.
        if (normalizedMessage === expectedMessage || normalizedMessage.includes(expectedMessage)) {
          if (isLikelyAComponentStack(normalizedMessage)) {
            if (expectedWithoutStack === true) {
              unexpectedIncludingComponentStack.push(normalizedMessage);
            }
          } else if (expectedWithoutStack !== true) {
            unexpectedMissingComponentStack.push(normalizedMessage);
          }

          // Found expected log, remove it from missing.
          missingExpectedLogs.splice(0, 1);
        } else {
          unexpectedLogs.push(normalizedMessage);
        }
      };
      for (var index = 0; index < observedLogs.length; index++) {
        _loop();
      }
      if (unexpectedLogs.length > 0) {
        throwFormattedError("Unexpected ".concat(logName(), "(s) recorded.\n\n").concat(printDiff()));
      }

      // Any remaining messages indicate a failed expectations.
      if (missingExpectedLogs.length > 0) {
        throwFormattedError("Expected ".concat(logName(), " was not recorded.\n\n").concat(printDiff()));
      }

      // Any logs that include a component stack but shouldn't.
      if (unexpectedIncludingComponentStack.length > 0) {
        throwFormattedError("".concat(unexpectedIncludingComponentStack.map(function (stack) {
          return "Unexpected component stack for:\n  ".concat(printReceived(stack));
        }).join('\n\n'), "\n\nIf this ").concat(logName(), " should include a component stack, remove {withoutStack: true} from this ").concat(logName(), ".") + "\nIf all ".concat(logName(), "s should include the component stack, you may need to remove {withoutStack: true} from the ").concat(matcherName, " call."));
      }

      // Any logs that are missing a component stack without withoutStack.
      if (unexpectedMissingComponentStack.length > 0) {
        throwFormattedError("".concat(unexpectedMissingComponentStack.map(function (stack) {
          return "Missing component stack for:\n  ".concat(printReceived(stack));
        }).join('\n\n'), "\n\nIf this ").concat(logName(), " should omit a component stack, pass [log, {withoutStack: true}].") + "\nIf all ".concat(logName(), "s should omit the component stack, add {withoutStack: true} to the ").concat(matcherName, " call."));
      }

      // Wrong %s formatting is a failure.
      // This is a common mistake when creating new warnings.
      if (logsMismatchingFormat.length > 0) {
        throwFormattedError(logsMismatchingFormat.map(function (item) {
          return "Received ".concat(item.args.length, " arguments for a message with ").concat(item.expectedArgCount, " placeholders:\n  ").concat(printReceived(item.format));
        }).join('\n\n'));
      }

      // Duplicate component stacks is a failure.
      // This used to be a common mistake when creating new warnings,
      // but might not be an issue anymore.
      if (logsWithExtraComponentStack.length > 0) {
        throwFormattedError(logsWithExtraComponentStack.map(function (item) {
          return "Received more than one component stack for a warning:\n  ".concat(printReceived(item.format));
        }).join('\n\n'));
      }
    }
  };
}