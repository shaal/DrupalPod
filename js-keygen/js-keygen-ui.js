var generateKeyPair;

function copy(id) {
  return function() {
    var ta = document.querySelector(id);
    ta.focus();
    ta.select();
    try {
      var successful = document.execCommand("copy");
      var msg = successful ? "successful" : "unsuccessful";
      console.log("Copy key command was " + msg);
    } catch (err) {
      console.log("Oops, unable to copy");
    }
    window.getSelection().removeAllRanges();
    ta.blur();
  };
}

function buildHref(data) {
  return "data:application/octet-stream;charset=utf-8;base64," + window.btoa(data);
}

document.addEventListener("DOMContentLoaded", function() {
  document.querySelector("#savePrivate").addEventListener("click", function() {
    document.querySelector("a#private").click();
  });
  document.querySelector("#copyPrivate").addEventListener("click", copy("#privateKey"));
  document.querySelector("#savePublic").addEventListener("click", function() {
    document.querySelector("a#public").click();
  });
  document.querySelector("#copyPublic").addEventListener("click", copy("#publicKey"));

  document.querySelector("#generate").addEventListener("click", function() {
    var name = document.querySelector("#name").value || "name";
    document.querySelector("a#private").setAttribute("download", name + "_rsa");
    document.querySelector("a#public").setAttribute("download", name + "_rsa.pub");

    var alg = document.querySelector("#alg").value || "RSASSA-PKCS1-v1_5";
    var size = parseInt(document.querySelector("#size").value || "2048", 10);
    generateKeyPair(alg, size, name)
      .then(function(keys) {
        document.querySelector("#private").setAttribute("href", buildHref(keys[0]));
        document.querySelector("#public").setAttribute("href", buildHref(keys[1]));
        document.querySelector("#privateKey").textContent = keys[0];
        document.querySelector("#publicKey").textContent = keys[1];
        document.querySelector("#result").style.display = "block";
      })
      .catch(function(err) {
        console.error(err);
      });
  });
});
