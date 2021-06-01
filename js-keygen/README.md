# Generate a ssh keypair using the webcrypto API

See the live demo at https://js-keygen.surge.sh

For some explanation see http://blog.roumanoff.com/2015/09/using-webcrypto-api-to-generate-keypair.html

There is no way to generate a ssh keypair on a chromebook, but we have access to chrome and the webcrypto API. I had to do all sorts of gymnastics to convert the generated keypair to something that can be consummed by SSH.

* I had to learn about the WebCrypto API - which was the initial goal
* I had to learn about JWK
* I had to leanr about base64url encoding (thanks JWK) and how to convert it to and form base64 encoding
* I had to learn about ASN.1 to encode the private key for OpenSSH
* I had to lean about the open SSH public format to encode the public key for OpenSSH

The end result is a usable single page app that will locally generate a keypair you can save to local drive. Allowing you to do that straight from chrome on a chrome book.

Everywhere else, you should have access to ssh-keygen which is the recommended way to generate keypair for SSH.

## How to convert from OpenSSH public key format to PEM

see https://js-keygen.surge.sh/convert.html for how to convert.
