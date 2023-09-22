FROM gitpod/workspace-base as workspace-base
SHELL ["/bin/bash", "-c"]

RUN sudo apt-get -qq update

# Install dialog (interactive script)
RUN sudo apt-get -qq install -y dialog

# Install DDEV
USER gitpod
RUN sudo install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://pkg.ddev.com/apt/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/ddev.gpg > /dev/null
RUN sudo chmod a+r /etc/apt/keyrings/ddev.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/ddev.gpg] https://pkg.ddev.com/apt/ * *" | sudo tee /etc/apt/sources.list.d/ddev.list >/dev/null
RUN sudo apt update && sudo apt install -y ddev

# Install GitUI (terminal-ui for git)
RUN wget https://github.com/extrawurst/gitui/releases/download/v0.24.3/gitui-linux-musl.tar.gz -P /tmp
RUN sudo tar xzf /tmp/gitui-linux-musl.tar.gz -C /usr/bin

# (get latest Minio version from https://dl.min.io/client/mc/release/linux-amd64/)
# Install Minio client
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mcli_20230920152231.0.0_amd64.deb
RUN sudo dpkg -i mcli_20230920152231.0.0_amd64.deb
RUN sudo mv /usr/local/bin/mcli /usr/local/bin/mc

# End workspace-base

FROM scratch as drupalpod-gitpod-base
SHELL ["/bin/bash", "-c"]
COPY --from=workspace-base / /
