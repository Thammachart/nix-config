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

    users.users."${configData.username}".extraGroups = ["docker"];

    environment.systemPackages = [
      gcloud
    ];
}
