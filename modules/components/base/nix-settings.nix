{ inputs, ... }:
{

  flake.modules.nixos.base = { pkgs, lib, config, ... }: {
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
