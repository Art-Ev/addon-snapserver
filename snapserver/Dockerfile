ARG BUILD_FROM=ghcr.io/hassio-addons/base:16.3.1
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG LIBRESPOT_VERSION="0.4.2"
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        build-base=0.5-r3 \
        cargo=1.78.0-r0 \
        git=2.45.2-r0 \
        protobuf-dev=24.4-r1 \
    \
    && apk add --no-cache \
        pulseaudio \
        pulseaudio \
        --repository=https://dl-cdn.alpinelinux.org/alpine/latest-stable/community/armhf/ \
    \
        && apk add --no-cache \
        librespot \
        --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
    && apk del --no-cache --purge .build-dependencies \
    && rm -fr \
        /tmp/* \
        ~/.cargo \
        /usr/.crates.toml \
        /usr/.crates2.json

#Install Snapcast
RUN apk add --no-cache snapcast-server bash

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
