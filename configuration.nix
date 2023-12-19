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

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

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
    videoDrivers = [ "amdgpu" ];
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
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

