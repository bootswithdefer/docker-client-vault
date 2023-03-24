FROM docker:latest
MAINTAINER Jesse DeFer <docker-client-vault@dotd.com>

RUN addgroup -g 1000 jenkins && addgroup -g 513 docker && adduser -D -u 1000 -g 1000 -G docker jenkins

RUN ssh-keyscan github.com > /etc/ssh/ssh_known_hosts

ENV VAULT_VERSION=1.13.0

RUN apk add --no-cache git openssh-client ca-certificates gnupg openssl && \
    gpg --auto-key-locate keyserver --keyserver hkps://keys.openpgp.org --locate-keys security@hashicorp.com && \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    wget -q https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    wget -q https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS && \
    wget -q https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig && \
    gpg --batch --verify vault_${VAULT_VERSION}_SHA256SUMS.sig vault_${VAULT_VERSION}_SHA256SUMS && \
    grep vault_${VAULT_VERSION}_linux_amd64.zip vault_${VAULT_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip -d /bin vault_${VAULT_VERSION}_linux_amd64.zip && \
    cd /tmp && \
    rm -rf /tmp/build && \
    apk del gnupg openssl && \
    rm -rf /root/.gnupg
