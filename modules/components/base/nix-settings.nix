{ inputs, ... }:
{

  flake.modules.nixos.base = { pkgs, lib, config, ... }: {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      inputs.self.overlays.default
    ];

    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
      };

      gc = {
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "weekly";
        options = lib.mkDefault "--delete-older-than 7d";
      };
    };
  };
}
