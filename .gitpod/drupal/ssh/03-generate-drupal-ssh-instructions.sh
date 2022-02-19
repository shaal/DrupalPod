#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

# create instructions file with user's public key
cat ~/.ssh/id_rsa.pub > /workspace/public_key.md
cat .gitpod/drupal/ssh/instructions-template.md > /workspace/drupal-public-key-setup.md
cat ~/.ssh/id_rsa.pub >> /workspace/drupal-public-key-setup.md

gp open /workspace/drupal-public-key-setup.md
