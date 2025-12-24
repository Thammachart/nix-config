{ inputs, ... }:
let
  username = "thammachart";
in
{
  flake.modules.nixos.base = { pkgs, lib, ... }:
    {
      imports = [
        ./utilities.nix
        inputs.auto-cpufreq.nixosModules.default
        inputs.sops-nix.nixosModules.sops
      ];

      boot = {
        initrd.systemd.enable = lib.mkDefault false;
        # initrd.verbose = false;
        kernel.sysctl = {
          "kernel.sysrq" = lib.mkDefault 1;
          "vm.max_map_count" = 1048576;
        };
        kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
          timeout = 0;
        };
        tmp = {
          cleanOnBoot = true;
        };
      };

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "wheel" "network" "networkmanager" "audio" "video" "storage" "input" ];

        shell = pkgs.nushell;

        packages = with pkgs; [];
      };

      time = {
        timeZone = "Asia/Bangkok";
      };

      i18n = {
        defaultLocale = "en_SG.UTF-8";
        extraLocaleSettings = {
          # https://metacpan.org/dist/DateTime-Locale/view/lib/DateTime/Locale/en_IE.pod
          LC_TIME = "en_IE.UTF-8";
        };
      };

      security.polkit.enable = true;

      services.pulseaudio.enable = false;

      security.sudo-rs = {
        enable = true;
        wheelNeedsPassword = true;
        execWheelOnly = true;
      };

      security.doas = {
        enable = false;
        wheelNeedsPassword = true;
      };

      environment.systemPackages = with pkgs; [
        btop
        lm_sensors
        vim helix kakoune
        curl wget
        xdg-user-dirs
        bash zsh
        gnumake git git-cliff lazygit
        fastfetch gomplate
        duf bat ripgrep fd
        gping doggo
        dive
        openssl
        unzip p7zip
        htop bottom procs
        nmap
        dbus
        age sops
        # devenv

        yazi

        just
        lshw
        starship
        cmatrix
        # yubikey-manager

        gh
        curlie

        psmisc
        pciutils

        kubectl
        kubernetes-helm
        k9s

        ## Nix Tools for Contribution
        nurl
      ];

    services.dbus = {
      enable = true;
    };

    services.scx = {
      enable = lib.mkDefault false;
      scheduler = lib.mkDefault "scx_rustland";
    };

    services.udisks2 = {
      enable = true;
      settings = {
      	"mount_options.conf" = {
		     defaults = {
					   btrfs_defaults = "compress=zstd";
			   };
        };
      };
    };

    services.fstrim = {
      enable = true;
      interval = "weekly";
    };

    services.journald.extraConfig = ''
    SystemMaxUse=5G
    MaxRetentionSec=2week
    '';

    services.zram-generator = {
      enable = true;
      settings = {
        zram0 = {
          zram-size = "ram / 2";
        };
      };
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    virtualisation.docker = {
      enable = lib.mkDefault true;
      # enableOnBoot = conditions.isServer;
      storageDriver = "btrfs";
    };

    virtualisation.containers = {
      enable = lib.mkDefault true;
      containersConf.settings = {
        engine = {
          compose_warning_logs = false;
          compose_providers = [ "${pkgs.podman-compose}/bin/podman-compose" ];
        };
      };
      storage.settings = {};
    };

    virtualisation.podman = {
      enable = lib.mkDefault true;
    };

    services.openssh.hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    environment.sessionVariables = {
      "GSK_RENDERER" = "ngl";
      # "ALACRITTY_SOCKET" = "$XDG_RUNTIME_DIR/alacritty-default.sock";
    };

    environment.localBinInPath = true;

    systemd.user.targets = {
      "user-system-ready" = {
        description = "Custom systemd target to signify system being ready for user";
      };
    };

    services.logind.settings.Login.HandleLidSwitch = lib.mkDefault "suspend";

    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.
    # system.copySystemConfiguration = true;

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
