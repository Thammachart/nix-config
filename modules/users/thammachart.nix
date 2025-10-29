{ ... }:
let
  username = "thammachart";
in
{
  flake.modules.nixos."users_thammachart" = { pkgs, ... }:
  {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."${username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "network" "networkmanager" "audio" "video" "storage" "input" ];

      shell = pkgs.nushell;

      packages = with pkgs; [];
    };

    home-manager.users."${username}" = import ../../home;
  };
}
