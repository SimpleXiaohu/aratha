"use strict";

// huzi add
function unicodeToHex(code) {
    return "\\u{" + code.toString(16) + "}";
}
exports.escapeString = function(s) {
    // huzi add, for ostrich \\ parse
    // s = s.replace(/\\/g, "\\\\");
    // s = s.replace(/\r/g, "\\r");
    // s = s.replace(/\n/g, "\\n");
    // // s = s.replace(/\b/g, "\\b");
    // s = s.replace(/\f/g, "\\f");
    // s = s.replace(/\t/g, "\\t");
    // s = s.replace(/\v/g, "\\v");
    s = s.replace(/[^\x20-\x7E]/g, (c) => {
        const code = c.charCodeAt(0);
        if (code <= 255) {
            return unicodeToHex(code);
        } else {
            return unicodeToHex(code);
        }
    });
    s = s.replace(/"/g, '""');
    return '"' + s + '"';
};
