FROM gitpod/workspace-full
SHELL ["/bin/bash", "-c"]

RUN sudo apt-get -qq update
# Install required libraries for Projector + PhpStorm
RUN sudo apt-get -qq install -y python3 python3-pip libxext6 libxrender1 libxtst6 libfreetype6 libxi6
# Install Projector
RUN pip3 install projector-installer
# Install PhpStorm
RUN mkdir -p ~/.projector/configs  # Prevents projector install from asking for the license acceptance
RUN projector install 'PhpStorm 2021.1' --no-auto-run

# Install GitUI (terminal-ui for git)
RUN brew install gitui

# Install ddev
RUN brew update && brew install drud/ddev/ddev

# Install latest composer
RUN /workspace/mygitpod/.gitpod/install-latest-composer.sh

###
### Initiate a rebuild of Gitpod's image by updating this comment #1
###
