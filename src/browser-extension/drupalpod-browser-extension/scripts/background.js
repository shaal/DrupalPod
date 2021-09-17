chrome.runtime.onMessage.addListener((request, sender, sendResponse)=>{
  if (request.message === 'fetch-drupalpod-repo') {
    (async function responding() {
      sendResponse({message: await getDrupalPodRepo()});
    })();
  } else if (request.message === 'set-drupalpod-repo') {
    setDrupalPodRepo(request.url);
    sendResponse({message: 'great success'});
  }
  return true;
});

async function getDrupalPodRepo() {
  var p = new Promise((resolve, reject) => {
    chrome.storage.sync.get(['drupalpod_repo'], (options)=>{
      resolve(options.drupalpod_repo);
    })
  });

  return await p;
}

function setDrupalPodRepo(url) {
    chrome.storage.sync.set({'drupalpod_repo': url });
}

// set default
setDrupalPodRepo('https://github.com/shaal/drupalpod');
