"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = IssueList;
var React = window.React;
function csv(string) {
  return string.split(/\s*,\s*/);
}
function IssueList(_ref) {
  var issues = _ref.issues;
  if (!issues) {
    return null;
  }
  if (typeof issues === 'string') {
    issues = csv(issues);
  }
  var links = issues.reduce(function (memo, issue, i) {
    return memo.concat(i > 0 && i < issues.length ? ', ' : null, <a href={'https://github.com/facebook/react/issues/' + issue} key={issue}>
        {issue}
      </a>);
  }, []);
  return <span>{links}</span>;
}