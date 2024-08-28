{ config, nix-secrets, ... }:
{
  sops = {
    secrets = {
      shobshop_internal_ca_cert = {
      sopsFile = "${nix-secrets}/shobshop/ca.crt";
      };
    };
  };
}
