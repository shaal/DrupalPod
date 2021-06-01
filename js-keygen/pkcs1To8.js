/* eslint no-bitwise: 0 */

function wrap(text, len) {
  const length = len || 72;
  let result = "";
  for (let i = 0; i < text.length; i += length) {
    result += text.slice(i, i + length);
    result += "\n";
  }
  return result;
}

function pemPrivateKey(key) {
  return `-----BEGIN PRIVATE KEY-----\n${wrap(key, 64)}-----END PRIVATE KEY-----`;
}

function stripPemFormatting(str) {
  return str
    .replace(/^-----BEGIN (?:RSA )?(?:PRIVATE|PUBLIC) KEY-----$/m, "")
    .replace(/^-----END (?:RSA )?(?:PRIVATE|PUBLIC) KEY-----$/m, "")
    .replace(/[\n\r]/g, "");
}
function arrayToPem(a) {
  return window.btoa(a.map(c => String.fromCharCode(c)).join(""));
}

function stringToArray(s) {
  return s.split("").map(c => c.charCodeAt());
}

function pemToArray(pem) {
  return stringToArray(window.atob(pem));
}

const prefix = [
  0x30,
  0x82,
  0x04,
  0xbc,
  0x02,
  0x01,
  0x00,
  0x30,
  0x0d,
  0x06,
  0x09,
  0x2a,
  0x86,
  0x48,
  0x86,
  0xf7,
  0x0d,
  0x01,
  0x01,
  0x01,
  0x05,
  0x00,
  0x04,
  0x82,
  0x04,
  0xa6,
];

function pkcs1To8(privateKeyPkcs1Pem) {
  const pem = stripPemFormatting(privateKeyPkcs1Pem);
  const privateKeyPkcs1Array = pemToArray(pem);
  const prefixPkcs8 = prefix.concat(privateKeyPkcs1Array);
  const privateKeyPkcs8Pem = arrayToPem(prefixPkcs8);
  const pkcs8Pem = pemPrivateKey(privateKeyPkcs8Pem);
  return pkcs8Pem;
}

// crypto.subtle.importKey(
//   "spki",
//   keyTextBuffer,
//   {
//     name: "RSASSA-PKCS1-v1_5",
//     hash: { name: "SHA-256" },
//   },
//   true,
//   ["verify"]
// );

module.exports = { pkcs1To8 };
