{ lib, ... }:
{
  flake.modules.nixos.base = { pkgs, config, hostConfig, hostname, ... }:
  let
    username = config.configData.username;
    u2fEnabled = hostConfig.u2f != [];
  in
  {
    security.pam.services = {
      login.u2fAuth = u2fEnabled;
      sudo.u2fAuth = u2fEnabled;
      polkit-1.u2fAuth = u2fEnabled;
    };

    security.pam.u2f = {
      enable = u2fEnabled;
      settings = {
        interactive = false;
        cue = true;

        origin = "pam://${hostname}";
        authfile = pkgs.writeText "u2f-mappings" (lib.concatStrings ([ username ] ++ hostConfig.u2f) );
      };
    };
  };
}
