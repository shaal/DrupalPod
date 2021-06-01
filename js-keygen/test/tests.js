/* global QUnit,arrayToString,pemToArray,arrayToPem,encodePrivateKey,lenToArray,arrayToLen,asnEncodeLen,decodePublicKey,decodePublicKey,encodePublicKey,stringToArray,base64urlDecode,checkHighestBit,integerToOctet */

const publicSsh = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwi36YMW0eDS3NXSAM/Gcs0txeLOcZE0LQmGPYmHX09Fm1FC9AdzvDWQIfwVylqNy8G6X8+pE0TMuWav4rQjtWRls3j43LdrXkfaTZV2PNJH0ki2zaCND3cz46hBR1bSwi3O4LoN0ZHXoC4ZXoMBXKtYEOg+9jS+pE3vu2QSPruiRROTOYYvrjWx0Bwi8DJc90TmNVeqvPjewPAm4qaTdmh96jIgJQq+vAdhDHu90i31Kl3JUF94x6pzFmg8ZyXOv0Py2GtK9c5To3C33FXI8yTm/sf2Bp7fwd3MEGNcdVNqa7Tt0z2u5Jcmsws93SZuj4iVjbR6xqme9EmIa3BTB7 name",
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuew50MaphQgiuM6H7zxMspNojI2Ujf77MuWlAjmw1JxcTkfE7JKzV+9fqmESJNtnZSr3+I2dxQhJ72jttrz+2dFt9ol91muTPWzKrA8XXIBH2o7sEJ+QB8/q7S03d+Zgw6tlo+qdXLOWcKqL5MJhYwzTFEdGTSMF00cBFadcpDq1xFPygGTHRa7m3pK723nGz7TMGWmtBK2bHx+Zlp7geLK/7hl+NRG1lTyIbtdkP2T4Y81Z0bhz9kNHroUei3MFD6HvN93qMJWl3/LZZzTb++1BedNeybGKqbtsB3xp0v3c6bQy49wR3RwrAwL03AKbCwTawAufSeoXyRI+rtgZ/ name",
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpNNtjZeldPuJ5ZgcjO4i6eSJb6kiuf1sULOoWaW9acwSxAfqrmN6Hn7VGg3GK3kSKJUmBKMsF2u+ECajVBec+OTMlbL7oZrYNl2neUYsI7O0G/8lpozZjADYu8CaMqVSAeTa3ORga9Ht/qgCpqXIyEcTsFSbZ45hhaZF0fXQ0GHDCkV/ylBduQHxheCe1SPBSWIO2BwqSlGx/Q76lkL/BnGdcx7xVi3h2yNbEGxqzFuPK75VADZfWria4x09rTqvu41GWIyqzFcbB7BxNImVNh6WVk/qKTcXbfWwH8ck9Cd5bX9g36QaImZ6tW8i/bl3o75bGgP2hSWpsNx8CMVn9 name",
];
const publicSshDecoded = [
  {
    type: "ssh-rsa",
    exponent: [1, 0, 1],
    name: "name",
    key: [
      0,
      176,
      139,
      126,
      152,
      49,
      109,
      30,
      13,
      45,
      205,
      93,
      32,
      12,
      252,
      103,
      44,
      210,
      220,
      94,
      44,
      231,
      25,
      19,
      66,
      208,
      152,
      99,
      216,
      152,
      117,
      244,
      244,
      89,
      181,
      20,
      47,
      64,
      119,
      59,
      195,
      89,
      2,
      31,
      193,
      92,
      165,
      168,
      220,
      188,
      27,
      165,
      252,
      250,
      145,
      52,
      76,
      203,
      150,
      106,
      254,
      43,
      66,
      59,
      86,
      70,
      91,
      55,
      143,
      141,
      203,
      118,
      181,
      228,
      125,
      164,
      217,
      87,
      99,
      205,
      36,
      125,
      36,
      139,
      108,
      218,
      8,
      208,
      247,
      115,
      62,
      58,
      132,
      20,
      117,
      109,
      44,
      34,
      220,
      238,
      11,
      160,
      221,
      25,
      29,
      122,
      2,
      225,
      149,
      232,
      48,
      21,
      202,
      181,
      129,
      14,
      131,
      239,
      99,
      75,
      234,
      68,
      222,
      251,
      182,
      65,
      35,
      235,
      186,
      36,
      81,
      57,
      51,
      152,
      98,
      250,
      227,
      91,
      29,
      1,
      194,
      47,
      3,
      37,
      207,
      116,
      78,
      99,
      85,
      122,
      171,
      207,
      141,
      236,
      15,
      2,
      110,
      42,
      105,
      55,
      102,
      135,
      222,
      163,
      34,
      2,
      80,
      171,
      235,
      192,
      118,
      16,
      199,
      187,
      221,
      34,
      223,
      82,
      165,
      220,
      149,
      5,
      247,
      140,
      122,
      167,
      49,
      102,
      131,
      198,
      114,
      92,
      235,
      244,
      63,
      45,
      134,
      180,
      175,
      92,
      229,
      58,
      55,
      11,
      125,
      197,
      92,
      143,
      50,
      78,
      111,
      236,
      127,
      96,
      105,
      237,
      252,
      29,
      220,
      193,
      6,
      53,
      199,
      85,
      54,
      166,
      187,
      78,
      221,
      51,
      218,
      238,
      73,
      114,
      107,
      48,
      179,
      221,
      210,
      102,
      232,
      248,
      137,
      88,
      219,
      71,
      172,
      106,
      153,
      239,
      68,
      152,
      134,
      183,
      5,
      48,
      123,
    ],
  },
];

