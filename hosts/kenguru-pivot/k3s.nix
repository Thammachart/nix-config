{ lib, config, configData, hostConfig, pkgs, conditions, ... }:
let
in
lib.mkIf conditions.k3s {
  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];

  services.k3s = {
    enable = true;
    clusterInit = true;
    role = "server";
    extraFlags = [
      "--write-kubeconfig-mode=644"
      "--cluster-cidr=10.50.0.0/16,fd09:50::/56"
      "--service-cidr=10.51.0.0/16,fd09:51::/112"
      "--cluster-dns=10.51.0.10,fd09:51::a"
      "--flannel-ipv6-masq"
      "--secrets-encryption"
    ];
  };
}
