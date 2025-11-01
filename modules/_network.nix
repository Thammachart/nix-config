{ config, lib, conditions, pkgs, configData, hostConfig, hostName, ... }:
let
  isClient = (!conditions.isServer);
  defaultWifiId = "HOME-0";
in
{

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

}
