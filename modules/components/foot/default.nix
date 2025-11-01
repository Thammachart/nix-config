{
  flake.modules.homeManager.foot = { inputs, pkgs, config, configData, ... }:
  let
    cattpuccin = (readFile "${inputs.catppuccin-foot}/themes/catppuccin-frappe.ini");
    footconfig = (readFile (config.templateFile "foot-ini-${configData.username}" ./foot.ini.tmpl configData.homeSettings));
  in
  {
    home.file.".config/foot/foot.ini".text = ''
    ## Custom Config
    ${footconfig}

    ## Themes
    ${cattpuccin}
    '';
  };
}
