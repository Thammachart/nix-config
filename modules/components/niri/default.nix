{ pkgs, config, osConfig, lib, conditions, templateFile, configData, ...  }:
{
  flake.modules.nixos.niri = { pkgs, config, ... }:
  let
    cmp-name = "niri";
    package = pkgs."${cmp-name}";
    cmp = config.wl-cmp { cmp = "niri"; exec = "niri-session"; };
  in
  {
    environment.systemPackages = with pkgs; [ package xwayland-satellite hypridle hyprlock hyprcursor ];

    services.displayManager.sessionPackages = [ cmp.custom-desktop-entry ];

    # environment.etc."hyprland/nixos.conf".text = ''
    #   exec-once = ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    # '';

    security = {
      polkit.enable = true;
      pam.services.hyprlock = {};
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk ];
      config = {
        "${cmp-name}" = {
          default = [ "gtk" "gnome" ];
        };
      };
    };
  };

  flake.modules.homeManager.niri = { pkgs, lib, config, osConfig, ... }: {
    # home.file.".config/hypr/variables.conf".source = templateFile "hyprland-vars-${configData.username}" ./variables.conf.tmpl configData.homeSettings;
    home.file.".config/niri/autostart.kdl".source = config.templateFile "niri-autostart" ./autostart.kdl.tmpl config.configData.homeSettings;
    home.file.".config/niri/inputs.kdl".source = config.templateFile "niri-inputs" ./inputs.kdl.tmpl { inherit (osConfig) conditions; };
    home.file.".config/niri/binds.kdl".source = config.templateFile "niri-binds" ./binds.kdl.tmpl config.configData.homeSettings;
    home.file.".config/niri/config.kdl".source = config.templateFile "niri-config" ./config.kdl.tmpl config.configData.homeSettings;
  };
}
