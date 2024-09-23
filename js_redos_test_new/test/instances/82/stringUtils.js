"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _settings = _interopRequireDefault(require("./settings.js"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); }
function _toArray(r) { return _arrayWithHoles(r) || _iterableToArray(r) || _unsupportedIterableToArray(r) || _nonIterableRest(); }
function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _unsupportedIterableToArray(r, a) { if (r) { if ("string" == typeof r) return _arrayLikeToArray(r, a); var t = {}.toString.call(r).slice(8, -1); return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0; } }
function _arrayLikeToArray(r, a) { (null == a || a > r.length) && (a = r.length); for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e]; return n; }
function _iterableToArray(r) { if ("undefined" != typeof Symbol && null != r[Symbol.iterator] || null != r["@@iterator"]) return Array.from(r); }
function _arrayWithHoles(r) { if (Array.isArray(r)) return r; }
function _classCallCheck(a, n) { if (!(a instanceof n)) throw new TypeError("Cannot call a class as a function"); }
function _defineProperties(e, r) { for (var t = 0; t < r.length; t++) { var o = r[t]; o.enumerable = o.enumerable || !1, o.configurable = !0, "value" in o && (o.writable = !0), Object.defineProperty(e, _toPropertyKey(o.key), o); } }
function _createClass(e, r, t) { return r && _defineProperties(e.prototype, r), t && _defineProperties(e, t), Object.defineProperty(e, "prototype", { writable: !1 }), e; }
function _toPropertyKey(t) { var i = _toPrimitive(t, "string"); return "symbol" == _typeof(i) ? i : i + ""; }
function _toPrimitive(t, r) { if ("object" != _typeof(t) || !t) return t; var e = t[Symbol.toPrimitive]; if (void 0 !== e) { var i = e.call(t, r || "default"); if ("object" != _typeof(i)) return i; throw new TypeError("@@toPrimitive must return a primitive value."); } return ("string" === r ? String : Number)(t); }
var StringUtils = exports["default"] = /*#__PURE__*/function () {
  function StringUtils() {
    _classCallCheck(this, StringUtils);
  }
  return _createClass(StringUtils, null, [{
    key: "capitalize",
    value: function capitalize(_ref) {
      var _ref2 = _toArray(_ref),
        first = _ref2[0],
        rest = _ref2.slice(1);
      var lowerRest = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;
      return first.toUpperCase() + (lowerRest ? rest.join('').toLowerCase() : rest.join(''));
    }
  }, {
    key: "toKebabCase",
    value: function toKebabCase(str) {
      return str && str.match(/[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+/g).map(function (x) {
        return x.toLowerCase();
      }).join('-');
    }
  }, {
    key: "convertToValidId",
    value: function convertToValidId(str) {
      return StringUtils.toKebabCase(StringUtils.stripHtmlTags(str));
    }
  }, {
    key: "convertToSeoSlug",
    value: function convertToSeoSlug(str) {
      return "/".concat(StringUtils.toKebabCase(str));
    }
  }, {
    key: "stripMarkdown",
    value: function stripMarkdown(str) {
      return str.replace(/[`*]/g, '').replace(/\n/g, '').replace(/\[(.*)\]\(.*\)/g, '$1');
      // .replace(/_(.*?)_/g, '$1');
    }
  }, {
    key: "stripHtmlParagraphsAndLinks",
    value: function stripHtmlParagraphsAndLinks(str) {
      return str.replace(/<\/?p>/g, '').replace(/<a.*?>(.*?)<\/a>/g, '$1');
    }
  }, {
    key: "stripHtmlTags",
    value: function stripHtmlTags(str) {
      return str.replace(/<[^>]*>/g, '');
    }
  }, {
    key: "stripHtml",
    value: function stripHtml(str) {
      return str.replace(/<.*?>/g, '').replace(/&nbsp;/g, ' ').replace(/&amp;/g, '&').replace(/&gt;/g, '>').replace(/&lt;/g, '<');
    }
  }, {
    key: "normalizedTokens",
    value: function normalizedTokens(str) {
      return str.toLowerCase().trim().split(/[^a-z0-9\-']+/i).filter(function (x) {
        return x.length >= 2;
      });
    }
  }, {
    key: "escapeHtml",
    value: function escapeHtml(str) {
      return str.replace(/&/g, '&amp;').replace(/>/g, '&gt;').replace(/</g, '&lt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    }
  }, {
    key: "formatTag",
    value: function formatTag(tag) {
      if (!tag) return '';
      return _settings["default"].tags[tag] || tag.replace(/^./, tag[0].toUpperCase());
    }
  }]);
}();