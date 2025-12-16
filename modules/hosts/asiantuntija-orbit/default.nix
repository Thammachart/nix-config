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
