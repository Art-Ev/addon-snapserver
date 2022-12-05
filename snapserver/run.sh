#!/usr/bin/env bashio

mkdir -p /share/snapfifo
mkdir -p /share/snapcast

declare streams
declare stream_bis
declare stream_ter
declare buffer
declare codec
declare muted
declare sampleformat
declare http
declare tcp
declare logging
declare threads
declare datadir

config=/etc/snapserver.conf

if ! bashio::fs.file_exists '/etc/snapserver.conf'; then
    touch /etc/snapserver.conf ||
        bashio::exit.nok "Could not create snapserver.conf file on filesystem"
fi
bashio::log.info "Populating snapserver.conf..."

# Streams
streams=$(bashio::config 'streams')
sed "/[stream]/a ${streams}" "${config}"

# Stream bis and ter
if bashio::config.has_value 'stream_bis'; then
    stream_bis=$(bashio::config 'stream_bis')
    sed "/[stream]/a ${stream_bis}" "${config}"
fi
if bashio::config.has_value 'stream_ter'; then
    stream_ter=$(bashio::config 'stream_ter')
    sed "/[stream]/a ${stream_ter}" "${config}"
fi

# Buffer
buffer=$(bashio::config 'buffer')
bashio::log.info "Bufffer: ${buffer}"
sed -i "/#buffer = 1000/a buffer = ${buffer}" "${config}"
# Codec
codec=$(bashio::config 'codec')
sed -i "/#codec = flac/a codec = ${codec}" "${config}"
# Muted
muted=$(bashio::config 'send_to_muted')
sed -i "/#send_to_muted = false/a codec = ${muted}" "${config}"
# Sampleformat
sampleformat=$(bashio::config 'sampleformat')
sed -i "/#sampleformat = 48000:16:2/a codec = ${sampleformat}" "${config}"
# Http
http=$(bashio::config 'http_enabled')
sed "/[http]/a enabled = ${http}" "${config}"
sed -i "/#bind_to_address = 0.0.0.0/a bind_to_address = ::" "${config}"
# TCP
tcp=$(bashio::config 'tcp_enabled')
sed "/[TCP]/a enabled = ${tcp}" "${config}"
# Logging
logging=$(bashio::config 'logging_enabled')
sed "/[logging]/a debug = ${logging}" "${config}"
# Threads
threads=$(bashio::config 'server_threads')
sed -i "/#threads = -1/a threads = ${threads}" "${config}"
# Datadir
datadir=$(bashio::config 'server_datadir')
sed -i "/#datadir =/a datadir = ${datadir}" "${config}"

bashio::log.info "Starting SnapServer..."

/usr/bin/snapserver -c /etc/snapserver.conf
