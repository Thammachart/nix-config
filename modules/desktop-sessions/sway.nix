{pkgs, lib, ...}:
let
  cmp-customize = import ../../packages/compositor-custom.nix;
  cfg = config.desktop-sessions.sway;

  cmp = cmp-customize { inherit pkgs; cmp = "sway"; };
in
{
  options.desktop-sessions.sway = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ sway swaylock swayidle swaybg ];

    services.displayManager.sessionPackages = [ cmp.custom-desktop-entry ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      wlr = {
        enable = true;
        settings = {};
      };
      config = {
        sway = {
          default = [ "wlr" "gtk" ];
        };
      };
    };
  };
}
