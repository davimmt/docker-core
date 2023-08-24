FROM debian:stable-slim
ENV RUNNING_IN_DOCKER true

# Installing Golang
# COPY --from=golang:1.18-alpine /usr/local/go/ /usr/local/go/
# ENV PATH="/usr/local/go/bin:${PATH}"

# Installing kubectl
COPY --from=bitnami/kubectl:1.20.9 /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

# Installing sys lib dependencies packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    perl \
    bash \
    curl \
    unzip \
    tar \
    groff \
    less

# Installing custom packages
RUN apt-get install -y \
    openssh-client \
    zsh \
    fzf \
    bat \
    telnet \
    dnsutils \
    iproute2 \
    procps \
    neovim \
    xclip

RUN ln -sf python3 /usr/bin/python \
 && pip3 install --no-cache --upgrade pip setuptools --break-system-packages

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
ARG JQ_VERSION=1.6
RUN curl -sL https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -o /usr/bin/jq \
 && chmod +x /usr/bin/jq

# yq
ARG YQ_VERSION=4.2.0
RUN curl -sL https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 -o /usr/bin/yq \
 && chmod +x /usr/bin/yq

# helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
 && chmod +x get_helm.sh && ./get_helm.sh && chmod +x /usr/local/bin/helm && rm get_helm.sh

# terraform
ARG TERRAFORM_VERSION=1.3.7
RUN curl -sL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
 && unzip -j terraform.zip terraform -d /usr/bin && chmod +x /usr/bin/terraform && rm -f terraform.zip

# terragrunt
ARG TERRAGRUNT_VERSION=0.50.6
RUN curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o /usr/bin/terragrunt \
 && chmod +x /usr/bin/terragrunt

# Set up unprivileged user
ARG USER=main
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
 && rm -rf diff-so-fancy

# antigen
RUN mkdir -p ${HOME}/.antigen \
 && curl -L git.io/antigen > ${HOME}/.antigen/antigen.zsh

# navi https://github.com/denisidoro/navi
RUN curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install -o navi.sh \
 && BIN_DIR=${HOME}/.local/bin bash navi.sh \
 && rm -rf navi.sh \
 && git clone --single-branch --depth 1 "https://github.com/davimmt/navi-cheats" "$(navi info cheats-path)/davimmt__navi-cheats"

# lazygit
RUN curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')_Linux_x86_64.tar.gz" \
 && tar xf lazygit.tar.gz -C /usr/local/bin lazygit \
 && rm -f lazygit.tar.gz

# nvim
RUN curl -sLO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage \
 && chmod +x nvim.appimage \
 && ./nvim.appimage --appimage-extract \
 && mv squashfs-root/ ${HOME}/.nvim-appimage \
 && ln -fs ${HOME}/.nvim-appimage/AppRun /usr/bin/nvim \
 && rm -f nvim.appimage
RUN pip3 install --no-cache pyvim pynvim pyx --break-system-packages

# creating some mounting dirs
RUN chown -R ${USER}:${USER} ${HOME}/

# Clean apt package list
RUN rm -rf /var/lib/apt/lists/*

USER ${USER}
