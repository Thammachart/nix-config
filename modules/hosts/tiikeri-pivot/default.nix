{ config, lib, pkgs, conditions, configData, ... }:
{
  flake.modules.nixos.hosts_tiikeri-pivot.imports =
      with (config.flake.modules.nixos);
      [
        base
        base-graphical
        kwallet

        mako
        nushell
        foot
        fuzzel
        waybar
        mpv
        nwg-bar
        zathura

        sway
        hyprland

        messaging
        tailscale
        gaming

        tuta
      ]
      ++ [
        {
          home-manager.users.thammachart.imports = with config.flake.modules.homeManager; [
            base
            base-graphical

            mako
            nushell
            foot
            fuzzel
            waybar
            mpv
            nwg-bar
            zathura

            go-config

            sway
            hyprland

            custom-scripts
            tuta
          ];
        }
      ];

}
