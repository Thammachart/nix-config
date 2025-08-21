{ lib, config, configData, hostConfig, pkgs, conditions, ... }:
let
  k3sConfig = {
    write-kubeconfig-mode = "0644";
    cluster-cidr = "10.50.0.0/16";
    service-cidr = "10.51.0.0/16";
    cluster-dns = "10.51.0.10";
    secrets-encryption = true;

    flannel-backend = "none";
    disable-kube-proxy = true;
    disable-network-policy = true;
    disable = ["traefik" "servicelb"];
  };

  k3sConfigYaml = pkgs.writeText "k3sConfig.yml" (lib.generators.toYAML {} k3sConfig);
in
lib.mkIf conditions.k3s {
  networking.firewall.enable = false;
  networking.nftables.enable = false;

  environment.systemPackages = [ pkgs.cilium-cli ];

  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
    10250 # k8s metric server
  ];
  networking.firewall.allowedUDPPorts = [
    8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];

  services.k3s = {
    enable = true;
    clusterInit = true;
    role = "server";
    extraFlags = [
      "--config=${k3sConfigYaml}"
    ];
  };
}
