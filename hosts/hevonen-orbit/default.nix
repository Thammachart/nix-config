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
    
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;

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
    pkgs.cloudflared
    pkgs.filezilla
    pkgs.jwt-cli
    pkgs.cloudflare-warp
    pkgs.curlie
    pkgs.caddy
  ];
  
  services.cloudflare-warp = {
    enable = true;
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
        start_threshold = 20;
        stop_threshold = 80;
      };
    };
  };
}
