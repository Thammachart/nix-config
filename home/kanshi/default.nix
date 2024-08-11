{pkgs, hostName, ...}:
{
  home.file.".config/kanshi/config".source = ./${hostName};
}
