/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
"use strict";

module.exports = [{
  shortName: "dom-node",
  entryPoints: ["react-dom", "react-dom/client", "react-dom/profiling", "react-dom/unstable_testing", "react-dom/src/ReactDOMReactServer.js", "react-dom/src/server/react-dom-server.node.js", "react-dom/static.node", "react-dom/test-utils", "react-dom/unstable_server-external-runtime", "react-server-dom-webpack/server.node.unbundled", "react-server-dom-webpack/client.node.unbundled"],
  paths: ["react-dom", "react-dom/src/ReactDOMReactServer.js", "react-dom-bindings", "react-dom/client", "react-dom/profiling", "react-dom/server", "react-dom/server.node", "react-dom/static", "react-dom/static.node", "react-dom/test-utils", "react-dom/src/server/react-dom-server.node", "react-dom/src/server/ReactDOMFizzServerNode.js",
  // react-dom/server.node
  "react-dom/src/server/ReactDOMFizzStaticNode.js", "react-dom-bindings/src/server/ReactDOMFlightServerHostDispatcher.js", "react-dom-bindings/src/server/ReactFlightServerConfigDOM.js", "react-dom-bindings/src/shared/ReactFlightClientConfigDOM.js", "react-server-dom-webpack", "react-server-dom-webpack/client.node.unbundled", "react-server-dom-webpack/server", "react-server-dom-webpack/server.node.unbundled", "react-server-dom-webpack/src/ReactFlightDOMServerNode.js",
  // react-server-dom-webpack/server.node
  "react-server-dom-webpack/src/ReactFlightDOMClientNode.js",
  // react-server-dom-webpack/client.node
  "react-server-dom-webpack/src/ReactFlightClientConfigBundlerNode.js", "react-devtools", "react-devtools-core", "react-devtools-shell", "react-devtools-shared", "shared/ReactDOMSharedInternals", "react-server/src/ReactFlightServerConfigDebugNode.js"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "dom-node-webpack",
  entryPoints: ["react-server-dom-webpack/server.node", "react-server-dom-webpack/client.node"],
  paths: ["react-dom", "react-dom-bindings", "react-dom/client", "react-dom/profiling", "react-dom/server", "react-dom/server.node", "react-dom/static", "react-dom/static.node", "react-dom/src/server/react-dom-server.node", "react-dom/src/server/ReactDOMFizzServerNode.js",
  // react-dom/server.node
  "react-dom/src/server/ReactDOMFizzStaticNode.js", "react-dom-bindings/src/server/ReactDOMFlightServerHostDispatcher.js", "react-dom-bindings/src/server/ReactFlightServerConfigDOM.js", "react-dom-bindings/src/shared/ReactFlightClientConfigDOM.js", "react-server-dom-webpack", "react-server-dom-webpack/client.node", "react-server-dom-webpack/server", "react-server-dom-webpack/server.node", "react-server-dom-webpack/src/ReactFlightDOMServerNode.js",
  // react-server-dom-webpack/server.node
  "react-server-dom-webpack/src/ReactFlightClientConfigBundlerWebpack.js", "react-server-dom-webpack/src/ReactFlightClientConfigBundlerWebpackServer.js", "react-server-dom-webpack/node-register", "react-server-dom-webpack/src/ReactFlightWebpackNodeRegister.js", "react-devtools", "react-devtools-core", "react-devtools-shell", "react-devtools-shared", "shared/ReactDOMSharedInternals", "react-server/src/ReactFlightServerConfigDebugNode.js"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "dom-node-turbopack",
  entryPoints: ["react-server-dom-turbopack/server.node.unbundled", "react-server-dom-turbopack/client.node.unbundled"],
  paths: ["react-dom", "react-dom-bindings", "react-dom/client", "react-dom/profiling", "react-dom/server", "react-dom/server.node", "react-dom/static", "react-dom/static.node", "react-dom/src/server/react-dom-server.node", "react-dom/src/server/ReactDOMFizzServerNode.js",
  // react-dom/server.node
  "react-dom/src/server/ReactDOMFizzStaticNode.js", "react-dom-bindings/src/server/ReactDOMFlightServerHostDispatcher.js", "react-dom-bindings/src/server/ReactFlightServerConfigDOM.js", "react-dom-bindings/src/shared/ReactFlightClientConfigDOM.js", "react-server-dom-turbopack", "react-server-dom-turbopack/client.node.unbundled", "react-server-dom-turbopack/server", "react-server-dom-turbopack/server.node.unbundled", "react-server-dom-turbopack/src/ReactFlightDOMServerNode.js",
  // react-server-dom-turbopack/server.node.unbundled
  "react-server-dom-turbopack/src/ReactFlightDOMClientNode.js",
  // react-server-dom-turbopack/client.node.unbundled
  "react-server-dom-turbopack/src/ReactFlightClientConfigBundlerNode.js", "react-server-dom-turbopack/node-register", "react-server-dom-turbopack/src/ReactFlightTurbopackNodeRegister.js", "react-devtools", "react-devtools-core", "react-devtools-shell", "react-devtools-shared", "shared/ReactDOMSharedInternals", "react-server/src/ReactFlightServerConfigDebugNode.js"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "dom-node-turbopack-bundled",
  entryPoints: ["react-server-dom-turbopack/server.node", "react-server-dom-turbopack/client.node"],
  paths: ["react-dom", "react-dom-bindings", "react-dom/client", "react-dom/profiling", "react-dom/server", "react-dom/server.node", "react-dom/static", "react-dom/static.node", "react-dom/src/server/react-dom-server.node", "react-dom/src/server/ReactDOMFizzServerNode.js",
  // react-dom/server.node
  "react-dom/src/server/ReactDOMFizzStaticNode.js", "react-dom-bindings/src/server/ReactDOMFlightServerHostDispatcher.js", "react-dom-bindings/src/server/ReactFlightServerConfigDOM.js", "react-dom-bindings/src/shared/ReactFlightClientConfigDOM.js", "react-server-dom-turbopack", "react-server-dom-turbopack/client.node", "react-server-dom-turbopack/server", "react-server-dom-turbopack/server.node", "react-server-dom-turbopack/src/ReactFlightDOMServerNode.js",
  // react-server-dom-turbopack/server.node
  "react-server-dom-turbopack/src/ReactFlightDOMClientNode.js",
  // react-server-dom-turbopack/client.node
  "react-server-dom-turbopack/src/ReactFlightClientConfigBundlerTurbopack.js", "react-server-dom-turbopack/src/ReactFlightClientConfigBundlerTurbopackServer.js", "react-server-dom-turbopack/node-register", "react-server-dom-turbopack/src/ReactFlightTurbopackNodeRegister.js", "react-devtools", "react-devtools-core", "react-devtools-shell", "react-devtools-shared", "shared/ReactDOMSharedInternals", "react-server/src/ReactFlightServerConfigDebugNode.js"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "dom-bun",
  entryPoints: ["react-dom", "react-dom/client", "react-dom/profiling", "react-dom/unstable_testing", "react-dom/src/server/react-dom-server.bun.js"],
  paths: ["react-dom", "react-dom/client", "react-dom/profiling", "react-dom/server.bun", "react-dom/src/server/react-dom-server.bun", "react-dom/src/server/ReactDOMFizzServerBun.js", "react-dom-bindings", "react-dom-bindings/src/server/ReactDOMFlightServerHostDispatcher.js", "react-dom-bindings/src/server/ReactFlightServerConfigDOM.js", "react-dom-bindings/src/shared/ReactFlightClientConfigDOM.js", "shared/ReactDOMSharedInternals"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "dom-browser",
  entryPoints: ["react-dom", "react-dom/client", "react-dom/profiling", "react-dom/unstable_testing", "react-dom/src/server/react-dom-server.browser.js", "react-dom/static.browser", "react-dom/unstable_server-external-runtime", "react-server-dom-webpack/server.browser", "react-server-dom-webpack/client.browser"],
  paths: ["react-dom", "react-dom/src/ReactDOMReactServer.js", "react-dom-bindings", "react-dom/client", "react-dom/profiling", "react-dom/server.browser", "react-dom/static.browser", "react-dom/unstable_testing", "react-dom/src/server/react-dom-server.browser", "react-dom/src/server/ReactDOMFizzServerBrowser.js",
  // react-dom/server.browser
  "react-dom/src/server/ReactDOMFizzStaticBrowser.js", "react-dom-bindings/src/server/ReactDOMFlightServerHostDispatcher.js", "react-dom-bindings/src/server/ReactFlightServerConfigDOM.js", "react-dom-bindings/src/shared/ReactFlightClientConfigDOM.js", "react-server-dom-webpack", "react-server-dom-webpack/client", "react-server-dom-webpack/client.browser", "react-server-dom-webpack/server.browser", "react-server-dom-webpack/src/ReactFlightDOMClientBrowser.js",
  // react-server-dom-webpack/client.browser
  "react-server-dom-webpack/src/ReactFlightDOMServerBrowser.js",
  // react-server-dom-webpack/server.browser
  "react-server-dom-webpack/src/ReactFlightClientConfigBundlerWebpack.js", "react-server-dom-webpack/src/ReactFlightClientConfigBundlerWebpackBrowser.js", "react-devtools", "react-devtools-core", "react-devtools-shell", "react-devtools-shared", "shared/ReactDOMSharedInternals"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "dom-browser-esm",
  entryPoints: ["react-server-dom-esm/client.browser"],
  paths: ["react-dom", "react-dom/src/ReactDOMReactServer.js", "react-dom/client", "react-dom/profiling", "react-dom/server", "react-dom/server.node", "react-dom-bindings", "react-dom-bindings/src/server/ReactDOMFlightServerHostDispatcher.js", "react-dom-bindings/src/server/ReactFlightServerConfigDOM.js", "react-dom-bindings/src/shared/ReactFlightClientConfigDOM.js", "react-server-dom-esm", "react-server-dom-esm/client", "react-server-dom-esm/client.browser", "react-server-dom-esm/src/ReactFlightDOMClientBrowser.js",
  // react-server-dom-esm/client.browser
  "react-devtools", "react-devtools-core", "react-devtools-shell", "react-devtools-shared", "shared/ReactDOMSharedInternals"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "dom-browser-turbopack",
  entryPoints: ["react-server-dom-turbopack/client.browser", "react-server-dom-turbopack/server.browser"],
  paths: ["react-dom", "react-dom/client", "react-dom/profiling", "react-dom/server", "react-dom/server.node", "react-dom-bindings", "react-server-dom-turbopack", "react-server-dom-turbopack/client", "react-server-dom-turbopack/client.browser", "react-server-dom-turbopack/server.browser", "react-server-dom-turbopack/src/ReactFlightDOMClientBrowser.js",
  // react-server-dom-turbopack/client.browser
  "react-server-dom-turbopack/src/ReactFlightDOMServerBrowser.js",
  // react-server-dom-turbopack/server.browser
  "react-server-dom-turbopack/src/ReactFlightClientConfigBundlerTurbopack.js", "react-server-dom-turbopack/src/ReactFlightClientConfigBundlerTurbopackBrowser.js", "react-dom-bindings/src/server/ReactDOMFlightServerHostDispatcher.js", "react-dom-bindings/src/server/ReactFlightServerConfigDOM.js", "react-dom-bindings/src/shared/ReactFlightClientConfigDOM.js", "react-devtools", "react-devtools-core", "react-devtools-shell", "react-devtools-shared", "shared/ReactDOMSharedInternals"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "dom-edge-webpack",
  entryPoints: ["react-dom/src/server/react-dom-server.edge.js", "react-dom/static.edge", "react-server-dom-webpack/server.edge", "react-server-dom-webpack/client.edge"],
  paths: ["react-dom", "react-dom/src/ReactDOMReactServer.js", "react-dom-bindings", "react-dom/client", "react-dom/profiling", "react-dom/server.edge", "react-dom/static.edge", "react-dom/unstable_testing", "react-dom/src/server/react-dom-server.edge", "react-dom/src/server/ReactDOMFizzServerEdge.js",
  // react-dom/server.edge
  "react-dom/src/server/ReactDOMFizzStaticEdge.js", "react-dom-bindings/src/server/ReactDOMFlightServerHostDispatcher.js", "react-dom-bindings/src/server/ReactFlightServerConfigDOM.js", "react-dom-bindings/src/shared/ReactFlightClientConfigDOM.js", "react-server-dom-webpack", "react-server-dom-webpack/client.edge", "react-server-dom-webpack/server.edge", "react-server-dom-webpack/src/ReactFlightDOMClientEdge.js",
  // react-server-dom-webpack/client.edge
  "react-server-dom-webpack/src/ReactFlightDOMServerEdge.js",
  // react-server-dom-webpack/server.edge
  "react-server-dom-webpack/src/ReactFlightClientConfigBundlerWebpack.js", "react-server-dom-webpack/src/ReactFlightClientConfigBundlerWebpackServer.js", "react-devtools", "react-devtools-core", "react-devtools-shell", "react-devtools-shared", "shared/ReactDOMSharedInternals", "react-server/src/ReactFlightServerConfigDebugNode.js"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "dom-edge-turbopack",
  entryPoints: ["react-server-dom-turbopack/server.edge", "react-server-dom-turbopack/client.edge"],
  paths: ["react-dom", "react-dom/src/ReactDOMReactServer.js", "react-dom-bindings", "react-dom/client", "react-dom/profiling", "react-dom/server.edge", "react-dom/static.edge", "react-dom/unstable_testing", "react-dom/src/server/react-dom-server.edge", "react-dom/src/server/ReactDOMFizzServerEdge.js",
  // react-dom/server.edge
  "react-dom/src/server/ReactDOMFizzStaticEdge.js", "react-dom-bindings/src/server/ReactDOMFlightServerHostDispatcher.js", "react-dom-bindings/src/server/ReactFlightServerConfigDOM.js", "react-dom-bindings/src/shared/ReactFlightClientConfigDOM.js", "react-server-dom-turbopack", "react-server-dom-turbopack/client.edge", "react-server-dom-turbopack/server.edge", "react-server-dom-turbopack/src/ReactFlightDOMClientEdge.js",
  // react-server-dom-turbopack/client.edge
  "react-server-dom-turbopack/src/ReactFlightDOMServerEdge.js",
  // react-server-dom-turbopack/server.edge
  "react-server-dom-turbopack/src/ReactFlightClientConfigBundlerTurbopack.js", "react-server-dom-turbopack/src/ReactFlightClientConfigBundlerTurbopackServer.js", "react-devtools", "react-devtools-core", "react-devtools-shell", "react-devtools-shared", "shared/ReactDOMSharedInternals", "react-server/src/ReactFlightServerConfigDebugNode.js"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "dom-node-esm",
  entryPoints: ["react-server-dom-esm/server.node", "react-server-dom-esm/client.node"],
  paths: ["react-dom", "react-dom/src/ReactDOMReactServer.js", "react-dom-bindings", "react-dom/client", "react-dom/profiling", "react-dom/server", "react-dom/server.node", "react-dom/static", "react-dom/static.node", "react-dom/src/server/react-dom-server.node", "react-dom/src/server/ReactDOMFizzServerNode.js",
  // react-dom/server.node
  "react-dom/src/server/ReactDOMFizzStaticNode.js", "react-dom-bindings/src/server/ReactDOMFlightServerHostDispatcher.js", "react-dom-bindings/src/server/ReactFlightServerConfigDOM.js", "react-dom-bindings/src/shared/ReactFlightClientConfigDOM.js", "react-server-dom-esm", "react-server-dom-esm/client.node", "react-server-dom-esm/server", "react-server-dom-esm/server.node", "react-server-dom-esm/src/ReactFlightDOMServerNode.js",
  // react-server-dom-esm/server.node
  "react-server-dom-esm/src/ReactFlightDOMClientNode.js",
  // react-server-dom-esm/client.node
  "react-devtools", "react-devtools-core", "react-devtools-shell", "react-devtools-shared", "shared/ReactDOMSharedInternals", "react-server/src/ReactFlightServerConfigDebugNode.js"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "dom-legacy",
  entryPoints: ["react-dom/src/server/ReactDOMLegacyServerBrowser.js",
  // react-dom/server.browser
  "react-dom/src/server/ReactDOMLegacyServerNode.js" // react-dom/server.node
  ],
  paths: ["react-dom", "react-dom/src/ReactDOMReactServer.js", "react-dom-bindings", "react-dom/src/server/ReactDOMLegacyServerImpl.js",
  // not an entrypoint, but only usable in *Browser and *Node files
  "react-dom/src/server/ReactDOMLegacyServerBrowser.js",
  // react-dom/server.browser
  "react-dom/src/server/ReactDOMLegacyServerNode.js",
  // react-dom/server.node
  "shared/ReactDOMSharedInternals"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "markup",
  entryPoints: ["react-html/src/ReactHTMLClient.js",
  // react-html
  "react-html/src/ReactHTMLServer.js" // react-html/react-html.react-server
  ],
  paths: ["react-dom", "react-dom/src/ReactDOMReactServer.js", "react-dom-bindings", "react-html", "shared/ReactDOMSharedInternals"],
  isFlowTyped: true,
  isServerSupported: true
}, {
  shortName: "dom-fb",
  entryPoints: ["react-dom/src/ReactDOMFB.js", "react-dom/src/ReactDOMTestingFB.js", "react-server-dom-fb/src/ReactDOMServerFB.js"],
  paths: ["react-dom", "react-dom/src/ReactDOMFB.js", "react-dom/src/ReactDOMTestingFB.js", "react-dom/src/ReactDOMReactServer.js", "react-dom-bindings", "react-server-dom-fb", "shared/ReactDOMSharedInternals"],
  isFlowTyped: true,
  isServerSupported: true,
  isFlightSupported: false
}, {
  shortName: "native",
  entryPoints: ["react-native-renderer"],
  paths: ["react-native-renderer"],
  isFlowTyped: true,
  isServerSupported: false
}, {
  shortName: "fabric",
  entryPoints: ["react-native-renderer/fabric"],
  paths: ["react-native-renderer"],
  isFlowTyped: true,
  isServerSupported: false
}, {
  shortName: "test",
  entryPoints: ["react-test-renderer"],
  paths: ["react-test-renderer"],
  isFlowTyped: true,
  isServerSupported: false
}, {
  shortName: "art",
  entryPoints: ["react-art"],
  paths: ["react-art"],
  isFlowTyped: false,
  // TODO: type it.
  isServerSupported: false
}, {
  shortName: "custom",
  entryPoints: ["react-reconciler", "react-client/flight", "react-server", "react-server/flight"],
  paths: ["react-client/flight", "react-server/flight"],
  isFlowTyped: true,
  isServerSupported: true
}];