{ pkgs, lib, conditions, templateFile, configData, catppuccin-foot, ...  }:
let
  cattpuccin = (builtins.readFile "${catppuccin-foot}/themes/catppuccin-frappe.ini");
  footconfig = (builtins.readFile (templateFile "foot-ini-${configData.username}" ./foot.ini.tmpl configData.homeSettings));
in
lib.mkIf conditions.graphicalUser {
  home.file.".config/foot/foot.ini".text = ''
  ## Custom Config
  ${footconfig}

  ## Themes
  ${cattpuccin}
  '';
}
