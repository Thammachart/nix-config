{ config, lib, conditions, pkgs, configData, hostName, ... }:
{
  networking = {
    hostName = hostName;
    networkmanager = {
      enable = true;
      connectionConfig = {
        mdns = 1;
        llmnr = 0;
      };
    };
    resolvconf = {
      enable = true;
      package = lib.mkForce pkgs.systemd;
      # useLocalResolver = true;
      # extraConfig = ''
      # unbound_restart='/run/current-system/systemd/bin/systemctl reload --no-block unbound.service 2> /dev/null'
      # unbound_conf=/etc/unbound/resolvconf.conf
      # '';
    };
  };

  services.resolved = {
    enable = true;
    llmnr = "false";
    fallbackDns = [ "1.0.0.1" "1.1.1.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
    extraConfig = ''
    MulticastDNS=true
    '';
  };

  services.unbound = {
    enable = false;
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

  services.openssh = lib.mkIf conditions.isServer {
    enable = true;
    banner = "${hostName} via ssh!\n";
  };

  services.tailscale = lib.mkIf (!conditions.isWork) {
    enable = true;
  };

  systemd.services.tailscaled.wantedBy = if (!conditions.isServer && config.systemd.services.tailscaled != {}) then (lib.mkForce []) else [];
}
