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

function pemPublicKey(key) {
  return `---- BEGIN RSA PUBLIC KEY ----\n${wrap(key, 65)}---- END RSA PUBLIC KEY ----`;
}

function integerToOctet(n) {
  const result = [];
  for (let i = n; i > 0; i >>= 8) {
    result.push(i & 0xff);
  }
  return result.reverse();
}

function asnEncodeLen(n) {
  let result = [];
  if (n >> 7) {
    result = integerToOctet(n);
    result.unshift(0x80 + result.length);
  } else {
    result.push(n);
  }
  return result;
}

function checkHighestBit(v) {
  if (v[0] >> 7 === 1) {
    v.unshift(0); // add leading zero if first bit is set
  }
  return v;
}

function asn1Int(int) {
  const v = checkHighestBit(int);
  const len = asnEncodeLen(v.length);
  return [0x02].concat(len, v); // int tag is 0x02
}

function asn1Seq(seq) {
  const len = asnEncodeLen(seq.length);
  return [0x30].concat(len, seq); // seq tag is 0x30
}

function arrayToPem(a) {
  return window.btoa(a.map(c => String.fromCharCode(c)).join(""));
}

function arrayToString(a) {
  return String.fromCharCode.apply(null, a);
}

function stringToArray(s) {
  return s.split("").map(c => c.charCodeAt());
}

function pemToArray(pem) {
  return stringToArray(window.atob(pem));
}

function arrayToLen(a) {
  let result = 0;
  for (let i = 0; i < a.length; i += 1) {
    result = result * 256 + a[i];
  }
  return result;
}

function decodePublicKey(s) {
  const split = s.split(" ");
  const prefix = split[0];
  if (prefix !== "ssh-rsa") {
    throw new Error(`Unknown prefix: ${prefix}`);
  }
  const buffer = pemToArray(split[1]);
  const nameLen = arrayToLen(buffer.splice(0, 4));
  const type = arrayToString(buffer.splice(0, nameLen));
  if (type !== "ssh-rsa") {
    throw new Error(`Unknown key type: ${type}`);
  }
  const exponentLen = arrayToLen(buffer.splice(0, 4));
  const exponent = buffer.splice(0, exponentLen);
  const keyLen = arrayToLen(buffer.splice(0, 4));
  const key = buffer.splice(0, keyLen);
  return { type, exponent, key, name: split[2] };
}

function publicSshToPem(publicKey) {
  const { key, exponent } = decodePublicKey(publicKey);
  const seq = [key, exponent].map(asn1Int).reduce((acc, a) => acc.concat(a));
  return pemPublicKey(arrayToPem(asn1Seq(seq)));
}

module.exports = { publicSshToPem };
