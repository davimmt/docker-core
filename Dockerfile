FROM alpine:latest
ENV RUNNING_IN_DOCKER true

# Installing Golang
COPY --from=golang:1.18-alpine /usr/local/go/ /usr/local/go/
ENV PATH="/usr/local/go/bin:${PATH}"

# Installing kubectl
COPY --from=bitnami/kubectl:1.20.9 /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

# Installing Python
RUN apk --update --no-cache add \
    python3 \
    && ln -sf python3 /usr/bin/python \
    && python3 -m ensurepip \
    && pip3 install --no-cache --upgrade pip setuptools

# Install AWSCLIv2 with GLIBC
# https://github.com/aws/aws-cli/issues/4685#issuecomment-615872019
RUN apk --no-cache update && apk --no-cache add groff
ENV GLIBC_VER=2.31-r0
RUN apk --no-cache add \
        curl \
        binutils \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && apk --no-cache del \
        binutils \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*

# Install common packages
RUN curl -sL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/bin/jq && \
    chmod +x /usr/bin/jq

RUN curl -sL https://github.com/mikefarah/yq/releases/download/v4.2.0/yq_linux_amd64 -o /usr/bin/yq && \
    chmod +x /usr/bin/yq

RUN curl -sL https://get.helm.sh/helm-v3.10.0-linux-amd64.tar.gz -o /usr/bin/helm && \
    chmod +x /usr/bin/helm

RUN apk --no-cache add openssh git

# Set up unprivileged user
ARG USER=main
ENV HOME=/home/${USER}
RUN adduser -D ${USER} -s /bin/zsh \
    && mkdir -p /home/${USER}/.local/bin
ENV PATH="${PATH}:/home/${USER}/.local/bin"
WORKDIR ${HOME}
# Set up ZSH and preferred terminal environment
ENV ZSH_CUSTOM=${HOME}/.oh-my-zsh/custom
RUN apk --no-cache add zsh fzf bat perl bash neovim
# kube-ps1
# RUN git clone --single-branch --depth 1 https://github.com/jonmosco/kube-ps1.git ${ZSH_CUSTOM}/plugins/kube-ps1
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
RUN BIN_DIR=${HOME}/.local/bin bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install \
        | sed -r '/asset_url\(\)/,/fi/casset_url() {\n   echo "https://github.com/denisidoro/navi/releases/download/v2.20.1/navi-v2.20.1-x86_64-unknown-linux-musl.tar.gz"') \
    && rm -f navi.tar.gz

COPY nvim ${HOME}/.config/nvim
RUN sh -c 'nvim --headless +PlugInstall +qa' ${USER}
RUN mkdir -p ${HOME}/.ssh && chmod 700 ${HOME}/.ssh
COPY zsh/* ${HOME}/
RUN chown -R ${USER}:${USER} ${HOME}/
USER ${USER}
RUN /bin/zsh ${HOME}/.zshrc