#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

# Create a phpstorm command
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/utils/phpstorm.template.sh /usr/local/bin/phpstorm

# Create a preview command
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/utils/preview.template.sh /usr/local/bin/preview

# Create a protect-my-git command
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/utils/protect-my-git.template.sh /usr/local/bin/protect-my-git

# Create php command (run php inside ddev container)
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/utils/ddev-php.template.sh /usr/local/bin/php

# Create drush command (run drush inside ddev container)
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/utils/ddev-drush.template.sh /usr/local/bin/drush

# Create yarn command (run yarn inside ddev container)
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/utils/ddev-yarn.template.sh /usr/local/bin/yarn

# Create composer command (run composer inside ddev container)
sudo cp "${GITPOD_REPO_ROOT}"/.gitpod/utils/ddev-composer.template.sh /usr/local/bin/composer
