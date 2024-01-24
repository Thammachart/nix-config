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
    pkgs-unstable = import nixpkgs-unstable { system = defaultSystem; };
  in
  {
    nixosConfigurations = {
      "tiikeri-pivot" = nixpkgs.lib.nixosSystem rec {
        system = defaultSystem;

        specialArgs = {
          inherit pkgs-unstable;
        };

        modules = [
	        ./hosts/tiikeri-pivot

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = { 
              inherit inputs;
              inherit pkgs-unstable;

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
