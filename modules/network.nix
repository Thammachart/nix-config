{ config, lib, pkgs, configData, hostName, ... }:
{
  networking = {
    hostName = hostName;
    networkmanager = {
      enable = true;
    };
    resolvconf = {
      # enable = true;
      # package = lib.mkForce pkgs.systemd;
      # useLocalResolver = true;
      extraConfig = ''
      unbound_restart='/run/current-system/systemd/bin/systemctl reload --no-block unbound.service 2> /dev/null'
      unbound_conf=/etc/unbound/resolvconf.conf
      '';
    };
  };

  # services.resolved = {
  #   enable = true;
  #   fallbackDns = [ "1.0.0.1" "1.1.1.1" ];
  # };

  services.unbound = {
    enable = true;
    group = "networkmanager";
    resolveLocalQueries = true;
    settings = {
      include = "/etc/unbound/resolvconf.conf";
      server = {
        private-domain = ["intranet" "internal" "private" "corp" "home" "lan"];
        domain-insecure = ["intranet" "internal" "private" "corp" "home" "lan"];

       	unblock-lan-zones = true;
       	insecure-lan-zones = true;
      };
    };
  };
}