const jwkPublic = {
  alg: "RS1",
  e: "AQAB",
  ext: true,
  key_ops: ["verify"],
  kty: "RSA",
  n:
    "3PWJ6uDsFPgQo67of3IYw0Svyq95SNh9GS-2gorv68GxWIYYeAShaG_UtTf8mvf6u-VIUr54Re2FoLc78ICR3nRhFH5D1_fNaP9hkMAHBqaJ8ATiq4d7-PfeXTCi0yY0qfWkGjuPtOC3IK7WmnEkiA5qUVpy0oHFPiqoAyNynWJRDFJka00JEpM1QFyF1Tz3PEGp0XlFnClY48iJG9UqXlDgaysnG3ro2sDm8ftva0IjX1Sp7Z9FyWQci-yOYfST00wKHQd7z5-Eo3cTd5M0BhcVXeR0gprdK1TTDLZLznFJQ36HYwrUFEXvTyme6vkZfNPRb0z8KPq5Gs7dujE_cw",
};

const jwkPrivate = {
  kty: "RSA",
  kid: "juliet@capulet.lit",
  use: "enc",
  n:
    "t6Q8PWSi1dkJj9hTP8hNYFlvadM7DflW9mWepOJhJ66w7nyoK1gPNqFMSQRyO125Gp-TEkodhWr0iujjHVx7BcV0llS4w5ACGgPrcAd6ZcSR0-Iqom-QFcNP8Sjg086MwoqQU_LYywlAGZ21WSdS_PERyGFiNnj3QQlO8Yns5jCtLCRwLHL0Pb1fEv45AuRIuUfVcPySBWYnDyGxvjYGDSM-AqWS9zIQ2ZilgT-GqUmipg0XOC0Cc20rgLe2ymLHjpHciCKVAbY5-L32-lSeZO-Os6U15_aXrk9Gw8cPUaX1_I8sLGuSiVdt3C_Fn2PZ3Z8i744FPFGGcG1qs2Wz-Q",
  e: "AQAB",
  d:
    "GRtbIQmhOZtyszfgKdg4u_N-R_mZGU_9k7JQ_jn1DnfTuMdSNprTeaSTyWfSNkuaAwnOEbIQVy1IQbWVV25NY3ybc_IhUJtfri7bAXYEReWaCl3hdlPKXy9UvqPYGR0kIXTQRqns-dVJ7jahlI7LyckrpTmrM8dWBo4_PMaenNnPiQgO0xnuToxutRZJfJvG4Ox4ka3GORQd9CsCZ2vsUDmsXOfUENOyMqADC6p1M3h33tsurY15k9qMSpG9OX_IJAXmxzAh_tWiZOwk2K4yxH9tS3Lq1yX8C1EWmeRDkK2ahecG85-oLKQt5VEpWHKmjOi_gJSdSgqcN96X52esAQ",
  p:
    "2rnSOV4hKSN8sS4CgcQHFbs08XboFDqKum3sc4h3GRxrTmQdl1ZK9uw-PIHfQP0FkxXVrx-WE-ZEbrqivH_2iCLUS7wAl6XvARt1KkIaUxPPSYB9yk31s0Q8UK96E3_OrADAYtAJs-M3JxCLfNgqh56HDnETTQhH3rCT5T3yJws",
  q:
    "1u_RiFDP7LBYh3N4GXLT9OpSKYP0uQZyiaZwBtOCBNJgQxaj10RWjsZu0c6Iedis4S7B_coSKB0Kj9PaPaBzg-IySRvvcQuPamQu66riMhjVtG6TlV8CLCYKrYl52ziqK0E_ym2QnkwsUX7eYTB7LbAHRK9GqocDE5B0f808I4s",
  dp:
    "KkMTWqBUefVwZ2_Dbj1pPQqyHSHjj90L5x_MOzqYAJMcLMZtbUtwKqvVDq3tbEo3ZIcohbDtt6SbfmWzggabpQxNxuBpoOOf_a_HgMXK_lhqigI4y_kqS1wY52IwjUn5rgRrJ-yYo1h41KR-vz2pYhEAeYrhttWtxVqLCRViD6c",
  dq:
    "AvfS0-gRxvn0bwJoMSnFxYcK1WnuEjQFluMGfwGitQBWtfZ1Er7t1xDkbN9GQTB9yqpDoYaN06H7CFtrkxhJIBQaj6nkF5KKS3TQtQ5qCzkOkmxIe3KRbBymXxkb5qwUpX5ELD5xFc6FeiafWYY63TmmEAu_lRFCOJ3xDea-ots",
  qi:
    "lSQi-w9CpyUReMErP1RsBLk7wNtOvs5EQpPqmuMvqW57NBUczScEoPwmUqqabu9V0-Py4dQ57_bapoKRu1R90bvuFnU63SHWEFglZQvJDMeAvmj4sm-Fp0oYu_neotgQ0hzbI5gry7ajdYy9-2lNx_76aBZoOUu9HCJ-UsfSOI8",
};

