function getDrupalPodRepo() {
  const drupalpod_repo_input = document.querySelector('#drupalpod-repo');
  chrome.runtime.sendMessage({message: 'fetch-drupalpod-repo'}, (response) => {
    if (response.message) {
      drupalpod_repo_input.value = response.message;
    } else {
      drupalpod_repo_input.value = drupalpod_repo_input.placeholder;
    }
  });
}

function setDrupalPodRepo(url) {
  chrome.runtime.sendMessage({message: 'set-drupalpod-repo', url: url}, (response) => {
    return response.message;
  });
}

// Initiate display form
document.addEventListener('DOMContentLoaded', () => {
  // Read initial value from storage
  getDrupalPodRepo();
  document.getElementById('form').addEventListener('submit', () => {
    const drupalpod_repo_input = document.querySelector('#drupalpod-repo');
    const drupalpod_repo = drupalpod_repo_input.value || drupalpod_repo_input.placeholder;

    setDrupalPodRepo(drupalpod_repo);
    document.getElementById('form-status').innerText = 'Value saved';
  });
});
