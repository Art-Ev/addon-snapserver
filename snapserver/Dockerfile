ARG BUILD_FROM=ghcr.io/hassio-addons/base:14.3.3
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG LIBRESPOT_VERSION="0.4.2"
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        build-base=0.5-r3 \
        cargo=1.71.1-r0 \
        git=2.40.1-r0 \
        protobuf-dev=3.21.12-r2 \
        pulseaudio-dev=16.1-r10 \
    \
    && apk add --no-cache \
        pulseaudio=16.1-r10 \
    \
    && cargo install \
        --locked \
        --no-default-features \
        --features pulseaudio-backend \
        --root /usr \
        --bin librespot \
        --version "${LIBRESPOT_VERSION}" \
        --verbose \ 
        -- librespot \
    && apk del --no-cache --purge .build-dependencies \
    && rm -fr \
        /tmp/* \
        ~/.cargo \
        /usr/.crates.toml \
        /usr/.crates2.json

#Install Snapcast
RUN \
    apk add snapcast-server \
        --no-cache \
        --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \ 
        bash

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
