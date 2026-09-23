#!/bin/sh
# node_exporter runs on the AVADO docker network, so its own netdev collector
# only sees this container's eth0 (a few kB/s of Prometheus scrapes). The box's
# real network counters are in the host's network namespace, readable through
# the host root mount as /host/proc/1/net/dev (PID 1 = the host's init).
# Publish those through the textfile collector under the standard metric names.
# If they can't be read (unexpected kernel/permissions), fall back to the
# built-in collector so network metrics never disappear entirely.
SRC=/host/proc/1/net/dev
DIR=/tmp/textfile
write() { awk -f /etc/node-exporter/netdev.awk "$SRC" > "$DIR/netdev.prom.tmp" && mv "$DIR/netdev.prom.tmp" "$DIR/netdev.prom"; }

mkdir -p "$DIR"
if [ -r "$SRC" ] && write; then
  ( while true; do sleep 5; write; done ) &
  exec /bin/node_exporter --path.rootfs=/host --no-collector.netdev --collector.textfile.directory="$DIR" "$@"
fi
echo "host network counters not readable at $SRC; using the container's own" >&2
exec /bin/node_exporter --path.rootfs=/host "$@"
