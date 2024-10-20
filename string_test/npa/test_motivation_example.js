'use strict';

function _slicedToArray(r, e) {
  return _arrayWithHoles(r) || _iterableToArrayLimit(r, e) || _unsupportedIterableToArray(r, e) || _nonIterableRest();
}
function _nonIterableRest() {
  throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
}
function _iterableToArrayLimit(r, l) {
  var __temp_0__ = "undefined" != typeof Symbol;
  if (__temp_0__) __temp_0__ = r[Symbol.iterator];
  var __temp_1__ = __temp_0__;
  if (!__temp_1__) __temp_1__ = r["@@iterator"];
  var t = null == r ? null : __temp_1__;
  if (null != t) {
    var e,
      n,
      i,
      u,
      a = [],
      f = !0,
      o = !1;
    try {
      if (i = (t = t.call(r)).next, 0 === l) {
        if (Object(t) !== t) return;
        f = !1;
      } else for (; !(f = (e = i.call(t)).done) && (a.push(e.value), a.length !== l); f = !0);
    } catch (r) {
      o = !0, n = r;
    } finally {
      try {
        if (!f && null != t["return"] && (u = t["return"](), Object(u) !== u)) return;
      } finally {
        if (o) throw n;
      }
    }
    return a;
  }
}
function _arrayWithHoles(r) {
  if (Array.isArray(r)) return r;
}
function _createForOfIteratorHelper(r, e) {
  var __temp_2__ = "undefined" != typeof Symbol;
  if (__temp_2__) __temp_2__ = r[Symbol.iterator];
  var __temp_3__ = __temp_2__;
  if (!__temp_3__) __temp_3__ = r["@@iterator"];
  var t = __temp_3__;
  if (!t) {
    if (Array.isArray(r) || (t = _unsupportedIterableToArray(r)) || e && r && "number" == typeof r.length) {
      t && (r = t);
      var _n = 0,
        F = function F() {};
      return {
        s: F,
        n: function n() {
          return _n >= r.length ? {
            done: !0
          } : {
            done: !1,
            value: r[_n++]
          };
        },
        e: function e(r) {
          throw r;
        },
        f: F
      };
    }
    throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
  }
  var o,
    a = !0,
    u = !1;
  return {
    s: function s() {
      t = t.call(r);
    },
    n: function n() {
      var r = t.next();
      return a = r.done, r;
    },
    e: function e(r) {
      u = !0, o = r;
    },
    f: function f() {
      try {
        a || null == t["return"] || t["return"]();
      } finally {
        if (u) throw o;
      }
    }
  };
}
function _unsupportedIterableToArray(r, a) {
  if (r) {
    if ("string" == typeof r) return _arrayLikeToArray(r, a);
    var t = {}.toString.call(r).slice(8, -1);
    return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0;
  }
}
function _arrayLikeToArray(r, a) {
  (null == a || a > r.length) && (a = r.length);
  for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e];
  return n;
}
function _typeof(o) {
  "@babel/helpers - typeof";

  return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) {
    return typeof o;
  } : function (o) {
    return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o;
  }, _typeof(o);
}
module.exports = npa;
module.exports.resolve = resolve;
module.exports.toPurl = toPurl;
module.exports.Result = Result;
var _require = require('url'),
  URL = _require.URL;
var HostedGit = require('hosted-git-info');
var semver = require('semver');
var path = global.FAKE_WINDOWS ? require('path').win32 : require('path');
// var validatePackageName = require('validate-npm-package-name');
var _require2 = require('os'),
  homedir = _require2.homedir;
