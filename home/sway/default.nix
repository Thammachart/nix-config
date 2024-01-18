{ pkgs, config, ...  }:

let
  settings = {
    browser = "firefox";
  }; in
{
  home.file.".config/sway/config".source = ./config;
  home.file.".config/sway/variables".source = templatefile "sway-vars" ./variables.tmpl settings;
  home.file.".config/sway/theme".source = ./theme;
}
