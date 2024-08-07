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
    
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gitalias = {
      url = "github:GitAlias/gitalias/main";
      flake = false;
    };
    
    nix-secrets = {
      url = "git+file:///data/nix-secrets?shallow=1&ref=main";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, disko, nixos-hardware, auto-cpufreq, chaotic, home-manager, sops-nix, nix-secrets, gitalias, ... } @ inputs: 
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
      system = value.system or defaultSystem;

      specialArgs = {
        inherit inputs;
        inherit nixos-hardware;
        inherit templateFile;
        inherit configData;
        inherit nix-secrets;

        inherit (value) isPersonal;
        inherit (value) isDesktop;
        hostName = name;
      };

      modules = [
        chaotic.nixosModules.default
        
        disko.nixosModules.disko

        sops-nix.nixosModules.sops
        
        auto-cpufreq.nixosModules.default

        ./hosts/${name}
        
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = { 
            inherit inputs;
            inherit templateFile;
            inherit configData;
            inherit nix-secrets;

            inherit gitalias;
        
            inherit (value) isPersonal;
            inherit (value) isDesktop;
          };
          
          home-manager.sharedModules = [
            sops-nix.homeManagerModules.sops
          ];

          home-manager.users."${configData.username}" = import ./home;
        }

      ];
    }) configData.hosts;
  };
}
