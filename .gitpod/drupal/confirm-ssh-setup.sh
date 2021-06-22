#!/usr/bin/env bash

# Only if ssh connection works (private and public keys match) - save Gitpod environment variable

ssh -T git@git.drupal.org
if [ $? -eq 0 ]; then
    echo "Setup was succesful, saving your private key in Gitpod"
    # Set Gitpod variable anvironment

    # Due to bug in gp env command, replace `=` with `_`
    DRUPAL_SSH_KEY=$(sed 's/=/_/g' ~/.ssh/id_rsa)
    gp env "DRUPAL_SSH_KEY=$DRUPAL_SSH_KEY" > /dev/null
    # Copy key to /workspace in case this workspace times out
    cp ~/.ssh/id_rsa /workspace/.
else
    if [ ! -f ~/.ssh/id_rsa.pub ] ; then
        echo "Setup failed, create private key again"
        rm -f /workspace/id_rsa
        rm -rf ~/.ssh
        .gitpod/drupal/setup-private-ssh.sh
    else
        echo "Setup failed, please confirm you copied public key to Drupal"
        .gitpod/drupal/drupal-instructions.sh
    fi
fi