# DrupalPod

Please provide [feedback, bug reports and feature requests through Github issues](https://github.com/shaal/DrupalPod/issues/new/choose).

## How do I use it?
1. Download the browser extension - [Chrome](https://chrome.google.com/webstore/detail/drupalpod-helper-extensio/pjfjhkcfkhbemnbpkakjhmboacefmjjl?hl=en
) or [Firefox](https://addons.mozilla.org/en-US/firefox/addon/drupalpod).
1. Go to any issue page on Drupal.org (core, module, or theme).
1. Click on the DrupalPod extension.
1. Choose a patch / issue fork / branch you want to use.
1. A full development environment will open.

<br>

## Project Structure

This project allows you to work on Drupal contributions with a familiar setup of a "normal" Drupal website.

* You can install any additional packages using `ddev composer`.
* You can run Drush commands, using `ddev drush <command>`.

\* Working on Drupal core issue is unique, the location of the actual Git repo for core is `repos/drupal` (symlinked to `/web/core`)

<br>

## Main Directories

* Main directory `/web`
* Module directory `/web/modules/contrib`
* Theme directory `/web/themes/contrib`

<br>

## Secret Sauce

* [Gitpod](https://www.gitpod.io) - development environment in the cloud
* [Ddev](https://ddev.readthedocs.io/en/stable) - easy setup for PHP projects using Docker
* [DrupalPod](https://chrome.google.com/webstore/detail/drupalpod-helper-extensio/pjfjhkcfkhbemnbpkakjhmboacefmjjl?hl=en
) Browser Extension
* [Drupal Core Development Project](https://github.com/joachim-n/drupal-core-development-project)

<br>

## Notes
In order to push code there is a **one time** set up for SSH keys.
<br>

In Gitpod workspace
Run:

1. `.gitpod/drupal/ssh/01-setup-private-ssh.sh`
<br>
Follow the instructions on the screen.

1. `.gitpod/drupal/ssh/03-confirm-ssh-setup.sh`
<br>
It validates your SSH keys and stores them for future use.


**P.s.**

This is a temporary requirement, until the Drupal Association can get self-hosted Gitlab instance integrated with Gitpod.

[WIP - making a friendlier interactive dialog](https://github.com/shaal/DrupalPod/issues/4).

## Thank you

* [Randy Fay](https://github.com/rfay)
* [Joachim](https://github.com/joachim-n)

---


![DrupalPod-logo](https://user-images.githubusercontent.com/22901/122864786-40253c00-d2f3-11eb-959b-61fb6871e3f4.png)
