{pkgs, lib, conditions, hostName, ...}:
lib.mkIf conditions.graphicalUser {
  home.file.".config/kanshi/config".source = ./${hostName};
}
