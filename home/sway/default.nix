{ pkgs, config, ...  }:

{
  home.file.".config/sway/config".source = ./config;
  home.file.".config/sway/variables".source = ./variables.tmpl;
  home.file.".config/sway/theme".source = ./theme;
}
