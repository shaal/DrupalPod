#!/usr/bin/env bash

# Check if ~/.ssh/id_rsa already exist
if [ -f ~/.ssh/id_rsa ]; then
      echo "No need to setup a key, SSH key already exists."
else
      if [ -z "$DRUPAL_SSH_KEY" ]; then
            # No environment variable set, check if it was already created during this session
            if [ ! -f /workspace/id_rsa ] ; then
                  read -r -p "You cannot push code without SSH key. Would you like to set it up now? [Y/n]" setup_ssh
                  if [ "$setup_ssh" == "" ] || [ "$setup_ssh" == "y" ] || [ "$setup_ssh" == "Y" ]; then
                        # Create ssh key pairing + instructions to paste public key in drupal.org
                        ssh-keygen -q -t rsa -b 4096 -f ~/.ssh/id_rsa
                        .gitpod/drupal/drupal-instructions.sh
                        echo "Follow instructions for copying public key to Drupal"
                        echo "Test SSH by running .gitpod/drupal/confirm-ssh-setup.sh"
                  else
                        # User did not want to set SSH key, exit
                        exit 0;
                  fi
            else
                  # Edge case where user already setup key in workspace that timed out.
                  echo "No need to setup a key, SSH key found."
                  mkdir -p ~/.ssh
                  cp /workspace/id_rsa ~/.ssh/.
            fi
      else
            echo "Setting SSH key from environment variable"
            mkdir -p ~/.ssh
            printenv DRUPAL_SSH_KEY | sed 's/_/=/g' >  ~/.ssh/id_rsa
            chmod 600 ~/.ssh/id_rsa
      fi
fi
