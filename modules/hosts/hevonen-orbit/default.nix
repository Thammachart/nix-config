{ config, lib, pkgs, conditions, configData, ... }:
{
  flake.modules.nixos.hosts_hevonen-orbit.imports =
      with (config.flake.modules.nixos);
      [
        base
        base-graphical

        tlp
        ananicy-cpp

        work
        kwallet

        mako
        nushell

        fuzzel
        waybar
        mpv
        nwg-bar
        zathura

        sway
        hyprland
        niri
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
            mpv
            nwg-bar
            zathura
            vscodium

            go-config

            sway
            hyprland
            niri

            custom-scripts
          ];
        }
      ];

}
