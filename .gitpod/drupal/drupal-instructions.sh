#!/usr/bin/env bash

# create instructions file with user's public key
cat ~/.ssh/id_rsa.pub > /workspace/public_key.md
cat .gitpod/instructions-template.md > /workspace/drupal-public-key-setup.md
cat ~/.ssh/id_rsa.pub >> /workspace/drupal-public-key-setup.md
echo '```' >> /workspace/drupal-public-key-setup.md

gp open /workspace/drupal-public-key-setup.md