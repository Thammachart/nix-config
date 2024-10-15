{ config, lib, conditions, pkgs, configData, hostName, ... }:
let
  isClient = (!conditions.isServer);
in
{
  networking = {
    hostName = hostName;
    networkmanager = {
      enable = true;
    };
    resolvconf = {
      enable = true;
      package = if (isClient && config.services.resolved.enable) then lib.mkForce pkgs.systemd else lib.mkDefault pkgs.openresolv;
      # useLocalResolver = true;
      # extraConfig = ''
      # unbound_restart='/run/current-system/systemd/bin/systemctl reload --no-block unbound.service 2> /dev/null'
      # unbound_conf=/etc/unbound/resolvconf.conf
      # '';
    };

    firewall = {
      allowedTCPPorts = if config.services.adguardhome.enable then [ 53 ] else [];
      allowedUDPPorts = if config.services.adguardhome.enable then [ 53 67 ] else [];
    };
  };

  services.resolved = lib.mkIf isClient {
    enable = true;
    llmnr = "false";
    fallbackDns = [ "1.0.0.1" "1.1.1.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
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

  systemd.services.tailscaled.wantedBy = if (isClient && config.systemd.services.tailscaled != {}) then (lib.mkForce []) else [];
}
