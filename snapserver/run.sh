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

echo "[stream]" > "${config}"
# Streams
streams=$(bashio::config 'streams')
echo "${streams}" >> "${config}"

# Stream bis and ter
if bashio::config.has_value 'stream_bis'; then
    stream_bis=$(bashio::config 'stream_bis')
    echo "${stream_bis}" >> "${config}"
fi
if bashio::config.has_value 'stream_ter'; then
    stream_ter=$(bashio::config 'stream_ter')
    echo "${stream_ter}" >> "${config}"
fi

# Buffer
buffer=$(bashio::config 'buffer')
echo "buffer = ${buffer}" >> "${config}"
# Codec
codec=$(bashio::config 'codec')
echo "codec = ${codec}" >> "${config}"
# Muted
muted=$(bashio::config 'send_to_muted')
echo "send_to_muted = = ${muted}" >> "${config}"
# Sampleformat
sampleformat=$(bashio::config 'sampleformat')
echo "sampleformat = ${sampleformat}" >> "${config}"

# Http
http=$(bashio::config 'http_enabled')
echo "[http]" >> "${config}"
echo "enabled = ${http}" >> "${config}"
echo "bind_to_address = ::" >> "${config}"
# Datadir
datadir=$(bashio::config 'server_datadir')
echo "doc_root = ${datadir}" >> "${config}"
# TCP

echo "[tcp]" >> "${config}"
tcp=$(bashio::config 'tcp_enabled')
echo "enabled = ${tcp}" >> "${config}"

# Logging
echo "[logging]" >> "${config}"
logging=$(bashio::config 'logging_enabled')
echo "debug = ${logging}" >> "${config}"

# Threads
echo "[server]" >> "${config}"
threads=$(bashio::config 'server_threads')
echo "threads = ${threads}" >> "${config}"

bashio::log.info "Starting SnapServer..."

/usr/bin/snapserver -c /etc/snapserver.conf
