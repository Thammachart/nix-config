{lib, conditions,...}:
lib.mkIf conditions.graphicalUser {
  home.file.".config/mpv/mpv.conf".source = ./mpv.conf;
  home.file.".config/mpv/input.conf".source = ./input.conf;
}
