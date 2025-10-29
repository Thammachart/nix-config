{ ... }:
{
  flake.modules.nixos.gaming = { pkgs, ... }:
  {
    programs.gamemode = {
      enable = true;
    };

    programs.steam = {
      enable = true;

      # Unsetting TZ env means 2 conflicting things:
      # - Proton and games themselves will use correct timezone, corresponding to Linux System Timezone: https://github.com/NixOS/nixpkgs/issues/279893#issuecomment-1883875778
      # - Steam itself will show incorrect timezone (always defaulted to UTC) in gameoverlay: https://github.com/ValveSoftware/steam-for-linux/issues/10057
      # package = pkgs.steam-small.override {
      #   extraProfile = ''
      #   unset TZ;
      #   '';
      # };
      package = pkgs.steam;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
}
