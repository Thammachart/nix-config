{ config, ... }:
{
  flake.modules.nixos.hosts_kenguru-pivot = { ... }: {
    imports = with (config.flake.modules.nixos); [
      base
      base-server

      ssh
      tailscale
    ]
    ++ [
      {
        home-manager.users.thammachart.imports = with config.flake.modules.homeManager; [
          base
          nushell
        ];
      }
    ];
  };
}
