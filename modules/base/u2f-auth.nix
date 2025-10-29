{ lib, ... }:
{
  flake.modules.nixos.base = { config, hostConfig, ... }:
  let
    u2fEnabled = hostConfig.u2fConfig != [];
  in
  {
    security.pam.services = {
      login.u2fAuth = u2fEnabled;
      sudo.u2fAuth = u2fEnabled;
    };

    security.pam.u2f = {
      enable = u2fEnabled;
      settings = {
        interactive = false;
        cue = true;

        origin = "pam://${hostName}";
        authfile = pkgs.writeText "u2f-mappings" (lib.concatStrings ([ configData.username ] ++ hostConfig.u2fConfig) );
      };
    };
  };
}
