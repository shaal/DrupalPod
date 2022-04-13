#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

cd "${GITPOD_REPO_ROOT}"/.gitpod/utils/script-templates || exit

# Create a phpstorm command
sudo cp phpstorm.template.sh /usr/local/bin/phpstorm

# Create a preview command
sudo cp preview.template.sh /usr/local/bin/preview

# Create a protect-my-git command
sudo cp protect-my-git.template.sh /usr/local/bin/protect-my-git

# Create php command (run php inside ddev container)
sudo cp ddev-php.template.sh /usr/local/bin/php

# Create drush command (run drush inside ddev container)
sudo cp ddev-drush.template.sh /usr/local/bin/drush

# Create yarn command (run yarn inside ddev container)
sudo cp ddev-yarn.template.sh /usr/local/bin/yarn

# Create composer command (run composer inside ddev container)
sudo cp ddev-composer.template.sh /usr/local/bin/composer

# Create node command (run composer inside ddev container)
sudo cp ddev-node.template.sh /usr/local/bin/node

# Create nvm command (run composer inside ddev container)
sudo cp ddev-nvm.template.sh /usr/local/bin/nvm

# Create npx command (run composer inside ddev container)
sudo cp ddev-npx.template.sh /usr/local/bin/npx
