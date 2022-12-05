ARG BUILD_FROM
FROM $BUILD_FROM

# Add env
ENV LANG C.UTF-8

RUN \
    apk add --no-cache --virtual .build-dependencies \
        build-base=0.5-r3 \
        cargo=1.60.0-r2 \
        git=2.36.3-r0 \
        protobuf-dev=3.18.1-r3 \
        pulseaudio-dev=15.0-r2 \
    \
    && apk add --no-cache \
        pulseaudio=15.0-r2 \
    \
    && cargo install \
        --locked \
        --no-default-features \
        --features pulseaudio-backend \
        --root /usr \
        --bin librespot \
        --version 0.4.2 \
        --verbose \ 
        -- librespot \
    \
    && apk del --no-cache --purge .build-dependencies \
    && rm -fr \
        /tmp/* \
        ~/.cargo \
        /usr/.crates.toml \
        /usr/.crates2.json

#Install snapcast
RUN sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories && apk add --no-cache snapcast bash

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
