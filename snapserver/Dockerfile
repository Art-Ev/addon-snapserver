ARG BUILD_FROM
FROM $BUILD_FROM

# Add env
ENV LANG C.UTF-8

#Install librespot
RUN apk -U add build-base curl cargo portaudio-dev protobuf-dev \
 && cd /root \
 && curl -LO https://github.com/librespot-org/librespot/archive/refs/tags/v0.2.0.zip \
 && unzip v0.2.0.zip \
 && cd librespot-0.2.0 \
 && cargo build --jobs $(grep -c ^processor /proc/cpuinfo) --release --no-default-features \
 && mv target/release/librespot /usr/local/bin \
 && cd / \
 && apk --purge del curl cargo portaudio-dev protobuf-dev \
 && apk add llvm-libunwind \
 && rm -rf /etc/ssl /var/cache/apk/* /lib/apk/db/* /root/v0.2.0.zip /root/librespot-0.2.0 /root/.cargo

#Install snapcast
RUN sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories && apk add --no-cache snapcast bash

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
