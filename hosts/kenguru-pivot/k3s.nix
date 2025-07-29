{ lib, config, configData, hostConfig, pkgs, conditions, ... }:
let
in
lib.mkIf conditions.k3s {
  services.k3s = {
    enable = true;
    clusterInit = true;
    extraFlags = [
      "--cluster-cidr=10.42.0.0/16,fd09:42::/56"
      "--service-cidr=10.43.0.0/16,fd09:43::/112"
      "--flannel-ipv6-masq"
    ];
  };
}
