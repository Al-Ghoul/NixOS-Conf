{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brave
    discord
    neofetch

    obs-studio
    #obsidian # Insecure ?

    # Text colorizes for fish
    grc

    # Audio/Video player
    mpv

    # Pulseaudio command line mixer
    pamixer
    pavucontrol

    # library that sends desktop notifications to a notification daemon
    libnotify

    # Hyprland utils
    xdg-desktop-portal-hyprland

    # Clipboard manager
    cliphist
    wl-clipboard # required by cliphist

    # Screenshotting
    grim
    slurp # Area selection
    swappy # Annotations

    # Wallpaper
    swww
    lxappearance-gtk2

    # Entire screen sharing
    xwaylandvideobridge

    nixops_unstable
    virt-manager-qt

    lazydocker
  ];

}