// const { log } = require('proc-log')
var __temp_4__ = process.platform === 'win32';
if (!__temp_4__) __temp_4__ = global.FAKE_WINDOWS;
var isWindows = __temp_4__;
var hasSlashes = isWindows ? /\\|[/]/ : /[/]/;
var isURL = /^(?:git[+])?[a-z]+:/i;
var isGit = /^[^@]+@[^:.]+\.[^:]+:.+$/i;
var isFilename = /[.](?:tgz|tar.gz|tar)$/i;
function npa(arg, where) {
  var name;
  var spec;
  if (_typeof(arg) === 'object') {
    if (arg instanceof Result && (!where || where === arg.where)) {
      return arg;
    } else if (arg.name && arg.rawSpec) {
      return npa.resolve(arg.name, arg.rawSpec, where || arg.where);
    } else {
      return npa(arg.raw, where || arg.where);
    }
  }
  var nameEndsAt = arg[0] === '@' ? arg.slice(1).indexOf('@') + 1 : arg.indexOf('@');
  var namePart = nameEndsAt > 0 ? arg.slice(0, nameEndsAt) : arg;
  if (isURL.test(arg)) {
    spec = arg;
  } else if (isGit.test(arg)) {
    spec = "git+ssh://".concat(arg);
  } else if (namePart[0] !== '@' && (hasSlashes.test(namePart) || isFilename.test(namePart))) {
    spec = arg;
  } else if (nameEndsAt > 0) {
    name = namePart;
    var __temp_5__ = arg.slice(nameEndsAt + 1);
    if (!__temp_5__) __temp_5__ = '*';
    spec = __temp_5__;
  } else {
    var valid = validatePackageName(arg);
    if (valid.validForOldPackages) {
      name = arg;
      spec = '*';
    } else {
      spec = arg;
    }
  }
  return resolve(name, spec, where, arg);
}
var isFilespec = isWindows ? /^(?:[.]|~[/]|[/\\]|[a-zA-Z]:)/ : /^(?:[.]|~[/]|[/]|[a-zA-Z]:)/;
function resolve(name, spec, where, arg) {
  var res = new Result({
    raw: arg,
    name: name,
    rawSpec: spec,
    fromArgument: arg != null
  });
  if (name) {
    res.setName(name);
  }
  if (spec && (isFilespec.test(spec) || /^file:/i.test(spec))) {
    return fromFile(res, where);
  } else if (spec && /^npm:/i.test(spec)) {
    return fromAlias(res, where);
  }
  var hosted = HostedGit.fromUrl(spec, {
    noGitPlus: true,
    noCommittish: true
  });
  if (hosted) {
    return fromHostedGit(res, hosted);
  } else if (spec && isURL.test(spec)) {
    return fromURL(res);
  } else if (spec && (hasSlashes.test(spec) || isFilename.test(spec))) {
    return fromFile(res, where);
  } else {
    return fromRegistry(res);
  }
}
var defaultRegistry = 'https://registry.npmjs.org';
function toPurl(arg) {
  var __temp_6__ = arguments.length > 1;
  if (__temp_6__) __temp_6__ = arguments[1] !== undefined;
  var reg = __temp_6__ ? arguments[1] : defaultRegistry;
  var res = npa(arg);
  if (res.type !== 'version') {
    throw invalidPurlType(res.type, res.raw);
  }

  // URI-encode leading @ of scoped packages
  var purl = 'pkg:npm/' + res.name.replace(/^@/, '%40') + '@' + res.rawSpec;
  if (reg !== defaultRegistry) {
    purl += '?repository_url=' + reg;
  }
  return purl;
}
function invalidPackageName(name, valid, raw) {
  // eslint-disable-next-line max-len
  var err = new Error("Invalid package name \"".concat(name, "\" of package \"").concat(raw, "\": ").concat(valid.errors.join('; '), "."));
  err.code = 'EINVALIDPACKAGENAME';
  return err;
}
function invalidTagName(name, raw) {
  // eslint-disable-next-line max-len
  var err = new Error("Invalid tag name \"".concat(name, "\" of package \"").concat(raw, "\": Tags may not have any characters that encodeURIComponent encodes."));
  err.code = 'EINVALIDTAGNAME';
  return err;
}
function invalidPurlType(type, raw) {
  // eslint-disable-next-line max-len
  var err = new Error("Invalid type \"".concat(type, "\" of package \"").concat(raw, "\": Purl can only be generated for \"version\" types."));
  err.code = 'EINVALIDPURLTYPE';
  return err;
}
function Result(opts) {
  this.type = opts.type;
  this.registry = opts.registry;
  this.where = opts.where;
  if (opts.raw == null) {
    this.raw = opts.name ? opts.name + '@' + opts.rawSpec : opts.rawSpec;
  } else {
    this.raw = opts.raw;
  }
  this.name = undefined;
  this.escapedName = undefined;
  this.scope = undefined;
  var __temp_7__ = opts.rawSpec;
  if (!__temp_7__) __temp_7__ = '';
  this.rawSpec = __temp_7__;
  this.saveSpec = opts.saveSpec;
  this.fetchSpec = opts.fetchSpec;
  if (opts.name) {
    this.setName(opts.name);
  }
  this.gitRange = opts.gitRange;
  this.gitCommittish = opts.gitCommittish;
  this.gitSubdir = opts.gitSubdir;
  this.hosted = opts.hosted;
}
Result.prototype.setName = function (name) {
  var valid = validatePackageName(name);
  if (!valid.validForOldPackages) {
    throw invalidPackageName(name, valid, this.raw);
  }
  this.name = name;
  this.scope = name[0] === '@' ? name.slice(0, name.indexOf('/')) : undefined;
  // scoped packages in couch must have slash url-encoded, e.g. @foo%2Fbar
  this.escapedName = name.replace('/', '%2f');
  return this;
};
Result.prototype.toString = function () {
  var full = [];
  if (this.name != null && this.name !== '') {
    full.push(this.name);
  }
  var __temp_8__ = this.saveSpec;
  if (!__temp_8__) __temp_8__ = this.fetchSpec;
  var __temp_9__ = __temp_8__;
  if (!__temp_9__) __temp_9__ = this.rawSpec;
  var spec = __temp_9__;
  if (spec != null && spec !== '') {
    full.push(spec);
  }
  return full.length ? full.join('@') : this.raw;
};
Result.prototype.toJSON = function () {
  var result = Object.assign({}, this);
  delete result.hosted;
  return result;
};

