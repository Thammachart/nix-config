{ config, lib, pkgs, conditions, configData, ... }:
{
  flake.modules.nixos.hosts_hevonen-orbit.imports =
      with (config.flake.modules.nixos);
      [
        base
        base-graphical
        work
        kwallet

        mako
        nushell
        foot
        fuzzel
        waybar
        mpv
        nwg-bar

        sway
        hyprland
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

            go-config

            sway
            hyprland

            custom-scripts
          ];
        }
      ];

}
