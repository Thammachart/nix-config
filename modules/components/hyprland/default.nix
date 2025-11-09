{
  flake.modules.nixos.hyprland = { pkgs, config, ... }:
  let
    cmp-name = "hyprland";
    package = pkgs."${cmp-name}";
    cmp = config.wl-cmp { cmp = "Hyprland"; };
  in
  {
    environment.systemPackages = with pkgs; [ package hypridle hyprlock hyprcursor ];

    services.displayManager.sessionPackages = [ cmp.custom-desktop-entry ];

    environment.etc."hyprland/nixos.conf".text = ''
      exec-once = ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    '';

    security = {
      polkit.enable = true;
      pam.services.hyprlock = {};
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
      config = {
        "${cmp-name}" = {
          default = [ "hyprland" "gtk" ];
          # "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          # "org.freedesktop.impl.portal.Secret" = [ "oo7-portal" ];
        };
      };
    };
  };

  flake.modules.homeManager.hyprland = { pkgs, lib, config, osConfig, ... }:
  let
    plugins = [
      # pkgs.hyprlandPlugins.hy3
    ];
  in
  {
    home.file.".config/hypr/hypridle.conf".source = config.templateFile "hypridle-conf" ./hypridle.conf.tmpl config.configData.homeSettings;
    home.file.".config/hypr/hyprlock.conf".source = config.templateFile "hyprlock-conf" ./hyprlock.conf.tmpl config.configData.homeSettings;

    home.file.".config/hypr/variables.conf".source = config.templateFile "hyprland-vars" ./variables.conf.tmpl config.configData.homeSettings;
    home.file.".config/hypr/autostart.conf".source = config.templateFile "hyprland-autostart" ./autostart.conf.tmpl config.configData.homeSettings;
    home.file.".config/hypr/inputs.conf".source = config.templateFile "hyprland-inputs" ./inputs.conf.tmpl { inherit (osConfig) conditions; };
    home.file.".config/hypr/binds.conf".source = config.templateFile "hyprland-binds" ./binds.conf.tmpl config.configData.homeSettings;

    home.file.".config/hypr/_init.conf".text = ''
      source = /etc/hyprland/nixos.conf
      env = XCURSOR_THEME,${config.home.pointerCursor.name}
      env = XCURSOR_SIZE,${builtins.toString config.home.pointerCursor.size}
      env = HYPRCURSOR_THEME,${config.home.pointerCursor.name}
      env = HYPRCURSOR_SIZE,${builtins.toString config.home.pointerCursor.size}
      ${lib.concatMapStringsSep "\n" (entry:
        "exec-once = hyprctl plugin load ${entry}/lib/lib${entry.pname}.so"
      ) plugins}
    '';

    home.file.".config/hypr/hyprland.conf".source = config.templateFile "hyprland-config" ./hyprland.conf.tmpl config.configData.homeSettings;

    ### NixOS options make xdg-desktop-portal-hyprland conflict with other variants
    # wayland.windowManager.hyprland =
    #   enable = true;
    # };
  };
}
