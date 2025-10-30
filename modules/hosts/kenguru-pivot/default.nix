{ config, ... }:
{

  flake.modules.nixos.hosts_kenguru-pivot.imports =
    with (config.flake.modules.nixos);
    [
      base
      server
    ]
    ++ [
      {
        home-manager.users.thammachart.imports = with config.flake.modules.homeManager; [
          base
          nushell
        ];
      }
    ];
}
