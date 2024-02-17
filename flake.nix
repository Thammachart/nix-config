# vim:ts=2:sw=2:sts=2:et:si
{
  description = "Thammachart's NixOS Flake";
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: 
  let
    defaultSystem = "x86_64-linux";
    pkgs = import nixpkgs { 
      system = defaultSystem; 
      allowUnfree = true; 
    };
    pkgs-unstable = import nixpkgs-unstable { 
      system = defaultSystem;
      allowUnfree = true;
    };
    templateFile = import ./utils/template-engine.nix { inherit pkgs; };
  in
  {
    nixosConfigurations = {
      "tiikeri-pivot" = nixpkgs.lib.nixosSystem rec {
        system = defaultSystem;

        specialArgs = {
          inherit pkgs-unstable;
          inherit templateFile;
        };

        modules = [
	        ./hosts/tiikeri-pivot

          import ./overlays/mesa.nix {inherit pkgs-unstable}

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = { 
              inherit inputs;
              inherit pkgs-unstable;
              inherit templateFile;

              isPersonal = true;
              isDesktop = true;
              homeConfig = import ./home/config.nix;
            };
            home-manager.users.thammachart = import ./home;
          }
	      ];
      };
    };
  };
}
