{ pkgs, config, configData, ... }:
let 
  gcloud = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]);
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./custom-hardware-configuration.nix
      ../../modules/system.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  users.users."${configData.username}".extraGroups = ["docker"];

  services.tlp.enable = true;

  environment.sessionVariables = {
    DEVSHELLS_PATH = "$HOME/shobshop-projects/common-dev-shells";
  };

  environment.systemPackages = [
    gcloud
    pkgs.gh
    pkgs.rustdesk
    pkgs.google-cloud-sql-proxy
    pkgs.firefox-devedition
  ];
}