{ config, lib, nix-secrets, ... }:
{
  sops = {
    secrets = {
      github = {
        sopsFile = nix-secrets + /_common/github.yml;
      };
    };
  };
}