QUnit.test("array to PEM", assert => {
  const a = [1, 2, 3];
  const p = arrayToPem(a);
  const a2 = pemToArray(p);
  assert.deepEqual(a2, a, "can you count?");
});

QUnit.test("array to String", assert => {
  const a = "ssh-rsa".split("").map(c => c.charCodeAt());
  assert.equal(arrayToString(pemToArray(arrayToPem(a))), "ssh-rsa");
});

QUnit.test("lenToArray", assert => {
  const a = 66051;
  assert.deepEqual(lenToArray(a), [0, 1, 2, 3]);
});

QUnit.test("arrayToLen", assert => {
  const a = [0, 1, 2, 3];
  assert.deepEqual(arrayToLen(a), 66051);
});

publicSsh.forEach((pub, index) => {
  QUnit.test(`decoding ssh public key ${index}`, assert => {
    const key = decodePublicKey(pub);
    assert.equal(key.type, "ssh-rsa", "type");
    assert.equal(key.name, "name", "name");
    if (index === 0) {
      assert.deepEqual(key.key, publicSshDecoded[0].key, "key");
    }
  });
});

QUnit.test("Encoding ssh public key", assert => {
  const result = encodePublicKey(jwkPublic, "name");
  assert.equal(
    result,
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDc9Ynq4OwU+BCjruh/chjDRK/Kr3lI2H0ZL7aCiu/rwbFYhhh4BKFob9S1N/ya9/q75UhSvnhF7YWgtzvwgJHedGEUfkPX981o/2GQwAcGponwBOKrh3v4995dMKLTJjSp9aQaO4+04LcgrtaacSSIDmpRWnLSgcU+KqgDI3KdYlEMUmRrTQkSkzVAXIXVPPc8QanReUWcKVjjyIkb1SpeUOBrKycbeujawObx+29rQiNfVKntn0XJZByL7I5h9JPTTAodB3vPn4SjdxN3kzQGFxVd5HSCmt0rVNMMtkvOcUlDfodjCtQURe9PKZ7q+Rl809FvTPwo+rkazt26MT9z name"
  );
});

