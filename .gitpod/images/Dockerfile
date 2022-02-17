FROM gitpod/workspace-base as workspace-base
SHELL ["/bin/bash", "-c"]
# ENV HOMEBREW_INSTALL_FROM_API=true

RUN sudo apt-get -qq update
# RUN sudo apt-get -qq install -y apt-utils

# Install dialog (interactive script)
RUN sudo apt-get -qq install -y dialog

# code from https://github.com/gitpod-io/workspace-images/blob/master/chunks/tool-docker/Dockerfile
# USER root

# # Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
# ENV TRIGGER_REBUILD=1

# # https://docs.docker.com/engine/install/ubuntu/
# RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
#     && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
#     && apt update \
#     && install-packages docker-ce docker-ce-cli containerd.io

# RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-$(uname -m) \
#     && chmod +x /usr/bin/slirp4netns

# RUN curl -o /usr/local/bin/docker-compose -fsSL https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-$(uname -m) \
#     && chmod +x /usr/local/bin/docker-compose

# # https://github.com/wagoodman/dive
# RUN curl -o /tmp/dive.deb -fsSL https://github.com/wagoodman/dive/releases/download/v0.10.0/dive_0.10.0_linux_amd64.deb \
#     && apt install /tmp/dive.deb \
#     && rm /tmp/dive.deb
# RUN curl -fsSL https://get.docker.com -o get-docker.sh
# RUN sudo sh get-docker.sh
USER gitpod

# Install required libraries for Projector + PhpStorm
# https://github.com/JetBrains/projector-installer

# RUN sudo apt-get -qq install -y python3 python3-pip
# RUN sudo apt-get -qq install -y python3-cryptography
# RUN python3 -m pip install -U pip
# RUN sudo apt-get -qq install -y less libxext6 libxrender1 libxtst6 libfreetype6 libxi6
# # Install Projector
# RUN pip3 install projector-installer
# # Install PhpStorm
# RUN mkdir -p ~/.projector/configs  # Prevents projector install from asking for the license acceptance
# RUN .local/bin/projector install 'PhpStorm 2020.3.3' --no-auto-run

# Install additional packages
# RUN sudo apt-get -qq install -y patchutils telnet netcat

### Homebrew ###
# LABEL dazzle/layer=tool-brew
# LABEL dazzle/test=tests/tool-brew.yaml
# USER gitpod
# # Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
# ENV TRIGGER_BREW_REBUILD=4
# RUN mkdir -p ~/.cache && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# ENV PATH=$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/
# # ENV MANPATH="$MANPATH:/home/linuxbrew/.linuxbrew/share/man"
# # ENV INFOPATH="$INFOPATH:/home/linuxbrew/.linuxbrew/share/info"
# ENV HOMEBREW_NO_AUTO_UPDATE=1

### Node.js ###
# USER gitpod
# ENV NODE_VERSION=16.13.2
# # from https://github.com/gitpod-io/workspace-images/blob/master/chunks/lang-node/Dockerfile
# RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | PROFILE=/dev/null bash \
#     && bash -c ". .nvm/nvm.sh \
#     && nvm install v${NODE_VERSION} \
#     && nvm alias default v${NODE_VERSION} \
#     && npm install -g typescript yarn node-gyp" \
#     && echo ". ~/.nvm/nvm-lazy.sh"  >> /home/gitpod/.bashrc.d/50-node
# # above, we are adding the lazy nvm init to .bashrc, because one is executed on interactive shells, the other for non-interactive shells (e.g. plugin-host)
# COPY --chown=gitpod:gitpod nvm-lazy.sh /home/gitpod/.nvm/nvm-lazy.sh
# ENV PATH=/home/gitpod/.nvm/versions/node/v${NODE_VERSION}/bin:$PATH

# Install ddev
USER gitpod
# RUN brew install drud/ddev/ddev
RUN wget -P /tmp https://raw.githubusercontent.com/drud/ddev/master/scripts/install_ddev.sh && bash /tmp/install_ddev.sh v1.19.0-alpha5

# Install GitUI (terminal-ui for git)
# RUN brew install gitui
RUN wget https://github.com/extrawurst/gitui/releases/download/v0.20.1/gitui-linux-musl.tar.gz -P /tmp
RUN sudo tar xzf /tmp/gitui-linux-musl.tar.gz -C /usr/bin

# Install Minio client
# RUN brew install minio-mc
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mcli_20220216055401.0.0_amd64.deb
RUN sudo dpkg -i mcli_20220216055401.0.0_amd64.deb
RUN sudo mv /usr/local/bin/mcli /usr/local/bin/mc

# Install composer
# USER root
# RUN add-apt-repository -y ppa:ondrej/php \
#     && install-packages composer
# USER root
# RUN add-apt-repository -y ppa:ondrej/php \
#     && install-packages php8.0
# RUN brew install composer

# Instal PHP
# RUN sudo apt-get -qq install -y php libapache2-mod-php

# Install latest composer
# RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
# RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
# RUN sudo php composer-setup.php --install-dir /usr/bin --filename composer
# RUN php -r "unlink('composer-setup.php');"

# RUN ./latest-composer.sh
# Dockerfile
# FROM php:7.4.27-fpm
# Install Composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# COPY --from=composer /usr/bin/composer /usr/bin/composer

# End workspace-base

FROM scratch as drupalpod-gitpod-base
SHELL ["/bin/bash", "-c"]
# ENV HOMEBREW_INSTALL_FROM_API=true
# ENV PATH=$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/
# ENV MANPATH="$MANPATH:/home/linuxbrew/.linuxbrew/share/man"
# ENV INFOPATH="$INFOPATH:/home/linuxbrew/.linuxbrew/share/info"

COPY --from=workspace-base / /
