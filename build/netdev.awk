# Turns /proc/<pid>/net/dev into node_exporter's node_network_* metrics
# (text exposition format, same names, help and types as the netdev collector).
# Only real network cards: loopback, Docker bridges/veths and the ZeroTier
# tunnel (whose traffic also crosses the real card) are skipped.
BEGIN {
  split("bytes packets errs drop fifo frame compressed multicast", rx, " ")
  split("bytes packets errs drop fifo colls carrier compressed", tx, " ")
}
NR > 2 {
  line = $0; sub(/:/, " ", line); n = split(line, f, " ")
  dev = f[1]
  if (dev ~ /^(lo|veth|br-|docker|zt|virbr|tun|tap)/) next
  for (i = 1; i <= 8; i++) { v["receive_" rx[i]] = v["receive_" rx[i]] sprintf("node_network_receive_%s_total{device=\"%s\"} %s\n", rx[i], dev, f[i + 1]) }
  for (i = 1; i <= 8; i++) { v["transmit_" tx[i]] = v["transmit_" tx[i]] sprintf("node_network_transmit_%s_total{device=\"%s\"} %s\n", tx[i], dev, f[i + 9]) }
}
END {
  for (i = 1; i <= 8; i++) {
    k = "receive_" rx[i]; if (k in v) printf "# HELP node_network_%s_total Network device statistic %s.\n# TYPE node_network_%s_total counter\n%s", k, k, k, v[k]
  }
  for (i = 1; i <= 8; i++) {
    k = "transmit_" tx[i]; if (k in v) printf "# HELP node_network_%s_total Network device statistic %s.\n# TYPE node_network_%s_total counter\n%s", k, k, k, v[k]
  }
}
