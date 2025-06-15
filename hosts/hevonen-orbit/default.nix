{ pkgs, config, configData, nix-secrets, ... }:
let
  gcloud = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]);
in
{
  imports =
    [
      ./disko-fs.nix
      ./secrets.nix
      ./hardware-configuration.nix
      ./custom-hardware-configuration.nix
      ../../modules/system.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;

  users.users."${configData.username}".extraGroups = [ "docker" ];

  environment.sessionVariables = {
    DEVSHELLS_PATH = "$HOME/shobshop-projects/common-dev-shells";
  };

  environment.systemPackages = (with pkgs; [
    gcloud
    doctl
    postgresql_16
    google-cloud-sql-proxy
    pgadmin4-desktopmode
    # rustdesk-flutter
    # bruno
    filezilla
    caddy
    libreoffice-fresh
  ]);

  # sops.secrets.shobshop_internal_ca_cert = {
  #   format = "binary";
  #   sopsFile = "${nix-secrets}/shobshop/ca.crt";
  # };

  # security.pki.certificateFiles = [
  #   config.sops.secrets.shobshop_internal_ca_cert.path
  # ];
  #

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = config.services.ananicy.package;
  };

  programs.auto-cpufreq = {
    enable = false;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };

      battery = {
        governor = "powersave";
        turbo = "auto";

        enable_thresholds = true;
        start_threshold = 30;
        stop_threshold = 80;
      };
    };
  };
}
