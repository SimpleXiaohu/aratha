// copied from scripts/jest/matchers/toWarnDev.js
'use strict';

function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); }
var _require = require('jest-diff'),
  jestDiff = _require.diff;
var util = require('util');
function shouldIgnoreConsoleError(format, args) {
  if (__DEV__) {
    if (typeof format === 'string') {
      if (format.indexOf('The above error occurred') === 0) {
        // This looks like an error addendum from ReactFiberErrorLogger.
        // Ignore it too.
        return true;
      }
    }
  } else {
    if (format != null && typeof format.message === 'string' && typeof format.stack === 'string' && args.length === 0) {
      // In production, ReactFiberErrorLogger logs error objects directly.
      // They are noisy too so we'll try to ignore them.
      return true;
    }
  }
  // Looks legit
  return false;
}
function normalizeCodeLocInfo(str) {
  return str && str.replace(/at .+?:\d+/g, 'at **');
}
var createMatcherFor = function createMatcherFor(consoleMethod) {
  return function matcher(callback, expectedMessages) {
    var _this = this;
    var options = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};
    if (__DEV__) {
      // Warn about incorrect usage of matcher.
      if (typeof expectedMessages === 'string') {
        expectedMessages = [expectedMessages];
      } else if (!Array.isArray(expectedMessages)) {
        throw Error("toWarnDev() requires a parameter of type string or an array of strings " + "but was given ".concat(_typeof(expectedMessages), "."));
      }
      if (options != null && (_typeof(options) !== 'object' || Array.isArray(options))) {
        throw new Error('toWarnDev() second argument, when present, should be an object. ' + 'Did you forget to wrap the messages into an array?');
      }
      if (arguments.length > 3) {
        // `matcher` comes from Jest, so it's more than 2 in practice
        throw new Error('toWarnDev() received more than two arguments. ' + 'Did you forget to wrap the messages into an array?');
      }
      var withoutStack = options.withoutStack;
      var warningsWithoutComponentStack = [];
      var warningsWithComponentStack = [];
      var unexpectedWarnings = [];
      var lastWarningWithMismatchingFormat = null;
      var lastWarningWithExtraComponentStack = null;

      // Catch errors thrown by the callback,
      // But only rethrow them if all test expectations have been satisfied.
      // Otherwise an Error in the callback can mask a failed expectation,
      // and result in a test that passes when it shouldn't.
      var caughtError;
      var isLikelyAComponentStack = function isLikelyAComponentStack(message) {
        return typeof message === 'string' && message.includes('\n    in ');
      };
      var consoleSpy = function consoleSpy(format) {
        for (var _len = arguments.length, args = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
          args[_key - 1] = arguments[_key];
        }
        // Ignore uncaught errors reported by jsdom
        // and React addendums because they're too noisy.
        if (consoleMethod === 'error' && shouldIgnoreConsoleError(format, args)) {
          return;
        }
        var message = util.format.apply(util, [format].concat(args));
        var normalizedMessage = normalizeCodeLocInfo(message);

        // Remember if the number of %s interpolations
        // doesn't match the number of arguments.
        // We'll fail the test if it happens.
        var argIndex = 0;
        format.replace(/%s/g, function () {
          return argIndex++;
        });
        if (argIndex !== args.length) {
          lastWarningWithMismatchingFormat = {
            format: format,
            args: args,
            expectedArgCount: argIndex
          };
        }

        // Protect against accidentally passing a component stack
        // to warning() which already injects the component stack.
        if (args.length >= 2 && isLikelyAComponentStack(args[args.length - 1]) && isLikelyAComponentStack(args[args.length - 2])) {
          lastWarningWithExtraComponentStack = {
            format: format
          };
        }
        for (var index = 0; index < expectedMessages.length; index++) {
          var expectedMessage = expectedMessages[index];
          if (normalizedMessage === expectedMessage || normalizedMessage.includes(expectedMessage)) {
            if (isLikelyAComponentStack(normalizedMessage)) {
              warningsWithComponentStack.push(normalizedMessage);
            } else {
              warningsWithoutComponentStack.push(normalizedMessage);
            }
            expectedMessages.splice(index, 1);
            return;
          }
        }
        var errorMessage;
        if (expectedMessages.length === 0) {
          errorMessage = 'Unexpected warning recorded: ' + _this.utils.printReceived(normalizedMessage);
        } else if (expectedMessages.length === 1) {
          errorMessage = 'Unexpected warning recorded: ' + jestDiff(expectedMessages[0], normalizedMessage);
        } else {
          errorMessage = 'Unexpected warning recorded: ' + jestDiff(expectedMessages, [normalizedMessage]);
        }

        // Record the call stack for unexpected warnings.
        // We don't throw an Error here though,
        // Because it might be suppressed by ReactFiberScheduler.
        unexpectedWarnings.push(new Error(errorMessage));
      };

      // TODO Decide whether we need to support nested toWarn* expectations.
      // If we don't need it, add a check here to see if this is already our spy,
      // And throw an error.
      var originalMethod = console[consoleMethod];

      // Avoid using Jest's built-in spy since it can't be removed.
      console[consoleMethod] = consoleSpy;
      try {
        callback();
      } catch (error) {
        caughtError = error;
      } finally {
        // Restore the unspied method so that unexpected errors fail tests.
        console[consoleMethod] = originalMethod;

        // Any unexpected Errors thrown by the callback should fail the test.
        // This should take precedence since unexpected errors could block warnings.
        if (caughtError) {
          throw caughtError;
        }

        // Any unexpected warnings should be treated as a failure.
        if (unexpectedWarnings.length > 0) {
          return {
            message: function message() {
              return unexpectedWarnings[0].stack;
            },
            pass: false
          };
        }

        // Any remaining messages indicate a failed expectations.
        if (expectedMessages.length > 0) {
          return {
            message: function message() {
              return "Expected warning was not recorded:\n  ".concat(_this.utils.printReceived(expectedMessages[0]));
            },
            pass: false
          };
        }
        if (typeof withoutStack === 'number') {
          // We're expecting a particular number of warnings without stacks.
          if (withoutStack !== warningsWithoutComponentStack.length) {
            return {
              message: function message() {
                return "Expected ".concat(withoutStack, " warnings without a component stack but received ").concat(warningsWithoutComponentStack.length, ":\n") + warningsWithoutComponentStack.map(function (warning) {
                  return _this.utils.printReceived(warning);
                });
              },
              pass: false
            };
          }
        } else if (withoutStack === true) {
          // We're expecting that all warnings won't have the stack.
          // If some warnings have it, it's an error.
          if (warningsWithComponentStack.length > 0) {
            return {
              message: function message() {
                return "Received warning unexpectedly includes a component stack:\n  ".concat(_this.utils.printReceived(warningsWithComponentStack[0]), "\nIf this warning intentionally includes the component stack, remove ") + "{withoutStack: true} from the toWarnDev() call. If you have a mix of " + "warnings with and without stack in one toWarnDev() call, pass " + "{withoutStack: N} where N is the number of warnings without stacks.";
              },
              pass: false
            };
          }
        } else if (withoutStack === false || withoutStack === undefined) {
          // We're expecting that all warnings *do* have the stack (default).
          // If some warnings don't have it, it's an error.
          if (warningsWithoutComponentStack.length > 0) {
            return {
              message: function message() {
                return "Received warning unexpectedly does not include a component stack:\n  ".concat(_this.utils.printReceived(warningsWithoutComponentStack[0]), "\nIf this warning intentionally omits the component stack, add ") + "{withoutStack: true} to the toWarnDev() call.";
              },
              pass: false
            };
          }
        } else {
          throw Error("The second argument for toWarnDev(), when specified, must be an object. It may have a " + "property called \"withoutStack\" whose value may be undefined, boolean, or a number. " + "Instead received ".concat(_typeof(withoutStack), "."));
        }
        if (lastWarningWithMismatchingFormat !== null) {
          return {
            message: function message() {
              return "Received ".concat(lastWarningWithMismatchingFormat.args.length, " arguments for a message with ").concat(lastWarningWithMismatchingFormat.expectedArgCount, " placeholders:\n  ").concat(_this.utils.printReceived(lastWarningWithMismatchingFormat.format));
            },
            pass: false
          };
        }
        if (lastWarningWithExtraComponentStack !== null) {
          return {
            message: function message() {
              return "Received more than one component stack for a warning:\n  ".concat(_this.utils.printReceived(lastWarningWithExtraComponentStack.format), "\nDid you accidentally pass a stack to warning() as the last argument? ") + "Don't forget warning() already injects the component stack automatically.";
            },
            pass: false
          };
        }
        return {
          pass: true
        };
      }
    } else {
      // Any uncaught errors or warnings should fail tests in production mode.
      callback();
      return {
        pass: true
      };
    }
  };
};
module.exports = {
  toLowPriorityWarnDev: createMatcherFor('warn'),
  toWarnDev: createMatcherFor('error')
};