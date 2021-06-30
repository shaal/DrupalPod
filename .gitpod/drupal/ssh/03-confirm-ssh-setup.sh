#!/usr/bin/env bash

# Add git.drupal.org to known_hosts
ssh-keyscan git.drupal.org >> ~/.ssh/known_hosts

# Validate private SSH key in Gitpod with public SSH key in drupal.org
if ssh -T git@git.drupal.org; then
    echo "Setup was succesful, saving your private key in Gitpod"
    # Set Gitpod variable anvironment
    # Due to bug in gp env command, replace `=` with `_` - https://github.com/gitpod-io/gitpod/issues/4493
    DRUPAL_SSH_KEY=$(sed 's/=/_/g' ~/.ssh/id_rsa)
    gp env "DRUPAL_SSH_KEY=$DRUPAL_SSH_KEY" > /dev/null
    # Copy key to /workspace in case this workspace times out
    cp ~/.ssh/id_rsa /workspace/.
else
    if [ ! -f ~/.ssh/id_rsa.pub ] ; then
        echo "Setup failed, create private key again"
        rm -f /workspace/id_rsa
        rm -rf ~/.ssh
        .gitpod/drupal/ssh/01-setup-private-ssh.sh
    else
        echo "Setup failed, please confirm you copied public key to Drupal"
        .gitpod/drupal/ssh/02-generate-drupal-ssh-instructions.sh
    fi
fi
