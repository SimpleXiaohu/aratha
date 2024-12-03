"use strict";

<<<<<<< HEAD
// huzi add
=======
>>>>>>> ostrich-adaptation
function unicodeToHex(code) {
    return "\\u{" + code.toString(16) + "}";
}
exports.escapeString = function (s) {
    // replace all characters that are not printable ASCII characters
    // to unicode representation 
    s = s.replace(/[^\x20-\x7E]/g, (c) => {
        const code = c.charCodeAt(0);
        return unicodeToHex(code);
    });
    s = s.replace(/"/g, '""');
    return '"' + s + '"';
};
