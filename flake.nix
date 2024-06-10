# vim:ts=2:sw=2:sts=2:et:si
{
  description = "Thammachart's NixOS Flake";
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      # inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows = "home-manager";
    };
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";

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

  outputs = { self, nixpkgs, nixos-hardware, chaotic, home-manager, agenix, gitalias, ... } @ inputs: 
  let
    defaultSystem = "x86_64-linux";
    pkgs = import nixpkgs { 
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
        inherit inputs;
        inherit nixos-hardware;
        inherit templateFile;
        inherit configData;

        inherit (value) isPersonal;
        inherit (value) isDesktop;
        hostName = name;
      };

      modules = [
        agenix.nixosModules.default
        chaotic.nixosModules.default

        ./hosts/${name}
        
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = { 
            inherit inputs;
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
