#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

SSH_SETUP_REQUIRED=true

# Add git.drupal.org to known_hosts
mkdir -p ~/.ssh
host=git.drupal.org
SSHKey=$(ssh-keyscan $host 2> /dev/null)
echo "$SSHKey" >> ~/.ssh/known_hosts

# Validate private SSH key in Gitpod with public SSH key in drupal.org
if ssh -T git@git.drupal.org; then
      read -r -p "SSH key was already confirmed with Drupal.org, are you sure you want to recreate SSH key? [y/N]" setup_ssh
      if [ "$setup_ssh" != "y" ] && [ "$setup_ssh" != "Y" ]; then
            SSH_SETUP_REQUIRED=false
      fi
fi

if $SSH_SETUP_REQUIRED; then
      # Create ssh key pairing + instructions to paste public key in drupal.org
      ssh-keygen -q -t rsa -b 4096 -f ~/.ssh/id_rsa
      .gitpod/drupal/ssh/03-generate-drupal-ssh-instructions.sh
      echo "Follow instructions for copying public key to Drupal"
      echo "Test SSH by running .gitpod/drupal/ssh/04-confirm-ssh-setup.sh"
fi
