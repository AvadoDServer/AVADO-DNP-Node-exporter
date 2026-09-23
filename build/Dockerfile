FROM --platform=linux/amd64 prom/node-exporter:v1.12.1

# The host's root filesystem is mounted read-only at /host (see the manifest),
# so filesystem metrics describe the AVADO itself and not this container.
# entrypoint.sh also publishes the host's network counters (see there).
COPY netdev.awk /etc/node-exporter/netdev.awk
COPY entrypoint.sh /etc/node-exporter/entrypoint.sh
ENTRYPOINT ["/bin/sh", "/etc/node-exporter/entrypoint.sh"]
CMD []
