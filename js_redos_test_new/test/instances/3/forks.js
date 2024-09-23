'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.forks = exports["default"] = void 0;
var _nodeFs = require("node:fs");
var _bundles = require("./bundles.js");
var _inlinedHostConfigs = _interopRequireDefault(require("./inlinedHostConfigs.js"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
function _createForOfIteratorHelper(r, e) { var t = "undefined" != typeof Symbol && r[Symbol.iterator] || r["@@iterator"]; if (!t) { if (Array.isArray(r) || (t = _unsupportedIterableToArray(r)) || e && r && "number" == typeof r.length) { t && (r = t); var _n = 0, F = function F() {}; return { s: F, n: function n() { return _n >= r.length ? { done: !0 } : { done: !1, value: r[_n++] }; }, e: function e(r) { throw r; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var o, a = !0, u = !1; return { s: function s() { t = t.call(r); }, n: function n() { var r = t.next(); return a = r.done, r; }, e: function e(r) { u = !0, o = r; }, f: function f() { try { a || null == t["return"] || t["return"](); } finally { if (u) throw o; } } }; }
function _unsupportedIterableToArray(r, a) { if (r) { if ("string" == typeof r) return _arrayLikeToArray(r, a); var t = {}.toString.call(r).slice(8, -1); return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0; } }
function _arrayLikeToArray(r, a) { (null == a || a > r.length) && (a = r.length); for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e]; return n; }
var FB_WWW_DEV = _bundles.bundleTypes.FB_WWW_DEV,
  FB_WWW_PROD = _bundles.bundleTypes.FB_WWW_PROD,
  FB_WWW_PROFILING = _bundles.bundleTypes.FB_WWW_PROFILING,
  RN_OSS_DEV = _bundles.bundleTypes.RN_OSS_DEV,
  RN_OSS_PROD = _bundles.bundleTypes.RN_OSS_PROD,
  RN_OSS_PROFILING = _bundles.bundleTypes.RN_OSS_PROFILING,
  RN_FB_DEV = _bundles.bundleTypes.RN_FB_DEV,
  RN_FB_PROD = _bundles.bundleTypes.RN_FB_PROD,
  RN_FB_PROFILING = _bundles.bundleTypes.RN_FB_PROFILING;
var RENDERER = _bundles.moduleTypes.RENDERER,
  RECONCILER = _bundles.moduleTypes.RECONCILER;
var RELEASE_CHANNEL = process.env.RELEASE_CHANNEL;

// Default to building in experimental mode. If the release channel is set via
// an environment variable, then check if it's "experimental".
var __EXPERIMENTAL__ = typeof RELEASE_CHANNEL === 'string' ? RELEASE_CHANNEL === 'experimental' : true;
function findNearestExistingForkFile(path, segmentedIdentifier, suffix) {
  var segments = segmentedIdentifier.split('-');
  while (segments.length) {
    var candidate = segments.join('-');
    var forkPath = path + candidate + suffix;
    try {
      (0, _nodeFs.statSync)(forkPath);
      return forkPath;
    } catch (error) {
      // Try the next candidate.
    }
    segments.pop();
  }
  return null;
}

// If you need to replace a file with another file for a specific environment,
// add it to this list with the logic for choosing the right replacement.

// Fork paths are relative to the project root. They must include the full path,
// including the extension. We intentionally don't use Node's module resolution
// algorithm because 1) require.resolve doesn't work with ESM modules, and 2)
// the behavior is easier to predict.
var forks = exports.forks = Object.freeze({
  // Without this fork, importing `shared/ReactSharedInternals` inside
  // the `react` package itself would not work due to a cyclical dependency.
  './packages/shared/ReactSharedInternals.js': function _packages_shared_ReactSharedInternalsJs(bundleType, entry, dependencies, _moduleType, bundle) {
    if (entry === 'react') {
      return './packages/react/src/ReactSharedInternalsClient.js';
    }
    if (entry === 'react/src/ReactServer.js') {
      return './packages/react/src/ReactSharedInternalsServer.js';
    }
    if (entry === 'react-html/src/ReactHTMLServer.js') {
      // Inside the ReactHTMLServer render we don't refer to any shared internals
      // but instead use our own internal copy of the state because you cannot use
      // any of this state from a component anyway. E.g. you can't use a client hook.
      return './packages/react/src/ReactSharedInternalsClient.js';
    }
    if (bundle.condition === 'react-server') {
      return './packages/react-server/src/ReactSharedInternalsServer.js';
    }
    if (!entry.startsWith('react/') && dependencies.indexOf('react') === -1) {
      // React internals are unavailable if we can't reference the package.
      // We return an error because we only want to throw if this module gets used.
      return new Error('Cannot use a module that depends on ReactSharedInternals ' + 'from "' + entry + '" because it does not declare "react" in the package ' + 'dependencies or peerDependencies.');
    }
    return null;
  },
  // Without this fork, importing `shared/ReactDOMSharedInternals` inside
  // the `react-dom` package itself would not work due to a cyclical dependency.
  './packages/shared/ReactDOMSharedInternals.js': function _packages_shared_ReactDOMSharedInternalsJs(bundleType, entry, dependencies) {
    if (entry === 'react-dom' || entry === 'react-dom/src/ReactDOMFB.js' || entry === 'react-dom/src/ReactDOMTestingFB.js' || entry === 'react-dom/src/ReactDOMServer.js' || entry === 'react-html/src/ReactHTMLClient.js' || entry === 'react-html/src/ReactHTMLServer.js') {
      if (bundleType === FB_WWW_DEV || bundleType === FB_WWW_PROD || bundleType === FB_WWW_PROFILING) {
        return './packages/react-dom/src/ReactDOMSharedInternalsFB.js';
      } else {
        return './packages/react-dom/src/ReactDOMSharedInternals.js';
      }
    }
    if (!entry.startsWith('react-dom/') && dependencies.indexOf('react-dom') === -1) {
      // React DOM internals are unavailable if we can't reference the package.
      // We return an error because we only want to throw if this module gets used.
      return new Error('Cannot use a module that depends on ReactDOMSharedInternals ' + 'from "' + entry + '" because it does not declare "react-dom" in the package ' + 'dependencies or peerDependencies.');
    }
    return null;
  },
  // We have a few forks for different environments.
  './packages/shared/ReactFeatureFlags.js': function _packages_shared_ReactFeatureFlagsJs(bundleType, entry) {
    switch (entry) {
      case 'react-native-renderer':
        switch (bundleType) {
          case RN_FB_DEV:
          case RN_FB_PROD:
          case RN_FB_PROFILING:
            return './packages/shared/forks/ReactFeatureFlags.native-fb.js';
          case RN_OSS_DEV:
          case RN_OSS_PROD:
          case RN_OSS_PROFILING:
            return './packages/shared/forks/ReactFeatureFlags.native-oss.js';
          default:
            throw Error("Unexpected entry (".concat(entry, ") and bundleType (").concat(bundleType, ")"));
        }
      case 'react-native-renderer/fabric':
        switch (bundleType) {
          case RN_FB_DEV:
          case RN_FB_PROD:
          case RN_FB_PROFILING:
            return './packages/shared/forks/ReactFeatureFlags.native-fb.js';
          case RN_OSS_DEV:
          case RN_OSS_PROD:
          case RN_OSS_PROFILING:
            return './packages/shared/forks/ReactFeatureFlags.native-oss.js';
          default:
            throw Error("Unexpected entry (".concat(entry, ") and bundleType (").concat(bundleType, ")"));
        }
      case 'react-test-renderer':
        switch (bundleType) {
          case RN_FB_DEV:
          case RN_FB_PROD:
          case RN_FB_PROFILING:
            return './packages/shared/forks/ReactFeatureFlags.test-renderer.native-fb.js';
          case FB_WWW_DEV:
          case FB_WWW_PROD:
          case FB_WWW_PROFILING:
            return './packages/shared/forks/ReactFeatureFlags.test-renderer.www.js';
        }
        return './packages/shared/forks/ReactFeatureFlags.test-renderer.js';
      default:
        switch (bundleType) {
          case FB_WWW_DEV:
          case FB_WWW_PROD:
          case FB_WWW_PROFILING:
            return './packages/shared/forks/ReactFeatureFlags.www.js';
          case RN_FB_DEV:
          case RN_FB_PROD:
          case RN_FB_PROFILING:
            return './packages/shared/forks/ReactFeatureFlags.native-fb.js';
        }
    }
    return null;
  },
  './packages/scheduler/src/SchedulerFeatureFlags.js': function _packages_scheduler_src_SchedulerFeatureFlagsJs(bundleType, entry, dependencies) {
    if (bundleType === FB_WWW_DEV || bundleType === FB_WWW_PROD || bundleType === FB_WWW_PROFILING) {
      return './packages/scheduler/src/forks/SchedulerFeatureFlags.www.js';
    }
    return './packages/scheduler/src/SchedulerFeatureFlags.js';
  },
  './packages/shared/consoleWithStackDev.js': function _packages_shared_consoleWithStackDevJs(bundleType, entry) {
    switch (bundleType) {
      case FB_WWW_DEV:
        return './packages/shared/forks/consoleWithStackDev.www.js';
      case RN_OSS_DEV:
      case RN_FB_DEV:
        return './packages/shared/forks/consoleWithStackDev.rn.js';
      default:
        return null;
    }
  },
  './packages/react-reconciler/src/ReactFiberConfig.js': function _packages_reactReconciler_src_ReactFiberConfigJs(bundleType, entry, dependencies, moduleType) {
    if (dependencies.indexOf('react-reconciler') !== -1) {
      return null;
    }
    if (moduleType !== RENDERER && moduleType !== RECONCILER) {
      return null;
    }
    // eslint-disable-next-line no-for-of-loops/no-for-of-loops
    var _iterator = _createForOfIteratorHelper(_inlinedHostConfigs["default"]),
      _step;
    try {
      for (_iterator.s(); !(_step = _iterator.n()).done;) {
        var rendererInfo = _step.value;
        if (rendererInfo.entryPoints.indexOf(entry) !== -1) {
          var foundFork = findNearestExistingForkFile('./packages/react-reconciler/src/forks/ReactFiberConfig.', rendererInfo.shortName, '.js');
          if (foundFork) {
            return foundFork;
          }
          // fall through to error
          break;
        }
      }
    } catch (err) {
      _iterator.e(err);
    } finally {
      _iterator.f();
    }
    throw new Error('Expected ReactFiberConfig to always be replaced with a shim, but ' + "found no mention of \"".concat(entry, "\" entry point in ./scripts/shared/inlinedHostConfigs.js. ") + 'Did you mean to add it there to associate it with a specific renderer?');
  },
  './packages/react-server/src/ReactServerStreamConfig.js': function _packages_reactServer_src_ReactServerStreamConfigJs(bundleType, entry, dependencies, moduleType) {
    if (dependencies.indexOf('react-server') !== -1) {
      return null;
    }
    if (moduleType !== RENDERER && moduleType !== RECONCILER) {
      return null;
    }
    // eslint-disable-next-line no-for-of-loops/no-for-of-loops
    var _iterator2 = _createForOfIteratorHelper(_inlinedHostConfigs["default"]),
      _step2;
    try {
      for (_iterator2.s(); !(_step2 = _iterator2.n()).done;) {
        var rendererInfo = _step2.value;
        if (rendererInfo.entryPoints.indexOf(entry) !== -1) {
          if (!rendererInfo.isServerSupported) {
            return null;
          }
          var foundFork = findNearestExistingForkFile('./packages/react-server/src/forks/ReactServerStreamConfig.', rendererInfo.shortName, '.js');
          if (foundFork) {
            return foundFork;
          }
          // fall through to error
          break;
        }
      }
    } catch (err) {
      _iterator2.e(err);
    } finally {
      _iterator2.f();
    }
    throw new Error('Expected ReactServerStreamConfig to always be replaced with a shim, but ' + "found no mention of \"".concat(entry, "\" entry point in ./scripts/shared/inlinedHostConfigs.js. ") + 'Did you mean to add it there to associate it with a specific renderer?');
  },
  './packages/react-server/src/ReactFizzConfig.js': function _packages_reactServer_src_ReactFizzConfigJs(bundleType, entry, dependencies, moduleType) {
    if (dependencies.indexOf('react-server') !== -1) {
      return null;
    }
    if (moduleType !== RENDERER && moduleType !== RECONCILER) {
      return null;
    }
    // eslint-disable-next-line no-for-of-loops/no-for-of-loops
    var _iterator3 = _createForOfIteratorHelper(_inlinedHostConfigs["default"]),
      _step3;
    try {
      for (_iterator3.s(); !(_step3 = _iterator3.n()).done;) {
        var rendererInfo = _step3.value;
        if (rendererInfo.entryPoints.indexOf(entry) !== -1) {
          if (!rendererInfo.isServerSupported) {
            return null;
          }
          var foundFork = findNearestExistingForkFile('./packages/react-server/src/forks/ReactFizzConfig.', rendererInfo.shortName, '.js');
          if (foundFork) {
            return foundFork;
          }
          // fall through to error
          break;
        }
      }
    } catch (err) {
      _iterator3.e(err);
    } finally {
      _iterator3.f();
    }
    throw new Error('Expected ReactFizzConfig to always be replaced with a shim, but ' + "found no mention of \"".concat(entry, "\" entry point in ./scripts/shared/inlinedHostConfigs.js. ") + 'Did you mean to add it there to associate it with a specific renderer?');
  },
  './packages/react-server/src/ReactFlightServerConfig.js': function _packages_reactServer_src_ReactFlightServerConfigJs(bundleType, entry, dependencies, moduleType) {
    if (dependencies.indexOf('react-server') !== -1) {
      return null;
    }
    if (moduleType !== RENDERER && moduleType !== RECONCILER) {
      return null;
    }
    // eslint-disable-next-line no-for-of-loops/no-for-of-loops
    var _iterator4 = _createForOfIteratorHelper(_inlinedHostConfigs["default"]),
      _step4;
    try {
      for (_iterator4.s(); !(_step4 = _iterator4.n()).done;) {
        var rendererInfo = _step4.value;
        if (rendererInfo.entryPoints.indexOf(entry) !== -1) {
          if (!rendererInfo.isServerSupported) {
            return null;
          }
          if (rendererInfo.isFlightSupported === false) {
            return new Error("Expected not to use ReactFlightServerConfig with \"".concat(entry, "\" entry point ") + 'in ./scripts/shared/inlinedHostConfigs.js. Update the renderer config to ' + 'activate flight suppport and add a matching fork implementation for ReactFlightServerConfig.');
          }
          var foundFork = findNearestExistingForkFile('./packages/react-server/src/forks/ReactFlightServerConfig.', rendererInfo.shortName, '.js');
          if (foundFork) {
            return foundFork;
          }
          // fall through to error
          break;
        }
      }
    } catch (err) {
      _iterator4.e(err);
    } finally {
      _iterator4.f();
    }
    throw new Error('Expected ReactFlightServerConfig to always be replaced with a shim, but ' + "found no mention of \"".concat(entry, "\" entry point in ./scripts/shared/inlinedHostConfigs.js. ") + 'Did you mean to add it there to associate it with a specific renderer?');
  },
  './packages/react-client/src/ReactFlightClientConfig.js': function _packages_reactClient_src_ReactFlightClientConfigJs(bundleType, entry, dependencies, moduleType) {
    if (dependencies.indexOf('react-client') !== -1) {
      return null;
    }
    if (moduleType !== RENDERER && moduleType !== RECONCILER) {
      return null;
    }
    // eslint-disable-next-line no-for-of-loops/no-for-of-loops
    var _iterator5 = _createForOfIteratorHelper(_inlinedHostConfigs["default"]),
      _step5;
    try {
      for (_iterator5.s(); !(_step5 = _iterator5.n()).done;) {
        var rendererInfo = _step5.value;
        if (rendererInfo.entryPoints.indexOf(entry) !== -1) {
          if (!rendererInfo.isServerSupported) {
            return null;
          }
          if (rendererInfo.isFlightSupported === false) {
            return new Error("Expected not to use ReactFlightClientConfig with \"".concat(entry, "\" entry point ") + 'in ./scripts/shared/inlinedHostConfigs.js. Update the renderer config to ' + 'activate flight suppport and add a matching fork implementation for ReactFlightClientConfig.');
          }
          var foundFork = findNearestExistingForkFile('./packages/react-client/src/forks/ReactFlightClientConfig.', rendererInfo.shortName, '.js');
          if (foundFork) {
            return foundFork;
          }
          // fall through to error
          break;
        }
      }
    } catch (err) {
      _iterator5.e(err);
    } finally {
      _iterator5.f();
    }
    throw new Error('Expected ReactFlightClientConfig to always be replaced with a shim, but ' + "found no mention of \"".concat(entry, "\" entry point in ./scripts/shared/inlinedHostConfigs.js. ") + 'Did you mean to add it there to associate it with a specific renderer?');
  },
  // We wrap top-level listeners into guards on www.
  './packages/react-dom-bindings/src/events/EventListener.js': function _packages_reactDomBindings_src_events_EventListenerJs(bundleType, entry) {
    switch (bundleType) {
      case FB_WWW_DEV:
      case FB_WWW_PROD:
      case FB_WWW_PROFILING:
        if (__EXPERIMENTAL__) {
          // In modern builds we don't use the indirection. We just use raw DOM.
          return null;
        } else {
          // Use the www fork which is integrated with TimeSlice profiling.
          return './packages/react-dom-bindings/src/events/forks/EventListener-www.js';
        }
      default:
        return null;
    }
  },
  './packages/use-sync-external-store/src/useSyncExternalStore.js': function _packages_useSyncExternalStore_src_useSyncExternalStoreJs(bundleType, entry) {
    if (entry.startsWith('use-sync-external-store/shim')) {
      return './packages/use-sync-external-store/src/forks/useSyncExternalStore.forward-to-shim.js';
    }
    if (entry !== 'use-sync-external-store') {
      // Internal modules that aren't shims should use the native API from the
      // react package.
      return './packages/use-sync-external-store/src/forks/useSyncExternalStore.forward-to-built-in.js';
    }
    return null;
  },
  './packages/use-sync-external-store/src/isServerEnvironment.js': function _packages_useSyncExternalStore_src_isServerEnvironmentJs(bundleType, entry) {
    if (entry.endsWith('.native')) {
      return './packages/use-sync-external-store/src/forks/isServerEnvironment.native.js';
    }
  }
});
var _default = exports["default"] = forks;