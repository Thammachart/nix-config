{ pkgs, config, lib, ... }:
let
  fhs = pkgs.buildFHSEnv {
    name = "fhs";
    targetPkgs = pkgs: (
      # pkgs.buildFHSUserEnv provides only a minimal FHS environment,
      # lacking many basic packages needed by most software.
      # Therefore, we need to add them manually.
      #
      # pkgs.appimageTools provides basic packages required by most software.
      (base.targetPkgs pkgs) ++
      (with pkgs; [
        pkg-config
        ncurses
        nushell
        # Feel free to add more packages here if needed.
      ])
    );
    profile = "export FHS=1";
    runScript = "nu";
    extraOutputsToInstall = ["dev"];
  };
in
  fhs
