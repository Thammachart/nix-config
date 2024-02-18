# vim:ts=2:sw=2:sts=2:et:si
{
  description = "Thammachart's NixOS Flake";
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... } @ inputs: 
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
    nixosConfigurations = {
      "tiikeri-pivot" = nixpkgs.lib.nixosSystem rec {
        system = defaultSystem;

        specialArgs = {
          inherit pkgs-stable;
          inherit templateFile;
          inherit configData;

          isPersonal = true;
          isDesktop = true;
        };

        modules = [
	        ./hosts/tiikeri-pivot

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = { 
              inherit inputs;
              inherit pkgs-stable;
              inherit templateFile;
              inherit configData;

              isPersonal = specialArgs.isPersonal;
              isDesktop = specialArgs.isDesktop;
            };
            home-manager.users."${configData.username}" = import ./home;
          }
	      ];
      };
      "majava-orbit" = nixpkgs.kib.nixosSystem rec {};
    };
  };
}
