{
  flake.modules.nixos.hosts_hevonen-orbit = { pkgs, config, ... }:
  let
    gcloud = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]);
  in
  {
    conditions.isLaptop = true;

    boot.initrd.systemd.enable = true;
    # boot.kernelPackages = pkgs.linuxPackages_zen;

    users.users."${config.configData.username}".extraGroups = [ "docker" "kvm" ];

    environment.sessionVariables = {
      DEVSHELLS_PATH = "$HOME/shobshop-projects/common-dev-shells";
    };

    environment.systemPackages = (with pkgs; [
      gcloud
      doctl
      postgresql_17
      google-cloud-sql-proxy
      pgadmin4-desktopmode
      # rustdesk-flutter
      # bruno
      filezilla
      caddy
      libreoffice-fresh

      kubectl-cnpg
      cilium-cli

      # android-tools
      # android-studio
    ]);

    # sops.secrets.shobshop_internal_ca_cert = {
    #   format = "binary";
    #   sopsFile = "${nix-secrets}/shobshop/ca.crt";
    # };

    # security.pki.certificateFiles = [
    #   config.sops.secrets.shobshop_internal_ca_cert.path
    # ];
    #

    # services.auto-cpufreq = {
    #   enable = false;
    #   settings = {
    #     charger = {
    #       governor = "performance";
    #       turbo = "auto";
    #     };

    #     battery = {
    #       governor = "powersave";
    #       turbo = "auto";

    #       enable_thresholds = true;
    #       start_threshold = 30;
    #       stop_threshold = 80;
    #     };
    #   };
    # };
  };
}
