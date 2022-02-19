#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

# Add git.drupal.org to known_hosts
mkdir -p ~/.ssh
host=git.drupal.org
SSHKey=$(ssh-keyscan $host 2> /dev/null)
echo "$SSHKey" >> ~/.ssh/known_hosts

# Ask for SSH keyphrase only once
if ssh-add -l > /dev/null ; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add -q ~/.ssh/id_rsa
fi

# Validate private SSH key in Gitpod with public SSH key in drupal.org
if ssh -T git@git.drupal.org; then
    echo "Setup was succesful, saving your private key in Gitpod"
    # Set private SSH key as Gitpod variable anvironment
    gp env "DRUPAL_SSH_KEY=$(cat ~/.ssh/id_rsa)" > /dev/null
    # Copy key to /workspace in case this workspace times out
    cp ~/.ssh/id_rsa /workspace/.
    # Set repo remote branch to SSH (in case it was added as HTTPS)
    .gitpod/drupal/ssh/05-set-repo-as-ssh.sh
else
    if [ ! -f ~/.ssh/id_rsa.pub ] ; then
        echo "Setup failed, create private key again"
        rm -f /workspace/id_rsa
        rm -rf ~/.ssh
        .gitpod/drupal/ssh/02-setup-private-ssh.sh
    else
        echo "Setup failed, please confirm you copied public key to Drupal"
        .gitpod/drupal/ssh/03-generate-drupal-ssh-instructions.sh
    fi
fi
