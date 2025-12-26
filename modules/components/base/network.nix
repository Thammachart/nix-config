{ ... }:
let
  defaultWifiId = "HOME-0";
in
{
  flake.modules.nixos.base = { lib, config, configData, hostname, hostConfig, ...}: {
    services.timesyncd.extraConfig = ''
      PollIntervalMinSec=43200
      PollIntervalMaxSec=86400
    '';

    networking = {
      hostName = hostname;

      timeServers = [ "time5.nimt.or.th" "time4.nimt.or.th" "time3.nimt.or.th" "time.cloudflare.com" ];

      dhcpcd.enable = false;

      firewall.enable = lib.mkDefault true;
      nftables.enable = lib.mkDefault true;

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
              autoconnect = true;
              autoconnect-priority = 99;
            };
            ipv4 = {
              address1 = hostConfig.networking.v4.ipaddr;
              dns = lib.concatStringsSep ";" configData.networking.default.DNS4;
              gateway = configData.networking.default.Gateway4;
              dns-search = "$SEARCH_DOMAIN";
              may-fail = false;
              method = "manual";
            };
            ipv6 = {
              addr-gen-mode="stable-privacy";
              address1 = hostConfig.networking.v6.ipaddr;
              dns = lib.concatStringsSep ";" configData.networking.default.DNS6;
              ignore-auto-dns = true;
              dns-search = "$SEARCH_DOMAIN";
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

    services.resolved = {
      enable = lib.mkDefault true;
      llmnr = "false";
      dnsovertls = "false";
      fallbackDns = [
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
        "2620:fe::fe#dns.quad9.net"
        "2620:fe::9#dns.quad9.net"

        "1.0.0.1#one.one.one.one"
        "1.1.1.1#one.one.one.one"
        "2606:4700:4700::1111#one.one.one.one"
        "2606:4700:4700::1001#one.one.one.one"
      ];
    };

    systemd.services."NetworkManager-wait-online".enable = false;
  };
}
