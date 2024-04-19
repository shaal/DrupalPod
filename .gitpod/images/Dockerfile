FROM gitpod/workspace-base as workspace-base
SHELL ["/bin/bash", "-c"]

RUN sudo apt-get -qq update

# Install dialog (interactive script)
RUN sudo apt-get -qq install -y dialog

# Install DDEV
USER gitpod
# Add DDEV’s GPG key to your keyring
RUN sudo sh -c 'echo ""'
RUN sudo install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://pkg.ddev.com/apt/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/ddev.gpg > /dev/null
RUN sudo chmod a+r /etc/apt/keyrings/ddev.gpg

# Add DDEV releases to your package repository
RUN sudo sh -c 'echo ""'
RUN echo "deb [signed-by=/etc/apt/keyrings/ddev.gpg] https://pkg.ddev.com/apt/ * *" | sudo tee /etc/apt/sources.list.d/ddev.list >/dev/null

# Update package information and install DDEV
RUN sudo sh -c 'echo ""'
RUN sudo apt update && sudo apt install -y ddev

# Install GitUI (terminal-ui for git)
ARG GITUI_VERSION=v0.26.1
RUN wget https://github.com/extrawurst/gitui/releases/download/${GITUI_VERSION}/gitui-linux-x86_64.tar.gz -P /tmp
RUN sudo tar xzf /tmp/gitui-linux-x86_64.tar.gz -C /usr/bin

# Install LazyGit (terminal-ui for git)
RUN wget https://github.com/jesseduffield/lazygit/releases/download/v0.41.0/lazygit_0.41.0_Linux_x86_64.tar.gz -P /tmp
RUN tar -C /tmp -xf /tmp/lazygit_0.41.0_Linux_x86_64.tar.gz
RUN sudo install /tmp/lazygit /usr/local/bin

# (get latest Minio version from https://dl.min.io/client/mc/release/linux-amd64/)
# Install Minio client
ARG MINIO_CLIENT_VERSION=mcli_20240418164529.0.0_amd64.deb
RUN wget https://dl.min.io/client/mc/release/linux-amd64/${MINIO_CLIENT_VERSION}
RUN sudo dpkg -i ${MINIO_CLIENT_VERSION}
RUN sudo mv /usr/local/bin/mcli /usr/local/bin/mc

# End workspace-base

FROM scratch as drupalpod-gitpod-base
SHELL ["/bin/bash", "-c"]
COPY --from=workspace-base / /
