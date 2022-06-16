FROM gitpod/workspace-base as workspace-base
SHELL ["/bin/bash", "-c"]

RUN sudo apt-get -qq update

# Install dialog (interactive script)
RUN sudo apt-get -qq install -y dialog

# Install ddev
USER gitpod
# RUN brew install drud/ddev/ddev
RUN wget -P /tmp https://raw.githubusercontent.com/drud/ddev/master/scripts/install_ddev.sh && bash /tmp/install_ddev.sh

# Install GitUI (terminal-ui for git)
RUN wget https://github.com/extrawurst/gitui/releases/download/v0.20.1/gitui-linux-musl.tar.gz -P /tmp
RUN sudo tar xzf /tmp/gitui-linux-musl.tar.gz -C /usr/bin

# Install Minio client
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mcli_20220611211036.0.0_amd64.deb
RUN sudo dpkg -i mcli_20220611211036.0.0_amd64.deb
RUN sudo mv /usr/local/bin/mcli /usr/local/bin/mc

# End workspace-base

FROM scratch as drupalpod-gitpod-base
SHELL ["/bin/bash", "-c"]
COPY --from=workspace-base / /
