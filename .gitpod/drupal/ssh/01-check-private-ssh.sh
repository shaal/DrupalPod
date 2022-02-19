#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

# Check if ~/.ssh/id_rsa already exist
if [ -f ~/.ssh/id_rsa ]; then
      echo "No need to setup a key, SSH key already exists."
else
      if [ -z "$DRUPAL_SSH_KEY" ]; then
            # DRUPAL_SSH_KEY environment variable is not set, check if SSH ley was create during this session
            if [ -f /workspace/id_rsa ] ; then
                  # Edge case where user already setup key in workspace that timed out.
                  echo "No need to setup a key, SSH key found."
                  mkdir -p ~/.ssh
                  cp /workspace/id_rsa ~/.ssh/.
            fi
      else
            echo "Setting SSH key from environment variable"
            mkdir -p ~/.ssh
            printenv DRUPAL_SSH_KEY > ~/.ssh/id_rsa
            chmod 600 ~/.ssh/id_rsa
      fi
      # Ask for SSH keyphrase only once
      if ssh-add -l > /dev/null ; then
            eval "$(ssh-agent -s)" > /dev/null
            ssh-add -q ~/.ssh/id_rsa
      fi
fi
