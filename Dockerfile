# hadolint ignore=DL3007
FROM node:lts-bookworm-slim as builder

ARG VERSION

# hadolint ignore=DL3016
RUN npm install --global \
    node@latest \
    wrangler@latest --force

# hadolint ignore=DL3007
FROM node:lts-bookworm-slim

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

ENV container=docker
ENV HOME=/home/node
ENV NPM_CONFIG_UPDATE_NOTIFIER=false

COPY package.json $HOME/
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/local/bin /usr/local/bin

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin \
    && printf "[safe]\n  directory = /data\n" >> $HOME/.gitconfig

WORKDIR /data
