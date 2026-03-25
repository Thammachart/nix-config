{ config, lib, pkgs, conditions, configData, ... }:
{
  flake.modules.nixos.hosts_asiantuntija-orbit.imports =
      with (config.flake.modules.nixos);
      [
        base
        base-graphical

        tlp
        ananicy-cpp

        kwallet

        mako
        nushell

        fuzzel
        waybar
        ironbar
        mpv
        nwg-bar
        zathura

        sway
        hyprland
        niri

        messaging
        tailscale

        tuta
      ]
      ++ [
        {
          home-manager.users.thammachart.imports = with config.flake.modules.homeManager; [
            base
            base-graphical

            mako
            nushell

            ghostty
            fuzzel
            waybar
            ironbar
            mpv
            nwg-bar
            zathura
            vscodium

            go-config

            sway
            hyprland
            niri

            custom-scripts
            tuta
          ];
        }
      ];

}
