# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  nix = {
    settings = {
      # Enable Flakes and the new command-line tool
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "alghoul" ];
      sandbox = "relaxed";
      allowed-uris = [
        "https://"
        "github:NixOS/"
        "github:nixos/"
        "github:hercules-ci/"
        "github:numtide/"
        "github:cachix/"
        "github:nix-community/"
        "github:nix-systems/"
      ];

    };
    extraOptions = ''
      !include ${config.sops.templates."nix-extra-config".path}
    '';
    package = pkgs.nixVersions.nix_2_19;
    # NOTE: pin nix's nixpkgs to the exact version of nixpkgs used to build this config
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  fonts.packages =
    [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ amdvlk mesa rocmPackages.clr.icd ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
  };

  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

  # Fix swaylock's login failure with correct password
  security.pam.services.swaylock = { };

  networking = {
    hostName = "AlGhoul";
    networkmanager.enable = true;
    firewall.checkReversePath = false;
  };

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  security.polkit.enable = true;

  qt = {
    enable = true;
    style = "adwaita-dark";
    platformTheme = "qt5ct";
  };

  programs = {
    hyprland.enable = true;
    dconf.enable = true;
    thunar.enable = true;
    fish.enable = true;
    git = {
      enable = true;
      config = [{
        user = {
          email = "Abdo.AlGhouul@gmail.com";
          name = "Abdo .AlGhoul";
        };
      }];
    };
    virt-manager.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  # Allow non-free licensed programs
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-25.9.0" "nix-2.16.2" ];
      rocmSupport = true;
    };
  };

  environment.variables = {
    EDITOR = "nvim";
    ROC_ENABLE_PRE_VEGA = "1";
  };
  users.users = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    alghoul = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "wheel" "libvirtd" "docker" ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    pkgs.libsForQt5.qt5.qtgraphicaleffects
    (callPackage ./modules/nix-os/alghoul-sddm-theme.nix { })
    (easyeffects.overrideAttrs {
      preFixup =
        let
          lv2Plugins = [
            calf # compressor exciter, bass enhancer and others
            zam-plugins # maximizer
            lsp-plugins # delay, limiter, multiband compressor
            mda_lv2 # loudness
          ];
          ladspaPlugins = [
            (callPackage ./modules/nix-os/DeepFilterNet/deepfilter-ladspa.nix { })
          ];
        in
        ''
          gappsWrapperArgs+=(
          --set LV2_PATH "${lib.makeSearchPath "lib/lv2" lv2Plugins}"
          --set LADSPA_PATH "${lib.makeSearchPath "lib/ladspa" ladspaPlugins}"
          )
        '';
    })
    easyeffects
    sops
  ];

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" ];
      displayManager = {
        sddm = {
          enable = true;
          theme = "AlGhoul-SDDM-Theme";
          autoNumlock = true;
          settings = {
            Autologin = {
              Session = "hyprland";
              User = "alghoul";
            };
          };
        };
        defaultSession = "hyprland";
      };
    };
    # Screen sharing
    pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    hydra = {
      enable = true;
      port = 3333;
      hydraURL = "http://localhost:3333";
      notificationSender = "hydra@localhost";
      buildMachinesFiles = [ ];
      useSubstitutes = true;
      minimumDiskFree = 20;
      minimumDiskFreeEvaluator = 20;
      extraConfig = ''
        <git-input>
          timeout = 3600
        </git-input>

        Include "${config.sops.templates."hydra-github-token".path}"
      '';
    };
    postgresql = {
      ensureUsers = [{
        name = "alghoul";
        ensureClauses = {
          login = true;
          superuser = true;
          bypassrls = true;
          createdb = true;
          replication = true;
          createrole = true;
        };
      }];
      authentication = ''
        local   all             alghoul peer
      '';
    };
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/home/alghoul/.config/sops/age/keys.txt";
      generateKey = true;
    };
    secrets.github-token = { };
    templates = {
      "hydra-github-token" = {
        group = "hydra";
        mode = "440";
        content = ''
          <github_authorization>
            Al-Ghoul = Bearer ${config.sops.placeholder.github-token}
          </github_authorization>
        '';
      };
      "nix-extra-config" = {
        group = "hydra";
        mode = "440";
        content =
          "access-tokens = github.com=${config.sops.placeholder.github-token}";
      };

    };
  };

  systemd = {
    timers."kb-led-timer" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "5m";
        Unit = "kb-led.service";
      };
    };
    services."kb-led" = {
      script = ''
        ${pkgs.coreutils}/bin/echo 1 > /sys/class/leds/*::scrolllock/brightness
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  system.stateVersion = "23.11";
}
