{ config, inputs, lib, pkgs, configData, hostConfig, conditions , hostName, nix-secrets, betterfox, ... }:
let
  foot-with-patches = import ../packages/foot { inherit pkgs; };
  vscodium-with-patches = import ../packages/vscodium { inherit pkgs configData; };
  chromiumPasswordStore = "--password-store=${if config.secret-providers.kwallet.enable then "kwallet6" else "gnome-libsecret"}";
in
{
  imports = [
    ./secrets.nix
    ./overlays.nix
    ./network.nix
    ./systemd.nix
    ./fonts.nix
    ./display-manager.nix
    ./desktop-sessions/sway.nix
    ./desktop-sessions/hyprland.nix
    ./desktop-sessions/niri.nix
    ./secret-providers/gnome-keyring.nix
    ./secret-providers/kwallet.nix
    ./secret-providers/oo7-daemon.nix
  ];

  # secret-providers.gnome-keyring.enable = lib.mkDefault conditions.graphicalUser;
  secret-providers.kwallet.enable = lib.mkDefault conditions.graphicalUser;
  # secret-providers.oo7-daemon.enable = lib.mkDefault conditions.graphicalUser;

  desktop-sessions.sway.enable = lib.mkDefault conditions.graphicalUser;
  desktop-sessions.hyprland.enable = lib.mkDefault conditions.hyprland;
  desktop-sessions.niri.enable = lib.mkDefault conditions.niri;

  # programs.sway = {
  #   enable = lib.mkDefault conditions.graphicalUser;
  #   package = pkgs.sway;
  #   wrapperFeatures.gtk = true;
  #   extraPackages = with pkgs; [ grim slurp swaylock swayidle swaybg ];
  # };

  # programs.river = {
  #   enable = false;
  #   xwayland.enable = true;
  #   extraPackages = with pkgs; [];
  # };

  # programs.hyprland = {
  #   enable = lib.mkDefault conditions.graphicalUser;
  #   xwayland.enable = true;
  # };

  # programs.hyprlock = {
  #   enable = config.programs.hyprland.enable;
  # };

  # services.hypridle = {
  #   enable = config.programs.hyprland.enable;
  # };
}
