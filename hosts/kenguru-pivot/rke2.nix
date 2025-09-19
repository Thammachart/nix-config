{ lib, config, configData, hostConfig, pkgs, conditions, ... }:
let
	cni = "calico";
  rke2Config = {
    write-kubeconfig-mode = "0644";
    node-ip = "192.168.0.5";
    node-external-ip = "100.65.120.67";
    cluster-cidr = "10.50.0.0/16";
    service-cidr = "10.51.0.0/16";
    cluster-dns = "10.51.0.10";
  };
  rke2ConfigYaml = pkgs.writeText "rke2Config.yml" (lib.generators.toYAML {} rke2Config);
in
lib.mkIf conditions.rke2 {
	environment.systemPackages = [];

	networking.firewall.allowedTCPPorts = [
    6443 # required so that pods can reach the API server (running on port 6443 by default)
    2379 # etcd clients
    2380 # etcd peers
    10250 # k8s metric server
    80 443
  ] ++ lib.optionals (cni == "calico") [
  	179 # Calico CNI with BGP
  	5473 # Calico networking with Typha enabled
   	9098 # Calico Typha health checks
    9099 # Calico health checks
  ];

  networking.firewall.allowedUDPPorts = [
  ] ++ lib.optionals (cni == "calico") [
  	4789 # Calico networking with VXLAN enabled
	  51820 # Calico networking with IPv4 Wireguard enabled
	  51821 # Calico networking with IPv6 Wireguard enabled
  ] ++ lib.optionals (cni == "flannel") [
  	8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];

  services.rke2 = {
		enable = true;
		role = "server";
		cni = cni;
		configPath = "${rke2ConfigYaml}";
	};
}
