#!/usr/bin/env bash

SSH_SETUP=true

# Add git.drupal.org to known_hosts
mkdir -p ~/.ssh
ssh-keyscan git.drupal.org >> ~/.ssh/known_hosts

# Validate private SSH key in Gitpod with public SSH key in drupal.org
if ssh -T git@git.drupal.org; then
      read -r -p "SSH key was already confirmed with Drupal.org, are you sure you want to recreate SSH key? [y/N]" setup_ssh
      if [ "$setup_ssh" != "y" ] && [ "$setup_ssh" != "Y" ]; then
            SSH_SETUP=false
      fi
fi

if [ "$SSH_SETUP" ]; then
      # Create ssh key pairing + instructions to paste public key in drupal.org
      ssh-keygen -q -t rsa -b 4096 -f ~/.ssh/id_rsa
      .gitpod/drupal/ssh/03-generate-drupal-ssh-instructions.sh
      echo "Follow instructions for copying public key to Drupal"
      echo "Test SSH by running .gitpod/drupal/ssh/04-confirm-ssh-setup.sh"
fi
