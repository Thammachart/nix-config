{ pkgs, config, configData, ... }:
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

  users.users."${configData.username}".extraGroups = ["docker"];

  environment.sessionVariables = {
    DEVSHELLS_PATH = "$HOME/shobshop-projects/common-dev-shells";
  };

  environment.systemPackages = [
    gcloud
    pkgs.gh
    pkgs.rustdesk-flutter
    pkgs.google-cloud-sql-proxy
    pkgs.firefox-devedition
  ];
}
