#!/usr/bin/env bash

# Check if ~/.ssh/id_rsa already exist

if [ -f ~/.ssh/id_rsa ]; then
      echo "No need to setup a key, SSH key already exists."
else
      if [ -z "$DRUPAL_SSH_KEY" ]; then
            # No environment variable set, check if it was already created during this session
            if [ ! -f /workspace/id_rsa ] ; then
                  # Create ssh key pairing + instructions to paste public key in drupal.org
                  # TODO: force passphrase
                  read -s -p "Passphrase?" passphrasevar
                  printf "\n"
                  echo "Setting a new SSH key"
                  ssh-keygen -q -t rsa -b 4096 -f ~/.ssh/id_rsa -P "$passphrasevar"
                  .gitpod/drupal-instructions.sh
                  echo "Follow instructions for copying public key to Drupal"
                  echo "Test SSH by running .gitpod/confirm-ssh-setup.sh"

            else
                  # Edge case where user already setup key in workspace that timed out.
                  echo "No need to setup a key, SSH key found."
                  cp /workspace/id_rsa ~/.ssh/.
            fi
      else
            echo "Setting SSH key from environment variable"
            mkdir -p ~/.ssh
            printenv DRUPAL_SSH_KEY | sed 's/_/=/g' >  ~/.ssh/id_rsa
      fi
fi