// sets res.gitCommittish, res.gitRange, and res.gitSubdir
function setGitAttrs(res, committish) {
  if (!committish) {
    res.gitCommittish = null;
    return;
  }

  // for each :: separated item:
  var _iterator = _createForOfIteratorHelper(committish.split('::')),
    _step;
  try {
    for (_iterator.s(); !(_step = _iterator.n()).done;) {
      var part = _step.value;
      // if the item has no : the n it is a commit-ish
      if (!part.includes(':')) {
        if (res.gitRange) {
          throw new Error('cannot override existing semver range with a committish');
        }
        if (res.gitCommittish) {
          throw new Error('cannot override existing committish with a second committish');
        }
        res.gitCommittish = part;
        continue;
      }
      // split on name:value
      var _part$split = part.split(':'),
        _part$split2 = _slicedToArray(_part$split, 2),
        name = _part$split2[0],
        value = _part$split2[1];
      // if name is semver do semver lookup of ref or tag
      if (name === 'semver') {
        if (res.gitCommittish) {
          throw new Error('cannot override existing committish with a semver range');
        }
        if (res.gitRange) {
          throw new Error('cannot override existing semver range with a second semver range');
        }
        res.gitRange = decodeURIComponent(value);
        continue;
      }
      if (name === 'path') {
        if (res.gitSubdir) {
          throw new Error('cannot override existing path with a second path');
        }
        res.gitSubdir = "/".concat(value);
        continue;
      }
      log.warn('npm-package-arg', "ignoring unknown key \"".concat(name, "\""));
    }
  } catch (err) {
    _iterator.e(err);
  } finally {
    _iterator.f();
  }
}
function fromFile(res, where) {
  if (!where) {
    where = process.cwd();
  }
  res.type = isFilename.test(res.rawSpec) ? 'file' : 'directory';
  res.where = where;

  // always put the '/' on where when resolving urls, or else
  // file:foo from /path/to/bar goes to /path/to/foo, when we want
  // it to be /path/to/bar/foo

  var specUrl;
  var resolvedUrl;
  var prefix = !/^file:/.test(res.rawSpec) ? 'file:' : '';
  var rawWithPrefix = prefix + res.rawSpec;
  var rawNoPrefix = rawWithPrefix.replace(/^file:/, '');
  try {
    resolvedUrl = new URL(rawWithPrefix, "file://".concat(path.resolve(where), "/"));
    specUrl = new URL(rawWithPrefix);
  } catch (originalError) {
    var er = new Error('Invalid file: URL, must comply with RFC 8089');
    throw Object.assign(er, {
      raw: res.rawSpec,
      spec: res,
      where: where,
      originalError: originalError
    });
  }

  // XXX backwards compatibility lack of compliance with RFC 8089
  if (resolvedUrl.host && resolvedUrl.host !== 'localhost') {
    var rawSpec = res.rawSpec.replace(/^file:\/\//, 'file:///');
    resolvedUrl = new URL(rawSpec, "file://".concat(path.resolve(where), "/"));
    specUrl = new URL(rawSpec);
    rawNoPrefix = rawSpec.replace(/^file:/, '');
  }
  // turn file:/../foo into file:../foo
  // for 1, 2 or 3 leading slashes since we attempted
  // in the previous step to make it a file protocol url with a leading slash
  if (/^\/{1,3}\.\.?(\/|$)/.test(rawNoPrefix)) {
    var _rawSpec = res.rawSpec.replace(/^file:\/{1,3}/, 'file:');
    resolvedUrl = new URL(_rawSpec, "file://".concat(path.resolve(where), "/"));
    specUrl = new URL(_rawSpec);
    rawNoPrefix = _rawSpec.replace(/^file:/, '');
  }
  // XXX end RFC 8089 violation backwards compatibility section

  // turn /C:/blah into just C:/blah on windows
  var specPath = decodeURIComponent(specUrl.pathname);
  var resolvedPath = decodeURIComponent(resolvedUrl.pathname);
  if (isWindows) {
    specPath = specPath.replace(/^\/+([a-z]:\/)/i, '$1');
    resolvedPath = resolvedPath.replace(/^\/+([a-z]:\/)/i, '$1');
  }

  // replace ~ with homedir, but keep the ~ in the saveSpec
  // otherwise, make it relative to where param
  if (/^\/~(\/|$)/.test(specPath)) {
    res.saveSpec = "file:".concat(specPath.substr(1));
    resolvedPath = path.resolve(homedir(), specPath.substr(3));
  } else if (!path.isAbsolute(rawNoPrefix)) {
    res.saveSpec = "file:".concat(path.relative(where, resolvedPath));
  } else {
    res.saveSpec = "file:".concat(path.resolve(resolvedPath));
  }
  res.fetchSpec = path.resolve(where, resolvedPath);
  return res;
}
function fromHostedGit(res, hosted) {
  res.type = 'git';
  res.hosted = hosted;
  res.saveSpec = hosted.toString({
    noGitPlus: false,
    noCommittish: false
  });
  res.fetchSpec = hosted.getDefaultRepresentation() === 'shortcut' ? null : hosted.toString();
  setGitAttrs(res, hosted.committish);
  return res;
}
function unsupportedURLType(protocol, spec) {
  var err = new Error("Unsupported URL Type \"".concat(protocol, "\": ").concat(spec));
  err.code = 'EUNSUPPORTEDPROTOCOL';
  return err;
}
function fromURL(res) {
  var rawSpec = res.rawSpec;
  res.saveSpec = rawSpec;
  if (rawSpec.startsWith('git+ssh:')) {
    // git ssh specifiers are overloaded to also use scp-style git
    // specifiers, so we have to parse those out and treat them special.
    // They are NOT true URIs, so we can't hand them to URL.

    // This regex looks for things that look like:
    // git+ssh://git@my.custom.git.com:username/project.git#deadbeef
    // ...and various combinations. The username in the beginning is *required*.
    var matched = rawSpec.match(/^git\+ssh:\/\/([^:#]+:[^#]+(?:\.git)?)(?:#(.*))?$/i);
    if (matched && !matched[1].match(/:[0-9]+\/?.*$/i)) {
      console.log("fromURL: matched!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ", matched);
      res.type = 'git';
      setGitAttrs(res, matched[2]);
      res.fetchSpec = matched[1];
      return res;
    }
  } else if (rawSpec.startsWith('git+file://')) {
    // URL can't handle windows paths
    rawSpec = rawSpec.replace(/\\/g, '/');
  }
  var parsedUrl = new URL(rawSpec);
  // check the protocol, and then see if it's git or not
  switch (parsedUrl.protocol) {
    case 'git:':
    case 'git+http:':
    case 'git+https:':
    case 'git+rsync:':
    case 'git+ftp:':
    case 'git+file:':
    case 'git+ssh:':
      res.type = 'git';
      setGitAttrs(res, parsedUrl.hash.slice(1));
      if (parsedUrl.protocol === 'git+file:' && /^git\+file:\/\/[a-z]:/i.test(rawSpec)) {
        // URL can't handle drive letters on windows file paths, the host can't contain a :
        res.fetchSpec = "git+file://".concat(parsedUrl.host.toLowerCase(), ":").concat(parsedUrl.pathname);
      } else {
        parsedUrl.hash = '';
        res.fetchSpec = parsedUrl.toString();
      }
      if (res.fetchSpec.startsWith('git+')) {
        res.fetchSpec = res.fetchSpec.slice(4);
      }
      break;
    case 'http:':
    case 'https:':
      res.type = 'remote';
      res.fetchSpec = res.saveSpec;
      break;
    default:
      throw unsupportedURLType(parsedUrl.protocol, rawSpec);
  }
  return res;
}
function fromAlias(res, where) {
  var subSpec = npa(res.rawSpec.substr(4), where);
  if (subSpec.type === 'alias') {
    throw new Error('nested aliases not supported');
  }
  if (!subSpec.registry) {
    throw new Error('aliases only work for registry deps');
  }
  res.subSpec = subSpec;
  res.registry = true;
  res.type = 'alias';
  res.saveSpec = null;
  res.fetchSpec = null;
  return res;
}
function fromRegistry(res) {
  res.registry = true;
  var spec = res.rawSpec.trim();
  // no save spec for registry components as we save based on the fetched
  // version, not on the argument so this can't compute that.
  res.saveSpec = null;
  res.fetchSpec = spec;
  var version = semver.valid(spec, true);
  var range = semver.validRange(spec, true);
  if (version) {
    res.type = 'version';
  } else if (range) {
    res.type = 'range';
  } else {
    if (encodeURIComponent(spec) !== spec) {
      throw invalidTagName(spec, res.raw);
    }
    res.type = 'tag';
  }
  return res;
}
resolve("", "npm:@.:", "", "");

