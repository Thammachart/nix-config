# vim:ts=2:sw=2:sts=2:et:si
{
  description = "Thammachart's NixOS Flake";
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ...}@inputs: {
    nixosConfigurations = {
      "tiikeri-pivot" = nixpkgs.lib.nixosSystem {
        system = "X86_64-linux";
        modules = [
	        ./hosts/tiikeri-pivot
	      ];
      };
    };
  };
}
