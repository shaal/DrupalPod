FROM gitpod/workspace-base as workspace-base
SHELL ["/bin/bash", "-c"]

RUN sudo apt-get -qq update

# Install dialog (interactive script)
RUN sudo apt-get -qq install -y dialog

# Install DDEV
USER gitpod
RUN curl -fsSL https://apt.fury.io/drud/gpg.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/ddev.gpg > /dev/null
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/ddev.gpg] https://apt.fury.io/drud/ * *" | sudo tee /etc/apt/sources.list.d/ddev.list
RUN sudo apt update && sudo apt install -y ddev

# Install GitUI (terminal-ui for git)
RUN wget https://github.com/extrawurst/gitui/releases/download/v0.21.0/gitui-linux-musl.tar.gz -P /tmp
RUN sudo tar xzf /tmp/gitui-linux-musl.tar.gz -C /usr/bin

# (get latest Minio version from https://dl.min.io/client/mc/release/linux-amd64/)
# Install Minio client
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mcli_20221213002328.0.0_amd64.deb
RUN sudo dpkg -i mcli_20221213002328.0.0_amd64.deb
RUN sudo mv /usr/local/bin/mcli /usr/local/bin/mc

# End workspace-base

FROM scratch as drupalpod-gitpod-base
SHELL ["/bin/bash", "-c"]
COPY --from=workspace-base / /
