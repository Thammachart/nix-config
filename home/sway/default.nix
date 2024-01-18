{ pkgs, config, settings, username, ...  }:

let
  t = import ../../packages/template-engine.nix {pkgs = pkgs;};
in
{
  home.file.".config/sway/config".source = ./config;
  home.file.".config/sway/variables".source = t.templateFile "sway-vars-${config.username}" ./variables.tmpl config.homeSettings;
  home.file.".config/autostart".source = t.templateFile "sway-autostart-${config.username}" ./autostart.tmpl config.homeSettings;
  home.file.".config/sway/theme".source = ./theme;
}