QUnit.test("base64url", assert => {
  const result = stringToArray(base64urlDecode(jwkPublic.n));
  assert.equal(result.length, 256);
});

QUnit.test("high bit", assert => {
  assert.deepEqual(checkHighestBit([0x80]), [0x00, 0x80]);
  assert.deepEqual(checkHighestBit([0x0f]), [0x0f]);
});

QUnit.test("jwk", assert => {
  const sshkey = encodePublicKey(jwkPublic, "name");
  assert.deepEqual(stringToArray(base64urlDecode(jwkPublic.e)), [1, 0, 1]);
  assert.equal(
    sshkey,
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDc9Ynq4OwU+BCjruh/chjDRK/Kr3lI2H0ZL7aCiu/rwbFYhhh4BKFob9S1N/ya9/q75UhSvnhF7YWgtzvwgJHedGEUfkPX981o/2GQwAcGponwBOKrh3v4995dMKLTJjSp9aQaO4+04LcgrtaacSSIDmpRWnLSgcU+KqgDI3KdYlEMUmRrTQkSkzVAXIXVPPc8QanReUWcKVjjyIkb1SpeUOBrKycbeujawObx+29rQiNfVKntn0XJZByL7I5h9JPTTAodB3vPn4SjdxN3kzQGFxVd5HSCmt0rVNMMtkvOcUlDfodjCtQURe9PKZ7q+Rl809FvTPwo+rkazt26MT9z name"
  );
});

[
  { len: 0x01, octet: [0x01] },
  { len: 0x104, octet: [0x01, 0x04] },
  { len: 0xff32, octet: [0xff, 0x32] },
  { len: 0x1000000, octet: [1, 0, 0, 0] },
  { len: 0x7fffffff, octet: [0x7f, 0xff, 0xff, 0xff] }, // biggest one
].forEach(t => {
  QUnit.test(`Integer to Octet: ${t.len}`, assert => {
    assert.deepEqual(integerToOctet(t.len), t.octet, t.len);
  });
});

[
  { len: 0x34, asn: [0x34] },
  { len: 256, asn: [0x80 + 2, 0x01, 0x00] },
  { len: 0x134, asn: [0x80 + 2, 0x01, 0x34] },
  { len: 0x12345, asn: [0x80 + 3, 0x01, 0x23, 0x45] },
  { len: 0x123456, asn: [0x80 + 3, 0x12, 0x34, 0x56] },
].forEach(t => {
  QUnit.test(`ASN.1 Len Writing: ${t.len}`, assert => {
    assert.deepEqual(asnEncodeLen(t.len), t.asn, t.len);
  });
});

QUnit.test("encodePrivateKey", assert => {
  encodePrivateKey(jwkPrivate);
  // console.log(encoded);
  assert.ok(true);
});
