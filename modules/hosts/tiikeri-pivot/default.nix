{ config, lib, pkgs, conditions, configData, ... }:
{
  flake.modules.nixos.hosts_tiikeri-pivot.imports =
      with (config.flake.modules.nixos);
      [
        base
        base-graphical
        kwallet
        waybar

        messaging
        tailscale
        gaming
      ]
      ++ [
        {
          home-manager.users.thammachart.imports = with config.flake.modules.homeManager; [
            base
            base-graphical

            foot
            fuzzel
            nushell
            sway-config
            waybar
          ];
        }
      ];

}
