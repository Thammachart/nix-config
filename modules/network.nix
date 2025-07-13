{ config, lib, conditions, pkgs, configData, hostConfig, hostName, ... }:
let
  isClient = (!conditions.isServer);
  defaultWifiId = "HOME-0";
in
{
  networking = {
    hostName = hostName;
    networkmanager = {
      enable = lib.mkDefault true;

      ensureProfiles.environmentFiles = [ "/root/default-wifi" ];

      ensureProfiles.profiles = {
        "${defaultWifiId}" = {
          connection = {
            id = "${defaultWifiId}";
            permissions = "";
            type = "wifi";
            interface-name = hostConfig.networking.ifname;
          };
          ipv4 = {
            address1 = hostConfig.networking.v4.ipaddr;
            dns = lib.concatStringsSep ";" configData.networking.default.DNS4;
            gateway = configData.networking.default.Gateway4;
            may-fail = false;
            method = "manual";
          };
          ipv6 = {
            addr-gen-mode="stable-privacy";
            address1 = hostConfig.networking.v6.ipaddr;
            dns = lib.concatStringsSep ";" configData.networking.default.DNS6;
            ignore-auto-dns = true;
            may-fail = false;
            method = "auto";
          };
          wifi = {
            mode = "infrastructure";
            cloned-mac-address = "stable-ssid";
            ssid = "$WIFI_SSID";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$WIFI_PSK";
          };
        };
      };
    };


    # resolvconf = {
    #   enable = true;
    #   package = lib.mkForce pkgs.openresolv;
    #   useLocalResolver = true;
    #   extraConfig = ''
    #   unbound_restart='/run/current-system/systemd/bin/systemctl reload --no-block unbound.service 2> /dev/null'
    #   unbound_conf=/etc/unbound/resolvconf.conf
    #   '';
    # };

    firewall = {};
  };

  services.resolved = lib.mkIf isClient {
    enable = true;
    llmnr = "false";
    fallbackDns = [ "1.0.0.1" "1.1.1.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  };

  # services.unbound = {
  #   enable = true;
  #   group = "networkmanager";
  #   resolveLocalQueries = true;
  #   settings = {
  #     include = "/etc/unbound/resolvconf.conf";
  #     server = {
  #       private-domain = ["intranet" "internal" "private" "corp" "home" "lan"];
  #       domain-insecure = ["intranet" "internal" "private" "corp" "home" "lan"];

  #      	unblock-lan-zones = true;
  #      	insecure-lan-zones = true;
  #     };
  #   };
  # };

  services.openssh = lib.mkIf conditions.isServer {
    enable = true;
    banner = "${hostName} via ssh!\n";
  };

  services.tailscale = lib.mkIf (!conditions.isWork) {
    enable = true;
  };

  systemd.services.tailscaled.wantedBy = if (isClient && config.systemd.services.tailscaled != {}) then (lib.mkForce []) else [];
}
