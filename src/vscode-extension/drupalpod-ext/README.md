# DrupalPod Extension

Provides a Contribution Guide for using [DrupalPod](https://github.com/shaal/DrupalPod) on startup or by using the `drupalpod.ext-start` command in the Command Palette.

The extension should be installed automatically by GitPod (once development is complete).

To prevent the Contribution Guide from displaying when you start your workspace, you can add `"drupalpod.hideOnStartup": true` to `.vscode/settings.json`.

## Contribute

* Run `yarn install`
* Make your awesome changes and unit tests.
* Run `yarn package` to build the VISX file in the current working directory.
* Uninstall the extension completely from your workspace:
    * Press the "Extensions" button on the left.
    * Press the "Manage" button (Gear icon).
    * Click the "Uninstall" option from the context menu.
* Reload Gitpod
* Install the extension by VISX
    * Press the "Extensions" button on the left.
    * Press the "Views and More Actions..." button ("..." icon).
    * Click "Install from VISX..." option from the context menu.
    * Browse to or provide the directory path `/workspace/DrupalPod/src/vscode-extension/drupalpod-ext/ and choose the VISX file to install.

## Publish

TODO: Should be done via a GitHub Action.

* Update the version in package.json
* Package a new VISX
* Publish the VISX on OpenVsx
