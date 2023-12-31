# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  nix.settings = {
    # Enable Flakes and the new command-line tool
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ 
      "root"
      "alghoul"
    ];
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true; 
      extraPackages = [ pkgs.amdvlk pkgs.mesa ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
  };


  # Fix swaylock's login failure with correct password
  security.pam.services.swaylock = {};

  networking.hostName = "AlGhoul"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Enable the X11 windowing system.
  services.xserver = { 
    enable = true;
    videoDrivers = [ "modesetting" ];
    displayManager = {
      sddm = {
        enable = true;
        theme = "AlGhoul-SDDM-Theme";
      };
      defaultSession = "hyprland";
    };
  };

  security.polkit.enable = true;

  qt = {
    enable = true;
    style = "adwaita-dark";
    platformTheme = "qt5ct";
  };

  programs.hyprland.enable = true;

  # Screen sharing
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  programs.thunar.enable = true;

  # Allow non-free licensed programs
  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.variables.EDITOR = "nvim";

  programs.dconf.enable = true;

  programs.fish.enable = true;
  users.users.alghoul.shell = pkgs.fish;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alghoul.isNormalUser = true;
  users.users.alghoul.extraGroups = [ "wheel" ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    pkgs.libsForQt5.qt5.qtgraphicaleffects
    (callPackage ./modules/nix-os/alghoul-sddm-theme.nix {})
    (easyeffects.overrideAttrs
    {
      preFixup = let
        lv2Plugins = [
          calf # compressor exciter, bass enhancer and others
          zam-plugins # maximizer
        ];
        ladspaPlugins = [
          (callPackage ./modules/nix-os/DeepFilterNet/deepfilter-ladspa.nix {})
        ];
      in ''
        gappsWrapperArgs+=(
        --set LV2_PATH "${lib.makeSearchPath "lib/lv2" lv2Plugins}"
        --set LADSPA_PATH "${lib.makeSearchPath "lib/ladspa" ladspaPlugins}"
        )
      '';
    })
    easyeffects
  ];
  
  services.hydra = {
    enable = true;
    port = 3333;
    hydraURL = "http://localhost:3333";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
    minimumDiskFree = 20;
    minimumDiskFreeEvaluator = 20;
    extraConfig = ''
      <git-input>
        timeout = 3600
      </git-input>
    '';
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = "alghoul";
        ensureClauses = {
          login = true;
          superuser = true;
          bypassrls = true;
          createdb = true;
          replication = true;
          createrole = true;
        };
      }
    ];
    authentication = ''
      local   all             alghoul peer
    '';
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

