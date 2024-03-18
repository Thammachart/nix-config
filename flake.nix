# vim:ts=2:sw=2:sts=2:et:si
{
  description = "Thammachart's NixOS Flake";
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gitalias = {
      url = "github:GitAlias/gitalias/main";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, gitalias, ... } @ inputs: 
  let
    defaultSystem = "x86_64-linux";
    pkgs = import nixpkgs { 
      system = defaultSystem; 
      config = {
        allowUnfree = true;
      };
    };
    pkgs-stable = import nixpkgs-stable { 
      system = defaultSystem;
      config = {
        allowUnfree = true;
      };
    };
    configData = import ./config-data.nix;
    templateFile = import ./utils/template-engine.nix { inherit pkgs; };
  in
  {
    nixosConfigurations = builtins.mapAttrs (name: value: nixpkgs.lib.nixosSystem {
      system = defaultSystem;

      specialArgs = {
        inherit pkgs-stable;
        inherit nixos-hardware;
        inherit templateFile;
        inherit configData;

        inherit (value) isPersonal;
        inherit (value) isDesktop;
        hostName = name;
      };

      modules = [
        ./hosts/${name}

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = { 
            inherit inputs;
            inherit pkgs-stable;
            inherit templateFile;
            inherit configData;

            inherit gitalias;
        
            inherit (value) isPersonal;
            inherit (value) isDesktop;
          };
          home-manager.users."${configData.username}" = import ./home;
        }
      ];
    }) configData.hosts;
  };
}
