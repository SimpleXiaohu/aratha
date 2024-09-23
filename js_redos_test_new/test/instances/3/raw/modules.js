'use strict';

function _toConsumableArray(r) { return _arrayWithoutHoles(r) || _iterableToArray(r) || _unsupportedIterableToArray(r) || _nonIterableSpread(); }
function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _unsupportedIterableToArray(r, a) { if (r) { if ("string" == typeof r) return _arrayLikeToArray(r, a); var t = {}.toString.call(r).slice(8, -1); return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0; } }
function _iterableToArray(r) { if ("undefined" != typeof Symbol && null != r[Symbol.iterator] || null != r["@@iterator"]) return Array.from(r); }
function _arrayWithoutHoles(r) { if (Array.isArray(r)) return _arrayLikeToArray(r); }
function _arrayLikeToArray(r, a) { (null == a || a > r.length) && (a = r.length); for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e]; return n; }
var forks = require('./forks');

// For any external that is used in a DEV-only condition, explicitly
// specify whether it has side effects during import or not. This lets
// us know whether we can safely omit them when they are unused.
var HAS_NO_SIDE_EFFECTS_ON_IMPORT = false;
// const HAS_SIDE_EFFECTS_ON_IMPORT = true;
var importSideEffects = Object.freeze({
  fs: HAS_NO_SIDE_EFFECTS_ON_IMPORT,
  'fs/promises': HAS_NO_SIDE_EFFECTS_ON_IMPORT,
  path: HAS_NO_SIDE_EFFECTS_ON_IMPORT,
  stream: HAS_NO_SIDE_EFFECTS_ON_IMPORT,
  'prop-types/checkPropTypes': HAS_NO_SIDE_EFFECTS_ON_IMPORT,
  'react-native/Libraries/ReactPrivate/ReactNativePrivateInterface': HAS_NO_SIDE_EFFECTS_ON_IMPORT,
  scheduler: HAS_NO_SIDE_EFFECTS_ON_IMPORT,
  react: HAS_NO_SIDE_EFFECTS_ON_IMPORT,
  'react-dom/server': HAS_NO_SIDE_EFFECTS_ON_IMPORT,
  'react/jsx-dev-runtime': HAS_NO_SIDE_EFFECTS_ON_IMPORT,
  'react-dom': HAS_NO_SIDE_EFFECTS_ON_IMPORT,
  url: HAS_NO_SIDE_EFFECTS_ON_IMPORT,
  ReactNativeInternalFeatureFlags: HAS_NO_SIDE_EFFECTS_ON_IMPORT
});

// Bundles exporting globals that other modules rely on.
var knownGlobals = Object.freeze({
  react: 'React',
  'react-dom': 'ReactDOM',
  'react-dom/server': 'ReactDOMServer',
  scheduler: 'Scheduler',
  'scheduler/unstable_mock': 'SchedulerMock',
  ReactNativeInternalFeatureFlags: 'ReactNativeInternalFeatureFlags'
});

// Given ['react'] in bundle externals, returns { 'react': 'React' }.
function getPeerGlobals(externals, bundleType) {
  var peerGlobals = {};
  externals.forEach(function (name) {
    peerGlobals[name] = knownGlobals[name];
  });
  return peerGlobals;
}

// Determines node_modules packages that are safe to assume will exist.
function getDependencies(bundleType, entry) {
  // Replaces any part of the entry that follow the package name (like
  // "/server" in "react-dom/server") by the path to the package settings
  var packageJson = require(entry.replace(/(\/.*)?$/, '/package.json'));
  // Both deps and peerDeps are assumed as accessible.
  return Array.from(new Set([].concat(_toConsumableArray(Object.keys(packageJson.dependencies || {})), _toConsumableArray(Object.keys(packageJson.peerDependencies || {})))));
}

// Hijacks some modules for optimization and integration reasons.
function getForks(bundleType, entry, moduleType, bundle) {
  var forksForBundle = {};
  Object.keys(forks).forEach(function (srcModule) {
    var dependencies = getDependencies(bundleType, entry);
    var targetModule = forks[srcModule](bundleType, entry, dependencies, moduleType, bundle);
    if (targetModule === null) {
      return;
    }
    forksForBundle[srcModule] = targetModule;
  });
  return forksForBundle;
}
function getImportSideEffects() {
  return importSideEffects;
}
module.exports = {
  getImportSideEffects: getImportSideEffects,
  getPeerGlobals: getPeerGlobals,
  getDependencies: getDependencies,
  getForks: getForks
};