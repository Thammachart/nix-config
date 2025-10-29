{ inputs, ... }:
{
  flake.modules.nixos.base = { config, ... }:
  {
    sops = {
      age = {
        # sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        keyFile = "/var/lib/sops-nix/host.txt";
        generateKey = true;
      };

      secrets = {
        github_access_token = {
          key = "access_token";
          sopsFile = "${inputs.nix-secrets}/_common/github.yml";
        };
      };

      templates."nix.conf" = {
        content = ''
        access-tokens = github.com=${config.sops.placeholder.github_access_token}
        '';
        mode = "0440";
        owner = "root";
        group = "wheel";
      };
    };

    environment.etc = {
      "xdg/nix/nix.conf".source = config.sops.templates."nix.conf".path;
    };
  };
}
