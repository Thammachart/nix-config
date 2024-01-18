{ pkgs, isDesktop, ...  }:

let
  config = import ../config.nix;
  templateFile = import ../utils/template-engine.nix {pkgs=pkgs;};
in
{
  home.file.".config/sway/config".source = ./config;
  home.file.".config/sway/variables".source = templateFile "sway-vars-${config.username}" ./variables.tmpl config.homeSettings;
  home.file.".config/sway/autostart".source = templateFile "sway-autostart-${config.username}" ./autostart.tmpl config.homeSettings;
  home.file.".config/sway/inputs".source = templateFile "sway-inputs-${config.username}" ./inputs.tmpl { isDesktop = isDesktop; };
  home.file.".config/sway/theme".source = ./theme;
}
