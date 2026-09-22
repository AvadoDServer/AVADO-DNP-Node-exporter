# AVADO-DNP-Node-exporter

[Prometheus node exporter](https://github.com/prometheus/node_exporter) for AVADO.

Exposes this AVADO's hardware and OS metrics (CPU, memory, disk, network) at
`http://node-exporter.my.ava.do:9100/metrics` on the AVADO's internal network.
The [Prometheus package](https://github.com/AvadoDServer/AVADO-DNP-Prometheus) scrapes it
and the [Grafana package](https://github.com/AvadoDServer/AVADO-DNP-Grafana) shows it.

No ports are published on the host: the metrics are only reachable from other AVADO packages
and from browsers connected to the AVADO network.

The host's root filesystem is mounted read-only at `/host` and node exporter runs with
`--path.rootfs=/host`, so filesystem metrics describe the AVADO's disks.
Network metrics describe this container's network interface (the package runs on the
AVADO bridge network, not the host network).
