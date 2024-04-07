{ pkgs, inputs, templateFile, configData, isDesktop, ...  }:

{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    # null or path, leave as null if you don't want hm to manage the config
    configDir = ./configs;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

  # home.file.".config/ags/config.js".source = ./config.js;
  # home.file.".config/ags/style.css".source = ./style.css;
}
