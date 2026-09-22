FROM --platform=linux/amd64 prom/node-exporter:v1.12.1

# The host's root filesystem is mounted read-only at /host (see the manifest),
# so filesystem metrics describe the AVADO itself and not this container.
CMD ["--path.rootfs=/host"]
