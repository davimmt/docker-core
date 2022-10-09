# Get kubectl binary
FROM bitnami/kubectl:1.20.9 as kubectl
FROM alpine:latest
ENV RUNNING_IN_DOCKER true
# Copying kubectl binary to current stage
COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

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

RUN apk --no-cache add openssh git

# Set up unprivileged user
RUN adduser -D main -s /bin/zsh
WORKDIR /home/main
# Set up ZSH and preferred terminal environment
ENV ZSH_CUSTOM=/home/main/.oh-my-zsh/custom
RUN apk --no-cache add zsh
RUN git clone --single-branch --depth 1 https://github.com/jonmosco/kube-ps1.git ${ZSH_CUSTOM}/plugins/kube-ps1

RUN apk --no-cache add msttcorefonts-installer fontconfig && \
    update-ms-fonts && \
    fc-cache -f
COPY fonts/*.ttf .
RUN mkdir -p /usr/share/fonts/truetype/firacode
RUN install -m644 *.ttf /usr/share/fonts/truetype/firacode \
    && rm -rf *.ttf \
    && fc-cache -f -v

RUN mkdir -p /home/main/.antigen
RUN curl -L git.io/antigen > /home/main/.antigen/antigen.zsh
COPY zsh/* /home/main/
RUN chown -R main:main /home/main/

USER main
RUN /bin/zsh /home/main/.zshrc