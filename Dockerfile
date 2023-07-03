FROM debian:stable-slim
ENV RUNNING_IN_DOCKER true

ARG USER=main
# ARG GOLANG_VERSION=1.18-alpine
# ARG KUBECTL_VERSION=1.20.9
ARG JQ_VERSION=1.6
ARG YQ_VERSION=4.2.0
ARG HELM_VERSION=3.10.0
ARG HELM_VERSION=3.10.0
ARG TERRAFORM_VERSION=1.3.7

# Installing Golang
COPY --from=golang:1.18-alpine /usr/local/go/ /usr/local/go/
ENV PATH="/usr/local/go/bin:${PATH}"

# Installing kubectl
COPY --from=bitnami/kubectl:1.20.9 /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

# Installing packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    openssh-client \
    git \
    zsh \
    fzf \
    bat \
    telnet \
    dnsutils \
    perl \
    bash \
    neovim \
    curl \
    unzip \
    tar \
    xclip \
 && rm -rf /var/lib/apt/lists/* \
 && ln -sf python3 /usr/bin/python

RUN pip3 install --no-cache --upgrade pip setuptools --break-system-packages

# AWSCLIv2
RUN curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
 && unzip awscliv2.zip \
 && aws/install \
 && rm -rf \
    awscliv2.zip \
    aws \
    /usr/local/aws-cli/v2/*/dist/aws_completer \
    /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
    /usr/local/aws-cli/v2/*/dist/awscli/examples

# Session Manager Plugin
RUN curl -sL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" \
 && dpkg -i session-manager-plugin.deb \
 && rm -rf session-manager-plugin.deb

# jq
RUN curl -sL https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -o /usr/bin/jq \
 && chmod +x /usr/bin/jq

# yq
RUN curl -sL https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 -o /usr/bin/yq \
 && chmod +x /usr/bin/yq

# helm
RUN curl -sL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -o /usr/bin/helm \
 && chmod +x /usr/bin/helm

# terraform
RUN curl -sL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
 && unzip -j terraform.zip terraform -d /usr/bin && chmod +x /usr/bin/terraform && rm -f terraform.zip

# Set up unprivileged user
ENV HOME=/home/${USER}
RUN adduser --disabled-password ${USER} --shell /bin/zsh --home ${HOME} \
 && mkdir -p ${HOME}/.local/bin
ENV PATH="${PATH}:${HOME}/.local/bin"
WORKDIR ${HOME}

# Set up ZSH and preferred terminal environment
ENV ZSH_CUSTOM=${HOME}/.oh-my-zsh/custom

# diff-so-fancy
RUN git clone --single-branch --depth 1 https://github.com/so-fancy/diff-so-fancy.git \
 && mv diff-so-fancy/diff-so-fancy ${HOME}/.local/bin \
 && mv diff-so-fancy/lib ${HOME}/.local/bin \
 && rm -rf diff-so-fancy \
 && git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"

# vim-plug https://github.com/junegunn/vim-plug
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# antigen
RUN mkdir -p ${HOME}/.antigen \
 && curl -L git.io/antigen > ${HOME}/.antigen/antigen.zsh

# navi https://github.com/denisidoro/navi
RUN curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install -o navi.sh \
 && BIN_DIR=${HOME}/.local/bin bash navi.sh \
 && rm -rf navi.sh

# nvim
RUN curl -sLO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage \
 && chmod +x nvim.appimage \
 && ./nvim.appimage --appimage-extract \
 && mv squashfs-root/ ${HOME}/.nvim-appimage \
 && ln -fs ${HOME}/.nvim-appimage/AppRun /usr/bin/nvim \
 && rm -f nvim.appimage

RUN pip3 install --no-cache pyvim pynvim pyx --break-system-packages

# more user profile config
RUN git clone https://github.com/nvim-lua/kickstart.nvim ${HOME}/.config/nvim
COPY nvim/kickstart-nvim-lua-custom-plugins/*.lua ${HOME}/.config/nvim/lua/custom/plugins
RUN sh -c 'nvim --headless +PlugInstall +qa' ${USER}
RUN mkdir -p ${HOME}/.ssh && chmod 700 ${HOME}/.ssh
RUN mkdir -p ${HOME}/volumes
COPY zsh/* ${HOME}/
RUN chown -R ${USER}:${USER} ${HOME}/
USER ${USER}
RUN /bin/zsh ${HOME}/.zshrc
