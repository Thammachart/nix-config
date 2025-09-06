{ lib, config, configData, hostConfig, pkgs, conditions, ... }:
let
  rke2Config = {
    write-kubeconfig-mode = "0644";
    cluster-cidr = "10.50.0.0/16";
    service-cidr = "10.51.0.0/16";
    cluster-dns = "10.51.0.10";
    secrets-encryption = true;
  };
  rke2ConfigYaml = pkgs.writeText "rke2Config.yml" (lib.generators.toYAML {} rke2Config);
in
lib.mkIf conditions.rke2 {
}
