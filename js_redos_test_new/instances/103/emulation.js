// import * as e from "../../core/common/common.js";
// import * as t from "../../core/host/host.js";
// import * as i from "../../core/i18n/i18n.js";
// import * as o from "../../core/sdk/sdk.js";
// import * as a from "../../ui/legacy/legacy.js";
// const n = {
//     laptopWithTouch: "Laptop with touch",
//     laptopWithHiDPIScreen: "Laptop with HiDPI screen",
//     laptopWithMDPIScreen: "Laptop with MDPI screen",
//   },
//   l = i.i18n.registerUIStrings("models/emulation/EmulatedDevices.ts", n),
//   r = i.i18n.getLazilyComputedLocalizedString.bind(void 0, l);
function h(e) {
  return e.replace(/@url\(([^\)]*?)\)/g, (e, t) =>
    new URL(`../../emulated_devices/${t}`, import.meta.url).toString()
  );
}
export {h};

// class s {
//   title;
//   type;
//   order;
//   vertical;
//   horizontal;
//   deviceScaleFactor;
//   capabilities;
//   userAgent;
//   userAgentMetadata;
//   modes;
//   isDualScreen;
//   isFoldableScreen;
//   verticalSpanned;
//   horizontalSpanned;
//   #e;
//   #t;
//   constructor() {
//     (this.title = ""),
//       (this.type = p.Unknown),
//       (this.vertical = {
//         width: 0,
//         height: 0,
//         outlineInsets: null,
//         outlineImage: null,
//         hinge: null,
//       }),
//       (this.horizontal = {
//         width: 0,
//         height: 0,
//         outlineInsets: null,
//         outlineImage: null,
//         hinge: null,
//       }),
//       (this.deviceScaleFactor = 1),
//       (this.capabilities = [m.Touch, m.Mobile]),
//       (this.userAgent = ""),
//       (this.userAgentMetadata = null),
//       (this.modes = []),
//       (this.isDualScreen = !1),
//       (this.isFoldableScreen = !1),
//       (this.verticalSpanned = {
//         width: 0,
//         height: 0,
//         outlineInsets: null,
//         outlineImage: null,
//         hinge: null,
//       }),
//       (this.horizontalSpanned = {
//         width: 0,
//         height: 0,
//         outlineInsets: null,
//         outlineImage: null,
//         hinge: null,
//       }),
//       (this.#e = b.Default),
//       (this.#t = !0);
//   }
//   static fromJSONV1(e) {
//     try {
//       function t(e, t, i, o) {
//         if ("object" != typeof e || null === e || !e.hasOwnProperty(t)) {
//           if (void 0 !== o) return o;
//           throw new Error(
//             "Emulated device is missing required property '" + t + "'"
//           );
//         }
//         const a = e[t];
//         if (typeof a !== i || null === a)
//           throw new Error(
//             "Emulated device property '" +
//               t +
//               "' has wrong type '" +
//               typeof a +
//               "'"
//           );
//         return a;
//       }
//       function i(e, i) {
//         const o = t(e, i, "number");
//         if (o !== Math.abs(o))
//           throw new Error("Emulated device value '" + i + "' must be integer");
//         return o;
//       }
//       function a(e) {
//         return new A(i(e, "left"), i(e, "top"), i(e, "right"), i(e, "bottom"));
//       }
//       function n(e) {
//         const o = {};
//         if (((o.r = i(e, "r")), o.r < 0 || o.r > 255))
//           throw new Error("color has wrong r value: " + o.r);
//         if (((o.g = i(e, "g")), o.g < 0 || o.g > 255))
//           throw new Error("color has wrong g value: " + o.g);
//         if (((o.b = i(e, "b")), o.b < 0 || o.b > 255))
//           throw new Error("color has wrong b value: " + o.b);
//         if (((o.a = t(e, "a", "number")), o.a < 0 || o.a > 1))
//           throw new Error("color has wrong a value: " + o.a);
//         return o;
//       }
//       function l(e) {
//         const t = {};
//         if (((t.width = i(e, "width")), t.width < 0 || t.width > L))
//           throw new Error("Emulated device has wrong hinge width: " + t.width);
//         if (((t.height = i(e, "height")), t.height < 0 || t.height > L))
//           throw new Error(
//             "Emulated device has wrong hinge height: " + t.height
//           );
//         if (((t.x = i(e, "x")), t.x < 0 || t.x > L))
//           throw new Error("Emulated device has wrong x offset: " + t.height);
//         if (((t.y = i(e, "y")), t.x < 0 || t.x > L))
//           throw new Error("Emulated device has wrong y offset: " + t.height);
//         return (
//           e.contentColor && (t.contentColor = n(e.contentColor)),
//           e.outlineColor && (t.outlineColor = n(e.outlineColor)),
//           t
//         );
//       }
//       function r(e) {
//         const o = {};
//         if (
//           ((o.width = i(e, "width")), o.width < 0 || o.width > L || o.width < T)
//         )
//           throw new Error("Emulated device has wrong width: " + o.width);
//         if (
//           ((o.height = i(e, "height")),
//           o.height < 0 || o.height > L || o.height < T)
//         )
//           throw new Error("Emulated device has wrong height: " + o.height);
//         const n = t(e.outline, "insets", "object", null);
//         if (n) {
//           if (
//             ((o.outlineInsets = a(n)),
//             o.outlineInsets.left < 0 || o.outlineInsets.top < 0)
//           )
//             throw new Error("Emulated device has wrong outline insets");
//           o.outlineImage = t(e.outline, "image", "string");
//         }
//         return e.hinge && (o.hinge = l(t(e, "hinge", "object", void 0))), o;
//       }
//       const h = new s();
//       (h.title = t(e, "title", "string")),
//         (h.type = t(e, "type", "string")),
//         (h.order = t(e, "order", "number", 0));
//       const p = t(e, "user-agent", "string");
//       (h.userAgent =
//         o.NetworkManager.MultitargetNetworkManager.patchUserAgentWithChromeVersion(
//           p
//         )),
//         (h.userAgentMetadata = t(e, "user-agent-metadata", "object", null));
//       const m = t(e, "capabilities", "object", []);
//       if (!Array.isArray(m))
//         throw new Error("Emulated device capabilities must be an array");
//       h.capabilities = [];
//       for (let v = 0; v < m.length; ++v) {
//         if ("string" != typeof m[v])
//           throw new Error("Emulated device capability must be a string");
//         h.capabilities.push(m[v]);
//       }
//       if (
//         ((h.deviceScaleFactor = t(e.screen, "device-pixel-ratio", "number")),
//         h.deviceScaleFactor < 0 || h.deviceScaleFactor > 100)
//       )
//         throw new Error(
//           "Emulated device has wrong deviceScaleFactor: " + h.deviceScaleFactor
//         );
//       if (
//         ((h.vertical = r(t(e.screen, "vertical", "object"))),
//         (h.horizontal = r(t(e.screen, "horizontal", "object"))),
//         (h.isDualScreen = t(e, "dual-screen", "boolean", !1)),
//         (h.isFoldableScreen = t(e, "foldable-screen", "boolean", !1)),
//         (h.isDualScreen || h.isFoldableScreen) &&
//           ((h.verticalSpanned = r(
//             t(e.screen, "vertical-spanned", "object", null)
//           )),
//           (h.horizontalSpanned = r(
//             t(e.screen, "horizontal-spanned", "object", null)
//           ))),
//         (h.isDualScreen || h.isFoldableScreen) &&
//           (!h.verticalSpanned || !h.horizontalSpanned))
//       )
//         throw new Error(
//           "Emulated device '" +
//             h.title +
//             "'has dual screen without spanned orientations"
//         );
//       const f = t(e, "modes", "object", [
//         { title: "default", orientation: "vertical" },
//         { title: "default", orientation: "horizontal" },
//       ]);
//       if (!Array.isArray(f))
//         throw new Error("Emulated device modes must be an array");
//       h.modes = [];
//       for (let w = 0; w < f.length; ++w) {
//         const S = {};
//         if (
//           ((S.title = t(f[w], "title", "string")),
//           (S.orientation = t(f[w], "orientation", "string")),
//           S.orientation !== c &&
//             S.orientation !== d &&
//             S.orientation !== g &&
//             S.orientation !== u)
//         )
//           throw new Error(
//             "Emulated device mode has wrong orientation '" + S.orientation + "'"
//           );
//         const M = h.orientationByName(S.orientation);
//         if (
//           ((S.insets = a(
//             t(f[w], "insets", "object", {
//               left: 0,
//               top: 0,
//               right: 0,
//               bottom: 0,
//             })
//           )),
//           S.insets.top < 0 ||
//             S.insets.left < 0 ||
//             S.insets.right < 0 ||
//             S.insets.bottom < 0 ||
//             S.insets.top + S.insets.bottom > M.height ||
//             S.insets.left + S.insets.right > M.width)
//         )
//           throw new Error(
//             "Emulated device mode '" + S.title + "'has wrong mode insets"
//           );
//         (S.image = t(f[w], "image", "string", null)), h.modes.push(S);
//       }
//       return (
//         (h.#t = t(e, "show-by-default", "boolean", void 0)),
//         (h.#e = t(e, "show", "string", b.Default)),
//         h
//       );
//     } catch (x) {
//       return null;
//     }
//   }
//   static deviceComparator(e, t) {
//     const i = e.order || 0,
//       o = t.order || 0;
//     return i > o
//       ? 1
//       : o > i || e.title < t.title
//       ? -1
//       : e.title > t.title
//       ? 1
//       : 0;
//   }
//   modesForOrientation(e) {
//     const t = [];
//     for (let i = 0; i < this.modes.length; i++)
//       this.modes[i].orientation === e && t.push(this.modes[i]);
//     return t;
//   }
//   getSpanPartner(e) {
//     switch (e.orientation) {
//       case c:
//         return this.modesForOrientation(g)[0];
//       case d:
//         return this.modesForOrientation(u)[0];
//       case g:
//         return this.modesForOrientation(c)[0];
//       default:
//         return this.modesForOrientation(d)[0];
//     }
//   }
//   getRotationPartner(e) {
//     switch (e.orientation) {
//       case u:
//         return this.modesForOrientation(g)[0];
//       case g:
//         return this.modesForOrientation(u)[0];
//       case d:
//         return this.modesForOrientation(c)[0];
//       default:
//         return this.modesForOrientation(d)[0];
//     }
//   }
//   toJSON() {
//     const e = {};
//     (e.title = this.title),
//       (e.type = this.type),
//       (e["user-agent"] = this.userAgent),
//       (e.capabilities = this.capabilities),
//       (e.screen = {
//         "device-pixel-ratio": this.deviceScaleFactor,
//         vertical: this.orientationToJSON(this.vertical),
//         horizontal: this.orientationToJSON(this.horizontal),
//         "vertical-spanned": void 0,
//         "horizontal-spanned": void 0,
//       }),
//       (this.isDualScreen || this.isFoldableScreen) &&
//         ((e.screen["vertical-spanned"] = this.orientationToJSON(
//           this.verticalSpanned
//         )),
//         (e.screen["horizontal-spanned"] = this.orientationToJSON(
//           this.horizontalSpanned
//         ))),
//       (e.modes = []);
//     for (let t = 0; t < this.modes.length; ++t) {
//       const i = {
//         title: this.modes[t].title,
//         orientation: this.modes[t].orientation,
//         insets: {
//           left: this.modes[t].insets.left,
//           top: this.modes[t].insets.top,
//           right: this.modes[t].insets.right,
//           bottom: this.modes[t].insets.bottom,
//         },
//         image: this.modes[t].image || void 0,
//       };
//       e.modes.push(i);
//     }
//     return (
//       (e["show-by-default"] = this.#t),
//       (e["dual-screen"] = this.isDualScreen),
//       (e["foldable-screen"] = this.isFoldableScreen),
//       (e.show = this.#e),
//       this.userAgentMetadata &&
//         (e["user-agent-metadata"] = this.userAgentMetadata),
//       e
//     );
//   }
//   orientationToJSON(e) {
//     const t = {};
//     return (
//       (t.width = e.width),
//       (t.height = e.height),
//       e.outlineInsets &&
//         (t.outline = {
//           insets: {
//             left: e.outlineInsets.left,
//             top: e.outlineInsets.top,
//             right: e.outlineInsets.right,
//             bottom: e.outlineInsets.bottom,
//           },
//           image: e.outlineImage,
//         }),
//       e.hinge &&
//         ((t.hinge = {
//           width: e.hinge.width,
//           height: e.hinge.height,
//           x: e.hinge.x,
//           y: e.hinge.y,
//           contentColor: void 0,
//           outlineColor: void 0,
//         }),
//         e.hinge.contentColor &&
//           (t.hinge.contentColor = {
//             r: e.hinge.contentColor.r,
//             g: e.hinge.contentColor.g,
//             b: e.hinge.contentColor.b,
//             a: e.hinge.contentColor.a,
//           }),
//         e.hinge.outlineColor &&
//           (t.hinge.outlineColor = {
//             r: e.hinge.outlineColor.r,
//             g: e.hinge.outlineColor.g,
//             b: e.hinge.outlineColor.b,
//             a: e.hinge.outlineColor.a,
//           })),
//       t
//     );
//   }
//   modeImage(e) {
//     return e.image ? h(e.image) : "";
//   }
//   outlineImage(e) {
//     const t = this.orientationByName(e.orientation);
//     return t.outlineImage ? h(t.outlineImage) : "";
//   }
//   orientationByName(e) {
//     switch (e) {
//       case g:
//         return this.verticalSpanned;
//       case u:
//         return this.horizontalSpanned;
//       case c:
//         return this.vertical;
//       default:
//         return this.horizontal;
//     }
//   }
//   show() {
//     return this.#e === b.Default ? this.#t : this.#e === b.Always;
//   }
//   setShow(e) {
//     this.#e = e ? b.Always : b.Never;
//   }
//   copyShowFrom(e) {
//     this.#e = e.#e;
//   }
//   touch() {
//     return -1 !== this.capabilities.indexOf(m.Touch);
//   }
//   mobile() {
//     return -1 !== this.capabilities.indexOf(m.Mobile);
//   }
// }
// const d = "horizontal",
//   c = "vertical",
//   u = "horizontal-spanned",
//   g = "vertical-spanned",
//   p = {
//     Phone: "phone",
//     Tablet: "tablet",
//     Notebook: "notebook",
//     Desktop: "desktop",
//     Unknown: "unknown",
//   },
//   m = { Touch: "touch", Mobile: "mobile" },
//   b = { Always: "Always", Default: "Default", Never: "Never" };
// let f;
// class v extends e.ObjectWrapper.ObjectWrapper {
//   #i;
//   #o;
//   #a;
//   #n;
//   constructor() {
//     super(),
//       (this.#i = e.Settings.Settings.instance().createSetting(
//         "standard-emulated-device-list",
//         []
//       )),
//       (this.#o = new Set()),
//       this.listFromJSONV1(this.#i.get(), this.#o),
//       this.updateStandardDevices(),
//       (this.#a = e.Settings.Settings.instance().createSetting(
//         "custom-emulated-device-list",
//         []
//       )),
//       (this.#n = new Set()),
//       this.listFromJSONV1(this.#a.get(), this.#n) || this.saveCustomDevices();
//   }
//   static instance() {
//     return f || (f = new v()), f;
//   }
//   updateStandardDevices() {
//     const e = new Set();
//     for (const t of w) {
//       const i = s.fromJSONV1(t);
//       i && e.add(i);
//     }
//     this.copyShowValues(this.#o, e), (this.#o = e), this.saveStandardDevices();
//   }
//   listFromJSONV1(e, t) {
//     if (!Array.isArray(e)) return !1;
//     let i = !0;
//     for (let o = 0; o < e.length; ++o) {
//       const a = s.fromJSONV1(e[o]);
//       a
//         ? (t.add(a),
//           a.modes.length ||
//             (a.modes.push({
//               title: "",
//               orientation: d,
//               insets: new A(0, 0, 0, 0),
//               image: null,
//             }),
//             a.modes.push({
//               title: "",
//               orientation: c,
//               insets: new A(0, 0, 0, 0),
//               image: null,
//             })))
//         : (i = !1);
//     }
//     return i;
//   }
//   standard() {
//     return [...this.#o];
//   }
//   custom() {
//     return [...this.#n];
//   }
//   revealCustomSetting() {
//     e.Revealer.reveal(this.#a);
//   }
//   addCustomDevice(e) {
//     this.#n.add(e), this.saveCustomDevices();
//   }
//   removeCustomDevice(e) {
//     this.#n.delete(e), this.saveCustomDevices();
//   }
//   saveCustomDevices() {
//     const e = [];
//     this.#n.forEach((t) => e.push(t.toJSON())),
//       this.#a.set(e),
//       this.dispatchEventToListeners("CustomDevicesUpdated");
//   }
//   saveStandardDevices() {
//     const e = [];
//     this.#o.forEach((t) => e.push(t.toJSON())),
//       this.#i.set(e),
//       this.dispatchEventToListeners("StandardDevicesUpdated");
//   }
//   copyShowValues(e, t) {
//     const i = new Map();
//     for (const t of e) i.set(t.title, t);
//     for (const e of t) {
//       const t = i.get(e.title);
//       t && e.copyShowFrom(t);
//     }
//   }
// }
// const w = [
//   {
//     order: 10,
//     "show-by-default": !0,
//     title: "iPhone SE",
//     screen: {
//       horizontal: { width: 667, height: 375 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 375, height: 667 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
//     type: "phone",
//   },
//   {
//     order: 12,
//     "show-by-default": !0,
//     title: "iPhone XR",
//     screen: {
//       horizontal: { width: 896, height: 414 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 414, height: 896 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
//     type: "phone",
//   },
//   {
//     order: 14,
//     "show-by-default": !0,
//     title: "iPhone 12 Pro",
//     screen: {
//       horizontal: { width: 844, height: 390 },
//       "device-pixel-ratio": 3,
//       vertical: { width: 390, height: 844 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
//     type: "phone",
//   },
//   {
//     order: 15,
//     "show-by-default": !0,
//     title: "iPhone 14 Pro Max",
//     screen: {
//       horizontal: { width: 932, height: 430 },
//       "device-pixel-ratio": 3,
//       vertical: { width: 430, height: 932 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
//     type: "phone",
//   },
//   {
//     order: 16,
//     "show-by-default": !1,
//     title: "Pixel 3 XL",
//     screen: {
//       horizontal: { width: 786, height: 393 },
//       "device-pixel-ratio": 2.75,
//       vertical: { width: 393, height: 786 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 11; Pixel 3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.181 Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "11",
//       architecture: "",
//       model: "Pixel 3",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     order: 18,
//     "show-by-default": !0,
//     title: "Pixel 7",
//     screen: {
//       horizontal: { width: 915, height: 412 },
//       "device-pixel-ratio": 2.625,
//       vertical: { width: 412, height: 915 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "13",
//       architecture: "",
//       model: "Pixel 5",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     order: 20,
//     "show-by-default": !0,
//     title: "Samsung Galaxy S8+",
//     screen: {
//       horizontal: { width: 740, height: 360 },
//       "device-pixel-ratio": 4,
//       vertical: { width: 360, height: 740 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 8.0.0; SM-G955U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "8.0.0",
//       architecture: "",
//       model: "SM-G955U",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     order: 24,
//     "show-by-default": !0,
//     title: "Samsung Galaxy S20 Ultra",
//     screen: {
//       horizontal: { width: 915, height: 412 },
//       "device-pixel-ratio": 3.5,
//       vertical: { width: 412, height: 915 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 13; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "13",
//       architecture: "",
//       model: "SM-G981B",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     order: 26,
//     "show-by-default": !0,
//     title: "iPad Mini",
//     screen: {
//       horizontal: { width: 1024, height: 768 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 768, height: 1024 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (iPad; CPU OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
//     type: "tablet",
//   },
//   {
//     order: 28,
//     "show-by-default": !0,
//     title: "iPad Air",
//     screen: {
//       horizontal: { width: 1180, height: 820 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 820, height: 1180 },
//     },
//     capabilities: ["touch"],
//     "user-agent":
//       "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Safari/605.1.15",
//     type: "tablet",
//   },
//   {
//     order: 29,
//     "show-by-default": !0,
//     title: "iPad Pro",
//     screen: {
//       horizontal: { width: 1366, height: 1024 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 1024, height: 1366 },
//     },
//     capabilities: ["touch"],
//     "user-agent":
//       "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Safari/605.1.15",
//     type: "tablet",
//   },
//   {
//     order: 30,
//     "show-by-default": !0,
//     title: "Surface Pro 7",
//     screen: {
//       horizontal: { width: 1368, height: 912 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 912, height: 1368 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
//     type: "tablet",
//   },
//   {
//     order: 32,
//     "show-by-default": !0,
//     "dual-screen": !0,
//     title: "Surface Duo",
//     screen: {
//       horizontal: { width: 720, height: 540 },
//       "device-pixel-ratio": 2.5,
//       vertical: { width: 540, height: 720 },
//       "vertical-spanned": {
//         width: 1114,
//         height: 720,
//         hinge: {
//           width: 34,
//           height: 720,
//           x: 540,
//           y: 0,
//           contentColor: { r: 38, g: 38, b: 38, a: 1 },
//         },
//       },
//       "horizontal-spanned": {
//         width: 720,
//         height: 1114,
//         hinge: {
//           width: 720,
//           height: 34,
//           x: 0,
//           y: 540,
//           contentColor: { r: 38, g: 38, b: 38, a: 1 },
//         },
//       },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 11.0; Surface Duo) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "11.0",
//       architecture: "",
//       model: "Surface Duo",
//       mobile: !0,
//     },
//     type: "phone",
//     modes: [
//       {
//         title: "default",
//         orientation: "vertical",
//         insets: { left: 0, top: 0, right: 0, bottom: 0 },
//       },
//       {
//         title: "default",
//         orientation: "horizontal",
//         insets: { left: 0, top: 0, right: 0, bottom: 0 },
//       },
//       {
//         title: "spanned",
//         orientation: "vertical-spanned",
//         insets: { left: 0, top: 0, right: 0, bottom: 0 },
//       },
//       {
//         title: "spanned",
//         orientation: "horizontal-spanned",
//         insets: { left: 0, top: 0, right: 0, bottom: 0 },
//       },
//     ],
//   },
//   {
//     order: 34,
//     "show-by-default": !0,
//     "foldable-screen": !0,
//     title: "Galaxy Fold",
//     screen: {
//       horizontal: { width: 653, height: 280 },
//       "device-pixel-ratio": 3,
//       vertical: { width: 280, height: 653 },
//       "vertical-spanned": { width: 717, height: 512 },
//       "horizontal-spanned": { width: 512, height: 717 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 9.0; SAMSUNG SM-F900U Build/PPR1.180610.011) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "9.0",
//       architecture: "",
//       model: "SM-F900U",
//       mobile: !0,
//     },
//     type: "phone",
//     modes: [
//       {
//         title: "default",
//         orientation: "vertical",
//         insets: { left: 0, top: 0, right: 0, bottom: 0 },
//       },
//       {
//         title: "default",
//         orientation: "horizontal",
//         insets: { left: 0, top: 0, right: 0, bottom: 0 },
//       },
//       {
//         title: "spanned",
//         orientation: "vertical-spanned",
//         insets: { left: 0, top: 0, right: 0, bottom: 0 },
//       },
//       {
//         title: "spanned",
//         orientation: "horizontal-spanned",
//         insets: { left: 0, top: 0, right: 0, bottom: 0 },
//       },
//     ],
//   },
//   {
//     order: 35,
//     "show-by-default": !0,
//     "foldable-screen": !0,
//     title: "Asus Zenbook Fold",
//     screen: {
//       horizontal: { width: 1280, height: 853 },
//       "device-pixel-ratio": 1.5,
//       vertical: { width: 853, height: 1280 },
//       "vertical-spanned": {
//         width: 1706,
//         height: 1280,
//         hinge: {
//           width: 107,
//           height: 1280,
//           x: 800,
//           y: 0,
//           contentColor: { r: 38, g: 38, b: 38, a: 0.2 },
//           outlineColor: { r: 38, g: 38, b: 38, a: 0.7 },
//         },
//       },
//       "horizontal-spanned": {
//         width: 1280,
//         height: 1706,
//         hinge: {
//           width: 1706,
//           height: 107,
//           x: 0,
//           y: 800,
//           contentColor: { r: 38, g: 38, b: 38, a: 0.2 },
//           outlineColor: { r: 38, g: 38, b: 38, a: 0.7 },
//         },
//       },
//     },
//     capabilities: ["touch"],
//     "user-agent":
//       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Windows",
//       platformVersion: "11.0",
//       architecture: "",
//       model: "UX9702AA",
//       mobile: !1,
//     },
//     type: "tablet",
//     modes: [
//       {
//         title: "default",
//         orientation: "vertical",
//         insets: { left: 0, top: 0, right: 0, bottom: 0 },
//       },
//       {
//         title: "default",
//         orientation: "horizontal",
//         insets: { left: 0, top: 0, right: 0, bottom: 0 },
//       },
//       {
//         title: "spanned",
//         orientation: "vertical-spanned",
//         insets: { left: 0, top: 0, right: 0, bottom: 0 },
//       },
//       {
//         title: "spanned",
//         orientation: "horizontal-spanned",
//         insets: { left: 0, top: 0, right: 0, bottom: 0 },
//       },
//     ],
//   },
//   {
//     order: 36,
//     "show-by-default": !0,
//     title: "Samsung Galaxy A51/71",
//     screen: {
//       horizontal: { width: 914, height: 412 },
//       "device-pixel-ratio": 2.625,
//       vertical: { width: 412, height: 914 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 8.0.0; SM-G955U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "8.0.0",
//       architecture: "",
//       model: "SM-G955U",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     order: 52,
//     "show-by-default": !0,
//     title: "Nest Hub Max",
//     screen: {
//       horizontal: {
//         outline: {
//           image: "@url(optimized/google-nest-hub-max-horizontal.avif)",
//           insets: { left: 92, top: 96, right: 91, bottom: 248 },
//         },
//         width: 1280,
//         height: 800,
//       },
//       "device-pixel-ratio": 2,
//       vertical: { width: 1280, height: 800 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (X11; Linux aarch64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.188 Safari/537.36 CrKey/1.54.250320",
//     type: "tablet",
//     modes: [{ title: "default", orientation: "horizontal" }],
//   },
//   {
//     order: 50,
//     "show-by-default": !0,
//     title: "Nest Hub",
//     screen: {
//       horizontal: {
//         outline: {
//           image: "@url(optimized/google-nest-hub-horizontal.avif)",
//           insets: { left: 82, top: 74, right: 83, bottom: 222 },
//         },
//         width: 1024,
//         height: 600,
//       },
//       "device-pixel-ratio": 2,
//       vertical: { width: 1024, height: 600 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.109 Safari/537.36 CrKey/1.54.248666",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "",
//       architecture: "",
//       model: "",
//       mobile: !1,
//     },
//     type: "tablet",
//     modes: [{ title: "default", orientation: "horizontal" }],
//   },
//   {
//     order: 129,
//     "show-by-default": !1,
//     title: "iPhone 4",
//     screen: {
//       horizontal: { width: 480, height: 320 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 320, height: 480 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (iPhone; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53",
//     type: "phone",
//   },
//   {
//     order: 130,
//     "show-by-default": !1,
//     title: "iPhone 5/SE",
//     screen: {
//       horizontal: {
//         outline: {
//           image: "@url(optimized/iPhone5-landscape.avif)",
//           insets: { left: 115, top: 25, right: 115, bottom: 28 },
//         },
//         width: 568,
//         height: 320,
//       },
//       "device-pixel-ratio": 2,
//       vertical: {
//         outline: {
//           image: "@url(optimized/iPhone5-portrait.avif)",
//           insets: { left: 29, top: 105, right: 25, bottom: 111 },
//         },
//         width: 320,
//         height: 568,
//       },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1",
//     type: "phone",
//   },
//   {
//     order: 131,
//     "show-by-default": !1,
//     title: "iPhone 6/7/8",
//     screen: {
//       horizontal: {
//         outline: {
//           image: "@url(optimized/iPhone6-landscape.avif)",
//           insets: { left: 106, top: 28, right: 106, bottom: 28 },
//         },
//         width: 667,
//         height: 375,
//       },
//       "device-pixel-ratio": 2,
//       vertical: {
//         outline: {
//           image: "@url(optimized/iPhone6-portrait.avif)",
//           insets: { left: 28, top: 105, right: 28, bottom: 105 },
//         },
//         width: 375,
//         height: 667,
//       },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
//     type: "phone",
//   },
//   {
//     order: 132,
//     "show-by-default": !1,
//     title: "iPhone 6/7/8 Plus",
//     screen: {
//       horizontal: {
//         outline: {
//           image: "@url(optimized/iPhone6Plus-landscape.avif)",
//           insets: { left: 109, top: 29, right: 109, bottom: 27 },
//         },
//         width: 736,
//         height: 414,
//       },
//       "device-pixel-ratio": 3,
//       vertical: {
//         outline: {
//           image: "@url(optimized/iPhone6Plus-portrait.avif)",
//           insets: { left: 26, top: 107, right: 30, bottom: 111 },
//         },
//         width: 414,
//         height: 736,
//       },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
//     type: "phone",
//   },
//   {
//     order: 133,
//     "show-by-default": !1,
//     title: "iPhone X",
//     screen: {
//       horizontal: { width: 812, height: 375 },
//       "device-pixel-ratio": 3,
//       vertical: { width: 375, height: 812 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "BlackBerry Z30",
//     screen: {
//       horizontal: { width: 640, height: 360 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 360, height: 640 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (BB10; Touch) AppleWebKit/537.10+ (KHTML, like Gecko) Version/10.0.9.2372 Mobile Safari/537.10+",
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Nexus 4",
//     screen: {
//       horizontal: { width: 640, height: 384 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 384, height: 640 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "4.4.2",
//       architecture: "",
//       model: "Nexus 4",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     title: "Nexus 5",
//     type: "phone",
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "6.0",
//       architecture: "",
//       model: "Nexus 5",
//       mobile: !0,
//     },
//     capabilities: ["touch", "mobile"],
//     "show-by-default": !1,
//     screen: {
//       "device-pixel-ratio": 3,
//       vertical: { width: 360, height: 640 },
//       horizontal: { width: 640, height: 360 },
//     },
//     modes: [
//       {
//         title: "default",
//         orientation: "vertical",
//         insets: { left: 0, top: 25, right: 0, bottom: 48 },
//         image:
//           "@url(optimized/google-nexus-5-vertical-default-1x.avif) 1x, @url(optimized/google-nexus-5-vertical-default-2x.avif) 2x",
//       },
//       {
//         title: "navigation bar",
//         orientation: "vertical",
//         insets: { left: 0, top: 80, right: 0, bottom: 48 },
//         image:
//           "@url(optimized/google-nexus-5-vertical-navigation-1x.avif) 1x, @url(optimized/google-nexus-5-vertical-navigation-2x.avif) 2x",
//       },
//       {
//         title: "keyboard",
//         orientation: "vertical",
//         insets: { left: 0, top: 80, right: 0, bottom: 312 },
//         image:
//           "@url(optimized/google-nexus-5-vertical-keyboard-1x.avif) 1x, @url(optimized/google-nexus-5-vertical-keyboard-2x.avif) 2x",
//       },
//       {
//         title: "default",
//         orientation: "horizontal",
//         insets: { left: 0, top: 25, right: 42, bottom: 0 },
//         image:
//           "@url(optimized/google-nexus-5-horizontal-default-1x.avif) 1x, @url(optimized/google-nexus-5-horizontal-default-2x.avif) 2x",
//       },
//       {
//         title: "navigation bar",
//         orientation: "horizontal",
//         insets: { left: 0, top: 80, right: 42, bottom: 0 },
//         image:
//           "@url(optimized/google-nexus-5-horizontal-navigation-1x.avif) 1x, @url(optimized/google-nexus-5-horizontal-navigation-2x.avif) 2x",
//       },
//       {
//         title: "keyboard",
//         orientation: "horizontal",
//         insets: { left: 0, top: 80, right: 42, bottom: 202 },
//         image:
//           "@url(optimized/google-nexus-5-horizontal-keyboard-1x.avif) 1x, @url(optimized/google-nexus-5-horizontal-keyboard-2x.avif) 2x",
//       },
//     ],
//   },
//   {
//     title: "Nexus 5X",
//     type: "phone",
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 8.0.0; Nexus 5X Build/OPR4.170623.006) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "8.0.0",
//       architecture: "",
//       model: "Nexus 5X",
//       mobile: !0,
//     },
//     capabilities: ["touch", "mobile"],
//     "show-by-default": !1,
//     screen: {
//       "device-pixel-ratio": 2.625,
//       vertical: {
//         outline: {
//           image: "@url(optimized/Nexus5X-portrait.avif)",
//           insets: { left: 18, top: 88, right: 22, bottom: 98 },
//         },
//         width: 412,
//         height: 732,
//       },
//       horizontal: {
//         outline: {
//           image: "@url(optimized/Nexus5X-landscape.avif)",
//           insets: { left: 88, top: 21, right: 98, bottom: 19 },
//         },
//         width: 732,
//         height: 412,
//       },
//     },
//     modes: [
//       {
//         title: "default",
//         orientation: "vertical",
//         insets: { left: 0, top: 24, right: 0, bottom: 48 },
//         image:
//           "@url(optimized/google-nexus-5x-vertical-default-1x.avif) 1x, @url(optimized/google-nexus-5x-vertical-default-2x.avif) 2x",
//       },
//       {
//         title: "navigation bar",
//         orientation: "vertical",
//         insets: { left: 0, top: 80, right: 0, bottom: 48 },
//         image:
//           "@url(optimized/google-nexus-5x-vertical-navigation-1x.avif) 1x, @url(optimized/google-nexus-5x-vertical-navigation-2x.avif) 2x",
//       },
//       {
//         title: "keyboard",
//         orientation: "vertical",
//         insets: { left: 0, top: 80, right: 0, bottom: 342 },
//         image:
//           "@url(optimized/google-nexus-5x-vertical-keyboard-1x.avif) 1x, @url(optimized/google-nexus-5x-vertical-keyboard-2x.avif) 2x",
//       },
//       {
//         title: "default",
//         orientation: "horizontal",
//         insets: { left: 0, top: 24, right: 48, bottom: 0 },
//         image:
//           "@url(optimized/google-nexus-5x-horizontal-default-1x.avif) 1x, @url(optimized/google-nexus-5x-horizontal-default-2x.avif) 2x",
//       },
//       {
//         title: "navigation bar",
//         orientation: "horizontal",
//         insets: { left: 0, top: 80, right: 48, bottom: 0 },
//         image:
//           "@url(optimized/google-nexus-5x-horizontal-navigation-1x.avif) 1x, @url(optimized/google-nexus-5x-horizontal-navigation-2x.avif) 2x",
//       },
//       {
//         title: "keyboard",
//         orientation: "horizontal",
//         insets: { left: 0, top: 80, right: 48, bottom: 222 },
//         image:
//           "@url(optimized/google-nexus-5x-horizontal-keyboard-1x.avif) 1x, @url(optimized/google-nexus-5x-horizontal-keyboard-2x.avif) 2x",
//       },
//     ],
//   },
//   {
//     "show-by-default": !1,
//     title: "Nexus 6",
//     screen: {
//       horizontal: { width: 732, height: 412 },
//       "device-pixel-ratio": 3.5,
//       vertical: { width: 412, height: 732 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 7.1.1; Nexus 6 Build/N6F26U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "7.1.1",
//       architecture: "",
//       model: "Nexus 6",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Nexus 6P",
//     screen: {
//       horizontal: {
//         outline: {
//           image: "@url(optimized/Nexus6P-landscape.avif)",
//           insets: { left: 94, top: 17, right: 88, bottom: 17 },
//         },
//         width: 732,
//         height: 412,
//       },
//       "device-pixel-ratio": 3.5,
//       vertical: {
//         outline: {
//           image: "@url(optimized/Nexus6P-portrait.avif)",
//           insets: { left: 16, top: 94, right: 16, bottom: 88 },
//         },
//         width: 412,
//         height: 732,
//       },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 8.0.0; Nexus 6P Build/OPP3.170518.006) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "8.0.0",
//       architecture: "",
//       model: "Nexus 6P",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     order: 120,
//     "show-by-default": !1,
//     title: "Pixel 2",
//     screen: {
//       horizontal: { width: 731, height: 411 },
//       "device-pixel-ratio": 2.625,
//       vertical: { width: 411, height: 731 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 8.0; Pixel 2 Build/OPD3.170816.012) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "8.0",
//       architecture: "",
//       model: "Pixel 2",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     order: 121,
//     "show-by-default": !1,
//     title: "Pixel 2 XL",
//     screen: {
//       horizontal: { width: 823, height: 411 },
//       "device-pixel-ratio": 3.5,
//       vertical: { width: 411, height: 823 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 8.0.0; Pixel 2 XL Build/OPD1.170816.004) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "8.0.0",
//       architecture: "",
//       model: "Pixel 2 XL",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Pixel 3",
//     screen: {
//       horizontal: { width: 786, height: 393 },
//       "device-pixel-ratio": 2.75,
//       vertical: { width: 393, height: 786 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 9; Pixel 3 Build/PQ1A.181105.017.A1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.158 Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "9",
//       architecture: "",
//       model: "Pixel 3",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Pixel 4",
//     screen: {
//       horizontal: { width: 745, height: 353 },
//       "device-pixel-ratio": 3,
//       vertical: { width: 353, height: 745 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 10; Pixel 4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "10",
//       architecture: "",
//       model: "Pixel 4",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "LG Optimus L70",
//     screen: {
//       horizontal: { width: 640, height: 384 },
//       "device-pixel-ratio": 1.25,
//       vertical: { width: 384, height: 640 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; U; Android 4.4.2; en-us; LGMS323 Build/KOT49I.MS32310c) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "4.4.2",
//       architecture: "",
//       model: "LGMS323",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Nokia N9",
//     screen: {
//       horizontal: { width: 854, height: 480 },
//       "device-pixel-ratio": 1,
//       vertical: { width: 480, height: 854 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (MeeGo; NokiaN9) AppleWebKit/534.13 (KHTML, like Gecko) NokiaBrowser/8.5.0 Mobile Safari/534.13",
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Nokia Lumia 520",
//     screen: {
//       horizontal: { width: 533, height: 320 },
//       "device-pixel-ratio": 1.5,
//       vertical: { width: 320, height: 533 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; IEMobile/10.0; ARM; Touch; NOKIA; Lumia 520)",
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Microsoft Lumia 550",
//     screen: {
//       horizontal: { width: 640, height: 360 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 640, height: 360 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Windows Phone 10.0; Android 4.2.1; Microsoft; Lumia 550) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Mobile Safari/537.36 Edge/14.14263",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "4.2.1",
//       architecture: "",
//       model: "Lumia 550",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Microsoft Lumia 950",
//     screen: {
//       horizontal: { width: 640, height: 360 },
//       "device-pixel-ratio": 4,
//       vertical: { width: 360, height: 640 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Windows Phone 10.0; Android 4.2.1; Microsoft; Lumia 950) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Mobile Safari/537.36 Edge/14.14263",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "4.2.1",
//       architecture: "",
//       model: "Lumia 950",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Galaxy S III",
//     screen: {
//       horizontal: { width: 640, height: 360 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 360, height: 640 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; U; Android 4.0; en-us; GT-I9300 Build/IMM76D) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "4.0",
//       architecture: "",
//       model: "GT-I9300",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     order: 110,
//     "show-by-default": !1,
//     title: "Galaxy S5",
//     screen: {
//       horizontal: { width: 640, height: 360 },
//       "device-pixel-ratio": 3,
//       vertical: { width: 360, height: 640 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "5.0",
//       architecture: "",
//       model: "SM-G900P",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Galaxy S8",
//     screen: {
//       horizontal: { width: 740, height: 360 },
//       "device-pixel-ratio": 3,
//       vertical: { width: 360, height: 740 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 7.0; SM-G950U Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.84 Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "7.0",
//       architecture: "",
//       model: "SM-G950U",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Galaxy S9+",
//     screen: {
//       horizontal: { width: 658, height: 320 },
//       "device-pixel-ratio": 4.5,
//       vertical: { width: 320, height: 658 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 8.0.0; SM-G965U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "8.0.0",
//       architecture: "",
//       model: "SM-G965U",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Galaxy Tab S4",
//     screen: {
//       horizontal: { width: 1138, height: 712 },
//       "device-pixel-ratio": 2.25,
//       vertical: { width: 712, height: 1138 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 8.1.0; SM-T837A) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.80 Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "8.1.0",
//       architecture: "",
//       model: "SM-T837A",
//       mobile: !1,
//     },
//     type: "phone",
//   },
//   {
//     order: 1,
//     "show-by-default": !1,
//     title: "JioPhone 2",
//     screen: {
//       horizontal: { width: 320, height: 240 },
//       "device-pixel-ratio": 1,
//       vertical: { width: 240, height: 320 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Mobile; LYF/F300B/LYF-F300B-001-01-15-130718-i;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "",
//       architecture: "",
//       model: "LYF/F300B/LYF-F300B-001-01-15-130718-i",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Kindle Fire HDX",
//     screen: {
//       horizontal: { width: 1280, height: 800 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 800, height: 1280 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; U; en-us; KFAPWI Build/JDQ39) AppleWebKit/535.19 (KHTML, like Gecko) Silk/3.13 Safari/535.19 Silk-Accelerated=true",
//     type: "tablet",
//   },
//   {
//     order: 140,
//     "show-by-default": !1,
//     title: "iPad",
//     screen: {
//       horizontal: {
//         outline: {
//           image: "@url(optimized/iPad-landscape.avif)",
//           insets: { left: 112, top: 56, right: 116, bottom: 52 },
//         },
//         width: 1024,
//         height: 768,
//       },
//       "device-pixel-ratio": 2,
//       vertical: {
//         outline: {
//           image: "@url(optimized/iPad-portrait.avif)",
//           insets: { left: 52, top: 114, right: 55, bottom: 114 },
//         },
//         width: 768,
//         height: 1024,
//       },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (iPad; CPU OS 11_0 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) Version/11.0 Mobile/15A5341f Safari/604.1",
//     type: "tablet",
//   },
//   {
//     order: 141,
//     "show-by-default": !1,
//     title: "iPad Pro",
//     screen: {
//       horizontal: { width: 1366, height: 1024 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 1024, height: 1366 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (iPad; CPU OS 11_0 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) Version/11.0 Mobile/15A5341f Safari/604.1",
//     type: "tablet",
//   },
//   {
//     "show-by-default": !1,
//     title: "Blackberry PlayBook",
//     screen: {
//       horizontal: { width: 1024, height: 600 },
//       "device-pixel-ratio": 1,
//       vertical: { width: 600, height: 1024 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (PlayBook; U; RIM Tablet OS 2.1.0; en-US) AppleWebKit/536.2+ (KHTML like Gecko) Version/7.2.1.0 Safari/536.2+",
//     type: "tablet",
//   },
//   {
//     "show-by-default": !1,
//     title: "Nexus 10",
//     screen: {
//       horizontal: { width: 1280, height: 800 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 800, height: 1280 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 10 Build/MOB31T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "6.0.1",
//       architecture: "",
//       model: "Nexus 10",
//       mobile: !1,
//     },
//     type: "tablet",
//   },
//   {
//     "show-by-default": !1,
//     title: "Nexus 7",
//     screen: {
//       horizontal: { width: 960, height: 600 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 600, height: 960 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 7 Build/MOB30X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "6.0.1",
//       architecture: "",
//       model: "Nexus 7",
//       mobile: !1,
//     },
//     type: "tablet",
//   },
//   {
//     "show-by-default": !1,
//     title: "Galaxy Note 3",
//     screen: {
//       horizontal: { width: 640, height: 360 },
//       "device-pixel-ratio": 3,
//       vertical: { width: 360, height: 640 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; U; Android 4.3; en-us; SM-N900T Build/JSS15J) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "4.3",
//       architecture: "",
//       model: "SM-N900T",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Galaxy Note II",
//     screen: {
//       horizontal: { width: 640, height: 360 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 360, height: 640 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; U; Android 4.1; en-us; GT-N7100 Build/JRO03C) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "4.1",
//       architecture: "",
//       model: "GT-N7100",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: r(n.laptopWithTouch),
//     screen: {
//       horizontal: { width: 1280, height: 950 },
//       "device-pixel-ratio": 1,
//       vertical: { width: 950, height: 1280 },
//     },
//     capabilities: ["touch"],
//     "user-agent": "",
//     type: "notebook",
//     modes: [{ title: "default", orientation: "horizontal" }],
//   },
//   {
//     "show-by-default": !1,
//     title: r(n.laptopWithHiDPIScreen),
//     screen: {
//       horizontal: { width: 1440, height: 900 },
//       "device-pixel-ratio": 2,
//       vertical: { width: 900, height: 1440 },
//     },
//     capabilities: [],
//     "user-agent": "",
//     type: "notebook",
//     modes: [{ title: "default", orientation: "horizontal" }],
//   },
//   {
//     "show-by-default": !1,
//     title: r(n.laptopWithMDPIScreen),
//     screen: {
//       horizontal: { width: 1280, height: 800 },
//       "device-pixel-ratio": 1,
//       vertical: { width: 800, height: 1280 },
//     },
//     capabilities: [],
//     "user-agent": "",
//     type: "notebook",
//     modes: [{ title: "default", orientation: "horizontal" }],
//   },
//   {
//     "show-by-default": !1,
//     title: "Moto G4",
//     screen: {
//       horizontal: {
//         outline: {
//           image: "@url(optimized/MotoG4-landscape.avif)",
//           insets: { left: 91, top: 30, right: 74, bottom: 30 },
//         },
//         width: 640,
//         height: 360,
//       },
//       "device-pixel-ratio": 3,
//       vertical: {
//         outline: {
//           image: "@url(optimized/MotoG4-portrait.avif)",
//           insets: { left: 30, top: 91, right: 30, bottom: 74 },
//         },
//         width: 360,
//         height: 640,
//       },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 6.0.1; Moto G (4)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "6.0.1",
//       architecture: "",
//       model: "Moto G (4)",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     "show-by-default": !1,
//     title: "Moto G Power",
//     screen: {
//       "device-pixel-ratio": 1.75,
//       horizontal: { width: 823, height: 412 },
//       vertical: { width: 412, height: 823 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 11; moto g power (2022)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "11",
//       architecture: "",
//       model: "moto g power (2022)",
//       mobile: !0,
//     },
//     type: "phone",
//   },
//   {
//     order: 200,
//     "show-by-default": !1,
//     title: "Facebook on Android",
//     screen: {
//       horizontal: { width: 892, height: 412 },
//       "device-pixel-ratio": 3.5,
//       vertical: { width: 412, height: 892 },
//     },
//     capabilities: ["touch", "mobile"],
//     "user-agent":
//       "Mozilla/5.0 (Linux; Android 12; Pixel 6 Build/SQ3A.220705.004; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/%s Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/407.0.0.0.65;]",
//     "user-agent-metadata": {
//       platform: "Android",
//       platformVersion: "12",
//       architecture: "",
//       model: "Pixel 6",
//       mobile: !0,
//     },
//     type: "phone",
//   },
// ];
// var S = Object.freeze({
//   __proto__: null,
//   computeRelativeImageURL: h,
//   EmulatedDevice: s,
//   Horizontal: d,
//   Vertical: c,
//   HorizontalSpanned: u,
//   VerticalSpanned: g,
//   Type: p,
//   Capability: m,
//   _Show: b,
//   EmulatedDevicesList: v,
// });
// const M = {
//     widthCannotBeEmpty: "Width cannot be empty.",
//     widthMustBeANumber: "Width must be a number.",
//     widthMustBeLessThanOrEqualToS: "Width must be less than or equal to {PH1}.",
//     widthMustBeGreaterThanOrEqualToS:
//       "Width must be greater than or equal to {PH1}.",
//     heightCannotBeEmpty: "Height cannot be empty.",
//     heightMustBeANumber: "Height must be a number.",
//     heightMustBeLessThanOrEqualToS:
//       "Height must be less than or equal to {PH1}.",
//     heightMustBeGreaterThanOrEqualTo:
//       "Height must be greater than or equal to {PH1}.",
//     devicePixelRatioMustBeANumberOr:
//       "Device pixel ratio must be a number or blank.",
//     devicePixelRatioMustBeLessThanOr:
//       "Device pixel ratio must be less than or equal to {PH1}.",
//     devicePixelRatioMustBeGreater:
//       "Device pixel ratio must be greater than or equal to {PH1}.",
//   },
//   x = i.i18n.registerUIStrings("models/emulation/DeviceModeModel.ts", M),
//   y = i.i18n.getLocalizedString.bind(void 0, x);
// let z;
// class I extends e.ObjectWrapper.ObjectWrapper {
//   #l;
//   #r;
//   #h;
//   #s;
//   #d;
//   #c;
//   #u;
//   #g;
//   #p;
//   #m;
//   #b;
//   #f;
//   #v;
//   #w;
//   #S;
//   #M;
//   #x;
//   #y;
//   #z;
//   #I;
//   #A;
//   #k;
//   #P;
//   #T;
//   #L;
//   #C;
//   constructor() {
//     super(),
//       (this.#l = new k(0, 0, 1, 1)),
//       (this.#r = new k(0, 0, 1, 1)),
//       (this.#h = new a.Geometry.Size(1, 1)),
//       (this.#s = new a.Geometry.Size(1, 1)),
//       (this.#d = !1),
//       (this.#c = new a.Geometry.Size(1, 1)),
//       (this.#u = window.devicePixelRatio),
//       (this.#g = "Desktop"),
//       (this.#p =
//         !!window.visualViewport && "segments" in window.visualViewport),
//       (this.#m = e.Settings.Settings.instance().createSetting(
//         "emulation.device-scale",
//         1
//       )),
//       this.#m.get() || this.#m.set(1),
//       this.#m.addChangeListener(this.scaleSettingChanged, this),
//       (this.#b = 1),
//       (this.#f = e.Settings.Settings.instance().createSetting(
//         "emulation.device-width",
//         400
//       )),
//       this.#f.get() < T && this.#f.set(T),
//       this.#f.get() > L && this.#f.set(L),
//       this.#f.addChangeListener(this.widthSettingChanged, this),
//       (this.#v = e.Settings.Settings.instance().createSetting(
//         "emulation.device-height",
//         0
//       )),
//       this.#v.get() && this.#v.get() < T && this.#v.set(T),
//       this.#v.get() > L && this.#v.set(L),
//       this.#v.addChangeListener(this.heightSettingChanged, this),
//       (this.#w = e.Settings.Settings.instance().createSetting(
//         "emulation.device-ua",
//         "Mobile"
//       )),
//       this.#w.addChangeListener(this.uaSettingChanged, this),
//       (this.#S = e.Settings.Settings.instance().createSetting(
//         "emulation.device-scale-factor",
//         0
//       )),
//       this.#S.addChangeListener(this.deviceScaleFactorSettingChanged, this),
//       (this.#M = e.Settings.Settings.instance().moduleSetting(
//         "emulation.show-device-outline"
//       )),
//       this.#M.addChangeListener(this.deviceOutlineSettingChanged, this),
//       (this.#x = e.Settings.Settings.instance().createSetting(
//         "emulation.toolbar-controls-enabled",
//         !0,
//         "Session"
//       )),
//       (this.#y = P.None),
//       (this.#z = null),
//       (this.#I = null),
//       (this.#A = 1),
//       (this.#k = !1),
//       (this.#P = !1),
//       (this.#T = null),
//       (this.#L = null),
//       o.TargetManager.TargetManager.instance().observeModels(
//         o.EmulationModel.EmulationModel,
//         this
//       );
//   }
//   static instance(e) {
//     return (z && !e?.forceNew) || (z = new I()), z;
//   }
//   static widthValidator(e) {
//     let t,
//       i = !1;
//     return (
//       e
//         ? /^[\d]+$/.test(e)
//           ? Number(e) > L
//             ? (t = y(M.widthMustBeLessThanOrEqualToS, { PH1: L }))
//             : Number(e) < T
//             ? (t = y(M.widthMustBeGreaterThanOrEqualToS, { PH1: T }))
//             : (i = !0)
//           : (t = y(M.widthMustBeANumber))
//         : (t = y(M.widthCannotBeEmpty)),
//       { valid: i, errorMessage: t }
//     );
//   }
//   static heightValidator(e) {
//     let t,
//       i = !1;
//     return (
//       e
//         ? /^[\d]+$/.test(e)
//           ? Number(e) > L
//             ? (t = y(M.heightMustBeLessThanOrEqualToS, { PH1: L }))
//             : Number(e) < T
//             ? (t = y(M.heightMustBeGreaterThanOrEqualTo, { PH1: T }))
//             : (i = !0)
//           : (t = y(M.heightMustBeANumber))
//         : (t = y(M.heightCannotBeEmpty)),
//       { valid: i, errorMessage: t }
//     );
//   }
//   static scaleValidator(e) {
//     let t,
//       i = !1;
//     const o = Number(e.trim());
//     return (
//       e
//         ? Number.isNaN(o)
//           ? (t = y(M.devicePixelRatioMustBeANumberOr))
//           : Number(e) > E
//           ? (t = y(M.devicePixelRatioMustBeLessThanOr, { PH1: E }))
//           : Number(e) < C
//           ? (t = y(M.devicePixelRatioMustBeGreater, { PH1: C }))
//           : (i = !0)
//         : (i = !0),
//       { valid: i, errorMessage: t }
//     );
//   }
//   get scaleSettingInternal() {
//     return this.#m;
//   }
//   setAvailableSize(e, t) {
//     (this.#h = e), (this.#s = t), (this.#d = !0), this.calculateAndEmulate(!1);
//   }
//   emulate(e, i, o, a) {
//     const n = this.#y !== e || this.#z !== i || this.#I !== o;
//     if (((this.#y = e), e === P.Device && i && o)) {
//       if (
//         (console.assert(
//           Boolean(i) && Boolean(o),
//           "Must pass device and mode for device emulation"
//         ),
//         (this.#I = o),
//         (this.#z = i),
//         this.#d)
//       ) {
//         const e = i.orientationByName(o.orientation);
//         this.#m.set(
//           a ||
//             this.calculateFitScale(
//               e.width,
//               e.height,
//               this.currentOutline(),
//               this.currentInsets()
//             )
//         );
//       }
//     } else (this.#z = null), (this.#I = null);
//     e !== P.None &&
//       t.userMetrics.actionTaken(t.UserMetrics.Action.DeviceModeEnabled),
//       this.calculateAndEmulate(n);
//   }
//   setWidth(e) {
//     const t = Math.min(L, this.preferredScaledWidth());
//     (e = Math.max(Math.min(e, t), 1)), this.#f.set(e);
//   }
//   setWidthAndScaleToFit(e) {
//     (e = Math.max(Math.min(e, L), 1)),
//       this.#m.set(this.calculateFitScale(e, this.#v.get())),
//       this.#f.set(e);
//   }
//   setHeight(e) {
//     const t = Math.min(L, this.preferredScaledHeight());
//     (e = Math.max(Math.min(e, t), 0)) === this.preferredScaledHeight() &&
//       (e = 0),
//       this.#v.set(e);
//   }
//   setHeightAndScaleToFit(e) {
//     (e = Math.max(Math.min(e, L), 0)),
//       this.#m.set(this.calculateFitScale(this.#f.get(), e)),
//       this.#v.set(e);
//   }
//   setScale(e) {
//     this.#m.set(e);
//   }
//   device() {
//     return this.#z;
//   }
//   mode() {
//     return this.#I;
//   }
//   type() {
//     return this.#y;
//   }
//   screenImage() {
//     return this.#z && this.#I ? this.#z.modeImage(this.#I) : "";
//   }
//   outlineImage() {
//     return this.#z && this.#I && this.#M.get()
//       ? this.#z.outlineImage(this.#I)
//       : "";
//   }
//   outlineRect() {
//     return this.#C || null;
//   }
//   screenRect() {
//     return this.#l;
//   }
//   visiblePageRect() {
//     return this.#r;
//   }
//   scale() {
//     return this.#b;
//   }
//   fitScale() {
//     return this.#A;
//   }
//   appliedDeviceSize() {
//     return this.#c;
//   }
//   appliedDeviceScaleFactor() {
//     return this.#u;
//   }
//   appliedUserAgentType() {
//     return this.#g;
//   }
//   isFullHeight() {
//     return !this.#v.get();
//   }
//   isMobile() {
//     switch (this.#y) {
//       case P.Device:
//         return !!this.#z && this.#z.mobile();
//       case P.None:
//         return !1;
//       case P.Responsive:
//         return (
//           "Mobile" === this.#w.get() || "Mobile (no touch)" === this.#w.get()
//         );
//     }
//     return !1;
//   }
//   enabledSetting() {
//     return e.Settings.Settings.instance().createSetting(
//       "emulation.show-device-mode",
//       !1
//     );
//   }
//   scaleSetting() {
//     return this.#m;
//   }
//   uaSetting() {
//     return this.#w;
//   }
//   deviceScaleFactorSetting() {
//     return this.#S;
//   }
//   deviceOutlineSetting() {
//     return this.#M;
//   }
//   toolbarControlsEnabledSetting() {
//     return this.#x;
//   }
//   reset() {
//     this.#S.set(0),
//       this.#m.set(1),
//       this.setWidth(400),
//       this.setHeight(0),
//       this.#w.set("Mobile");
//   }
//   modelAdded(e) {
//     if (
//       e.target() ===
//         o.TargetManager.TargetManager.instance().primaryPageTarget() &&
//       e.supportsDeviceEmulation()
//     ) {
//       if (((this.#T = e), this.#L)) {
//         const e = this.#L;
//         (this.#L = null), e();
//       }
//       const t = e.target().model(o.ResourceTreeModel.ResourceTreeModel);
//       t &&
//         (t.addEventListener(
//           o.ResourceTreeModel.Events.FrameResized,
//           this.onFrameChange,
//           this
//         ),
//         t.addEventListener(
//           o.ResourceTreeModel.Events.FrameNavigated,
//           this.onFrameChange,
//           this
//         ));
//     } else e.emulateTouch(this.#k, this.#P);
//   }
//   modelRemoved(e) {
//     this.#T === e && (this.#T = null);
//   }
//   inspectedURL() {
//     return this.#T ? this.#T.target().inspectedURL() : null;
//   }
//   onFrameChange() {
//     const e = this.#T ? this.#T.overlayModel() : null;
//     e && this.showHingeIfApplicable(e);
//   }
//   scaleSettingChanged() {
//     this.calculateAndEmulate(!1);
//   }
//   widthSettingChanged() {
//     this.calculateAndEmulate(!1);
//   }
//   heightSettingChanged() {
//     this.calculateAndEmulate(!1);
//   }
//   uaSettingChanged() {
//     this.calculateAndEmulate(!0);
//   }
//   deviceScaleFactorSettingChanged() {
//     this.calculateAndEmulate(!1);
//   }
//   deviceOutlineSettingChanged() {
//     this.calculateAndEmulate(!1);
//   }
//   preferredScaledWidth() {
//     return Math.floor(this.#s.width / (this.#m.get() || 1));
//   }
//   preferredScaledHeight() {
//     return Math.floor(this.#s.height / (this.#m.get() || 1));
//   }
//   currentOutline() {
//     let e = new A(0, 0, 0, 0);
//     if (this.#y !== P.Device || !this.#z || !this.#I) return e;
//     const t = this.#z.orientationByName(this.#I.orientation);
//     return this.#M.get() && (e = t.outlineInsets || e), e;
//   }
//   currentInsets() {
//     return this.#y === P.Device && this.#I ? this.#I.insets : new A(0, 0, 0, 0);
//   }
//   getScreenOrientationType() {
//     if (!this.#I) throw new Error("Mode required to get orientation type.");
//     switch (this.#I.orientation) {
//       case g:
//       case c:
//         return "portraitPrimary";
//       default:
//         return "landscapePrimary";
//     }
//   }
//   calculateAndEmulate(e) {
//     this.#T || (this.#L = this.calculateAndEmulate.bind(this, e));
//     const t = this.isMobile(),
//       i = this.#T ? this.#T.overlayModel() : null;
//     if (
//       (i && this.showHingeIfApplicable(i),
//       this.#y === P.Device && this.#z && this.#I)
//     ) {
//       const i = this.#z.orientationByName(this.#I.orientation),
//         o = this.currentOutline(),
//         n = this.currentInsets();
//       (this.#A = this.calculateFitScale(i.width, i.height, o, n)),
//         (this.#g = t
//           ? this.#z.touch()
//             ? "Mobile"
//             : "Mobile (no touch)"
//           : this.#z.touch()
//           ? "Desktop (touch)"
//           : "Desktop"),
//         this.applyDeviceMetrics(
//           new a.Geometry.Size(i.width, i.height),
//           n,
//           o,
//           this.#m.get(),
//           this.#z.deviceScaleFactor,
//           t,
//           this.getScreenOrientationType(),
//           e,
//           this.#p
//         ),
//         this.applyUserAgent(this.#z.userAgent, this.#z.userAgentMetadata),
//         this.applyTouch(this.#z.touch(), t);
//     } else if (this.#y === P.None)
//       (this.#A = this.calculateFitScale(this.#h.width, this.#h.height)),
//         (this.#g = "Desktop"),
//         this.applyDeviceMetrics(
//           this.#h,
//           new A(0, 0, 0, 0),
//           new A(0, 0, 0, 0),
//           1,
//           0,
//           t,
//           null,
//           e
//         ),
//         this.applyUserAgent("", null),
//         this.applyTouch(!1, !1);
//     else if (this.#y === P.Responsive) {
//       let i = this.#f.get();
//       (!i || i > this.preferredScaledWidth()) &&
//         (i = this.preferredScaledWidth());
//       let o = this.#v.get();
//       (!o || o > this.preferredScaledHeight()) &&
//         (o = this.preferredScaledHeight());
//       const n = t ? F : 0;
//       (this.#A = this.calculateFitScale(this.#f.get(), this.#v.get())),
//         (this.#g = this.#w.get()),
//         this.applyDeviceMetrics(
//           new a.Geometry.Size(i, o),
//           new A(0, 0, 0, 0),
//           new A(0, 0, 0, 0),
//           this.#m.get(),
//           this.#S.get() || n,
//           t,
//           o >= i ? "portraitPrimary" : "landscapePrimary",
//           e
//         ),
//         this.applyUserAgent(t ? K : "", t ? N : null),
//         this.applyTouch(
//           "Desktop (touch)" === this.#w.get() || "Mobile" === this.#w.get(),
//           "Mobile" === this.#w.get()
//         );
//     }
//     i && i.setShowViewportSizeOnResize(this.#y === P.None),
//       this.dispatchEventToListeners("Updated");
//   }
//   calculateFitScale(e, t, i, o) {
//     const a = i ? i.left + i.right : 0,
//       n = i ? i.top + i.bottom : 0,
//       l = o ? o.left + o.right : 0,
//       r = o ? o.top + o.bottom : 0;
//     let h = Math.min(
//       e ? this.#s.width / (e + a) : 1,
//       t ? this.#s.height / (t + n) : 1
//     );
//     h = Math.min(Math.floor(100 * h), 100);
//     let s = h;
//     for (; s > 0.7 * h; ) {
//       let i = !0;
//       if (
//         (e && (i = i && Number.isInteger(((e - l) * s) / 100)),
//         t && (i = i && Number.isInteger(((t - r) * s) / 100)),
//         i)
//       )
//         return s / 100;
//       s -= 1;
//     }
//     return h / 100;
//   }
//   setSizeAndScaleToFit(e, t) {
//     this.#m.set(this.calculateFitScale(e, t)),
//       this.setWidth(e),
//       this.setHeight(t);
//   }
//   applyUserAgent(e, t) {
//     o.NetworkManager.MultitargetNetworkManager.instance().setUserAgentOverride(
//       e,
//       t
//     );
//   }
//   applyDeviceMetrics(e, t, i, o, a, n, l, r, h = !1) {
//     (e.width = Math.max(1, Math.floor(e.width))),
//       (e.height = Math.max(1, Math.floor(e.height)));
//     let s = e.width - t.left - t.right,
//       d = e.height - t.top - t.bottom;
//     const c = t.left,
//       u = t.top,
//       g = "landscapePrimary" === l ? 90 : 0;
//     if (
//       ((this.#c = e),
//       (this.#u = a || window.devicePixelRatio),
//       (this.#l = new k(
//         Math.max(0, (this.#h.width - e.width * o) / 2),
//         i.top * o,
//         e.width * o,
//         e.height * o
//       )),
//       (this.#C = new k(
//         this.#l.left - i.left * o,
//         0,
//         (i.left + e.width + i.right) * o,
//         (i.top + e.height + i.bottom) * o
//       )),
//       (this.#r = new k(
//         c * o,
//         u * o,
//         Math.min(s * o, this.#h.width - this.#l.left - c * o),
//         Math.min(d * o, this.#h.height - this.#l.top - u * o)
//       )),
//       (this.#b = o),
//       h ||
//         (1 === o &&
//           this.#h.width >= e.width &&
//           this.#h.height >= e.height &&
//           ((s = 0), (d = 0)),
//         this.#r.width === s * o &&
//           this.#r.height === d * o &&
//           Number.isInteger(s * o) &&
//           Number.isInteger(d * o) &&
//           ((s = 0), (d = 0))),
//       this.#T)
//     )
//       if (
//         (r && this.#T.resetPageScaleFactor(),
//         s || d || n || a || 1 !== o || l || h)
//       ) {
//         const t = {
//             width: s,
//             height: d,
//             deviceScaleFactor: a,
//             mobile: n,
//             scale: o,
//             screenWidth: e.width,
//             screenHeight: e.height,
//             positionX: c,
//             positionY: u,
//             dontSetVisibleSize: !0,
//             displayFeature: void 0,
//             devicePosture: void 0,
//             screenOrientation: void 0,
//           },
//           i = this.getDisplayFeature();
//         i
//           ? ((t.displayFeature = i), (t.devicePosture = { type: "folded" }))
//           : (t.devicePosture = { type: "continuous" }),
//           l && (t.screenOrientation = { type: l, angle: g }),
//           this.#T.emulateDevice(t);
//       } else this.#T.emulateDevice(null);
//   }
//   exitHingeMode() {
//     const e = this.#T ? this.#T.overlayModel() : null;
//     e && e.showHingeForDualScreen(null);
//   }
//   webPlatformExperimentalFeaturesEnabled() {
//     return this.#p;
//   }
//   shouldReportDisplayFeature() {
//     return this.#p;
//   }
//   async captureScreenshot(e, t) {
//     const i = this.#T
//       ? this.#T.target().model(o.ScreenCaptureModel.ScreenCaptureModel)
//       : null;
//     if (!i) return null;
//     let a;
//     a = t ? "fromClip" : e ? "fullpage" : "fromViewport";
//     const n = this.#T ? this.#T.overlayModel() : null;
//     n && n.setShowViewportSizeOnResize(!1);
//     const l = await i.captureScreenshot("png", 100, a, t),
//       r = { width: 0, height: 0, deviceScaleFactor: 0, mobile: !1 };
//     if (e && this.#T) {
//       if (this.#z && this.#I) {
//         const e = this.#z.orientationByName(this.#I.orientation);
//         (r.width = e.width), (r.height = e.height);
//         const t = this.getDisplayFeature();
//         t && (r.displayFeature = t);
//       } else (r.width = 0), (r.height = 0);
//       await this.#T.emulateDevice(r);
//     }
//     return this.calculateAndEmulate(!1), l;
//   }
//   applyTouch(e, t) {
//     (this.#k = e), (this.#P = t);
//     for (const i of o.TargetManager.TargetManager.instance().models(
//       o.EmulationModel.EmulationModel
//     ))
//       i.emulateTouch(e, t);
//   }
//   showHingeIfApplicable(e) {
//     const t =
//       this.#z && this.#I
//         ? this.#z.orientationByName(this.#I.orientation)
//         : null;
//     t && t.hinge
//       ? e.showHingeForDualScreen(t.hinge)
//       : e.showHingeForDualScreen(null);
//   }
//   getDisplayFeatureOrientation() {
//     if (!this.#I)
//       throw new Error("Mode required to get display feature orientation.");
//     switch (this.#I.orientation) {
//       case g:
//       case c:
//         return "vertical";
//       default:
//         return "horizontal";
//     }
//   }
//   getDisplayFeature() {
//     if (!this.shouldReportDisplayFeature()) return null;
//     if (
//       !this.#z ||
//       !this.#I ||
//       (this.#I.orientation !== g && this.#I.orientation !== u)
//     )
//       return null;
//     const e = this.#z.orientationByName(this.#I.orientation);
//     if (!e || !e.hinge) return null;
//     const t = e.hinge;
//     return {
//       orientation: this.getDisplayFeatureOrientation(),
//       offset: this.#I.orientation === g ? t.x : t.y,
//       maskLength: this.#I.orientation === g ? t.width : t.height,
//     };
//   }
// }
// class A {
//   left;
//   top;
//   right;
//   bottom;
//   constructor(e, t, i, o) {
//     (this.left = e), (this.top = t), (this.right = i), (this.bottom = o);
//   }
//   isEqual(e) {
//     return (
//       null !== e &&
//       this.left === e.left &&
//       this.top === e.top &&
//       this.right === e.right &&
//       this.bottom === e.bottom
//     );
//   }
// }
// class k {
//   left;
//   top;
//   width;
//   height;
//   constructor(e, t, i, o) {
//     (this.left = e), (this.top = t), (this.width = i), (this.height = o);
//   }
//   isEqual(e) {
//     return (
//       null !== e &&
//       this.left === e.left &&
//       this.top === e.top &&
//       this.width === e.width &&
//       this.height === e.height
//     );
//   }
//   scale(e) {
//     return new k(this.left * e, this.top * e, this.width * e, this.height * e);
//   }
//   relativeTo(e) {
//     return new k(this.left - e.left, this.top - e.top, this.width, this.height);
//   }
//   rebaseTo(e) {
//     return new k(this.left + e.left, this.top + e.top, this.width, this.height);
//   }
// }
// var P;
// !(function (e) {
//   (e.None = "None"), (e.Responsive = "Responsive"), (e.Device = "Device");
// })(P || (P = {}));
// const T = 50,
//   L = 9999,
//   C = 0,
//   E = 10,
//   K =
//     o.NetworkManager.MultitargetNetworkManager.patchUserAgentWithChromeVersion(
//       "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36"
//     ),
//   N = {
//     platform: "Android",
//     platformVersion: "6.0",
//     architecture: "",
//     model: "Nexus 5",
//     mobile: !0,
//   },
//   F = 2;
// var G = Object.freeze({
//   __proto__: null,
//   DeviceModeModel: I,
//   Insets: A,
//   Rect: k,
//   get Type() {
//     return P;
//   },
//   MinDeviceSize: T,
//   MaxDeviceSize: L,
//   MinDeviceScaleFactor: C,
//   MaxDeviceScaleFactor: E,
//   MaxDeviceNameLength: 50,
//   defaultMobileScaleFactor: F,
// });
// export { G as DeviceModeModel, S as EmulatedDevices };
