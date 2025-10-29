{ config, ... }:
{

  flake.modules.nixos."hosts/kenguru-pivot".imports =
    with (config.flake.modules.nixos);
    [
      import ./_disko-fs.nix
      base
      server
      "users/thammachart"
    ]
    ++ [
      {
        home-manager.users.thammachart.imports = with config.flake.modules.homeManager; [
          base
        ];
      }
    ];
}
