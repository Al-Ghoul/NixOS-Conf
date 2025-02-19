{ pkgs, ... }: {
  home.packages = with pkgs; [
    brave
    firefox-devedition

    obs-studio

    obsidian

    # Text colorizes for fish
    grc

    # Audio/Video player
    mpv

    # Pulseaudio command line mixer
    pamixer
    pavucontrol

    # library that sends desktop notifications to a notification daemon
    libnotify

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

    lazydocker

    spotify

    mdcat

    vesktop

    audacity

    telegram-desktop

    krita

    ardour
    talentedhack
    autotalent
    noise-repellent
    x42-plugins

    timidity

    pomodoro-gtk

    ghidra

    tmux-sessionizer

    remmina

    tree

    anydesk
  ];

}
