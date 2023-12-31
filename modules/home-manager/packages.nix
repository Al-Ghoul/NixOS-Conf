{ pkgs, ... }:
{
  home.packages = [
    pkgs.brave
    pkgs.discord
    pkgs.neofetch

    pkgs.obs-studio
    #pkgs.obsidian # Insecure ?

    # Text colorizes for fish
    pkgs.grc

    # Audio/Video player
    pkgs.mpv

    # Pulseaudio command line mixer
    pkgs.pamixer
    pkgs.pavucontrol
   
    # library that sends desktop notifications to a notification daemon
    pkgs.libnotify

    # Hyprland pkgs/utils
    pkgs.xdg-desktop-portal-hyprland
    
    # Clipboard manager
    pkgs.cliphist
    pkgs.wl-clipboard # required by cliphist
    
    # Screenshotting
    pkgs.grim   
    pkgs.slurp  # Area selection
    pkgs.swappy # Annotations

    # Wallpaper
    pkgs.swww
    pkgs.lxappearance-gtk2
  ];

}
