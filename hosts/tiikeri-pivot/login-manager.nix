{ config, lib, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember-session --user-menu";
      user = "greeter";
    };
  };
}
