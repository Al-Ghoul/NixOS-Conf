{ config, lib, pkgs, ...} :

{
  imports = [ 
    ./modules/home-manager/neovim.nix
  ];

  home.username = "alghoul";
  home.homeDirectory = "/home/alghoul";

  programs.git = {
    enable = true;
    userName = "Abdo .AlGhoul";
    userEmail = "Abdo.AlGhouul@gmail.com";
  };

  home.packages = with pkgs; [
    pkgs.brave
    pkgs.discord
    pkgs.neofetch

    pkgs.obs-studio
#    pkgs.obsidian
    pkgs.easyeffects

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

    # Application Launcher
    pkgs.wofi
  ];


  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      format = lib.concatStrings [
        "[░▒▓](#352727)"
          "[ ](bg:#836363 fg:#4e0404)"
          "[](bg:#836363 fg:#836363)"
          "$directory"
          "[](fg:#836363 bg:#493737)"
          "$git_branch"
          "$git_status"
          "[](fg:#493737 bg:#3a2c2c)"
          "[](fg:#3a2c2c bg:#2c2121)"
          "[ ](fg:#2c2121)"
          "\n$character"
      ];
      directory = {
        style = "fg:#e3e5e5 bg:#836363";
        format = lib.concatStrings [
          "[ $path ]"
            "($style)"
        ];
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      directory.substitutions = {
        Documents = " ";
        Downloads = " ";
        Music = " ";
        Pictures = " ";
      };

      git_branch = { 
        symbol = "";
        style = "bg:#394260";
        format = lib.concatStrings [
          "[[ $symbol $branch ](fg:#000000 bg:#493737)]"
            "($style)"
        ];
      };
      git_status = { 
        style = "bg:#394260";
        format = lib.concatStrings [ 
          "[[($all_status$ahead_behind )](fg:#FFFFFF bg:#493737)]"
          "($style)"
        ];
      };
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      starship init fish | source
      '';
    plugins = [
    # Enable a plugin (here grc for colorized command output) from nixpkgs
    { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    # Manually packaging and enable a plugin
    {
      name = "z";
      src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
        sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
      };
    }
    ];
  };

  programs.kitty = {
    enable = true;
    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
      name = "jetbrains mono nerd font";
    };
    settings = {
      background_opacity = 0;
    };
    theme = "Hachiko";
    keybindings = {
      "ctrl+right" = "resize_window narrower";
      "ctrl+left" = "resize_window wider";
      "ctrl+up" = "resize_window taller";
      "ctrl+down" = "resize_window shorter";
      "ctrl+home" = "resize_window reset";
      "ctrl+shift+t" = "new_tab_with_cwd";
    };
    shellIntegration = {
      enableFishIntegration = true;
    };
  };


  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig = ''
      monitor=DP-1,1920x1080@60,0x0,1

      exec-once = swww init  # Wall paper
      exec-once = mako # Notifications 
      exec-once = waybar # Staus bar 
      exec-once = wl-paste --watch cliphist store # Clipboard

      input {
        kb_layout = us, ara
          kb_variant =
          kb_model =
          kb_options = grp:alt_shift_toggle

          kb_rules =

          follow_mouse = 1

          touchpad {
            natural_scroll = no
          }

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

    general {
      gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)

        layout = dwindle

        allow_tearing = false
    }

    misc {
      disable_hyprland_logo = yes
    }

    decoration {
      rounding = 10

        blur {
          enabled = true
            size = 5
            passes = 1
            new_optimizations = true
        }


      blurls = lockscreen


        drop_shadow = yes
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
    }

    animations {
      enabled = yes

# Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    dwindle {
      pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = yes # you probably want this
    }

    master {
      new_is_master = true
    }

    gestures {
      workspace_swipe = off
    }

    misc {
      force_default_wallpaper = -1 # Set to 0 to disable the anime mascot wallpapers
    }

# Example per-device config
device:epic-mouse-v1 {
         sensitivity = -0.5
       }

# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

# Kitty animation/opacity
       windowrulev2 = opacity 0.8 0.8,class:^(kitty)$
                                              windowrulev2 = animation popin,class:^(kitty)$,title:^(update-sys)$1
# Brave
                                                                                     windowrulev2 = opacity 0.8 0.8,class:^(brave)$
                                                                                                                            windowrulev2 = animation popin,class:^(brave)$


# Thunar animation/opacity
                                                                                                                                                                   windowrulev2 = animation popin,class:^(thunar)$
                                                                                                                                                                                                          windowrulev2 = opacity 0.8 0.8,class:^(thunar)$

# Wofi animation/opacity
                                                                                                                                                                                                                                                 windowrulev2 = move cursor -3% -105%,class:^(wofi)$
                                                                                                                                                                                                                                                                                              windowrulev2 = noanim,class:^(wofi)$
                                                                                                                                                                                                                                                                                                                            windowrulev2 = opacity 0.8 0.6,class:^(wofi)$

                                                                                                                                                                                                                                                                                                                                                                   $mainMod = SUPER

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, Q, exec, kitty
      bind = $mainMod, F4, killactive, # close the active window
      bind = $mainMod, ', exit, 
      bind = $mainMod, L, exec, swaylock # Lock the screen
      bind = $mainMod, E, exec, thunar # Show the graphical file browser
      bind = $mainMod, V, togglefloating, 
      bind = $mainMod, SPACE, exec, wofi # Show the graphical app launcher
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle
      bind = ALT, V, exec, cliphist list | wofi -dmenu | cliphist decode | wl-copy # open clipboard manager
      bind = $mainMod, M, exec, wlogout --protocol layer-shell # show the logout window
      bind = $mainMod, S, exec, grim -g "$(slurp)" - | swappy -f - # take a screenshot


# Move focus with mainMod + arrow keys
                                                                                                                                                                                                                                                                                                                                                                   bind = $mainMod, left, movefocus, l
                                                                                                                                                                                                                                                                                                                                                                   bind = $mainMod, right, movefocus, r
                                                                                                                                                                                                                                                                                                                                                                   bind = $mainMod, up, movefocus, u
                                                                                                                                                                                                                                                                                                                                                                   bind = $mainMod, down, movefocus, d

# workspaces
# binds $mainMod + [shift +] {1..10} to [move to] workspace {1..10}
                                                                                                                                                                                                                                                                                                                                                                   ${builtins.concatStringsSep "\n" (builtins.genList (
                                                                                                                                                                                                                                                                                                                                                                         x: let
                                                                                                                                                                                                                                                                                                                                                                         ws = let
                                                                                                                                                                                                                                                                                                                                                                           c = (x + 1) / 10;
                                                                                                                                                                                                                                                                                                                                                                           in
                                                                                                                                                                                                                                                                                                                                                                           builtins.toString (x + 1 - (c * 10));
                                                                                                                                                                                                                                                                                                                                                                           in ''
                                                                                                                                                                                                                                                                                                                                                                           bind = $mainMod, ${ws}, workspace, ${toString (x + 1)}
                                                                                                                                                                                                                                                                                                                                                                           bind = $mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
                                                                                                                                                                                                                                                                                                                                                                           ''
                                                                                                                                                                                                                                                                                                                                                                           )
                                                                                                                                                                                                                                                                                                                                                                         10)}

# Example special workspace (scratchpad)
       bind = $mainMod, S, togglespecialworkspace, magic
         bind = $mainMod SHIFT, S, movetoworkspace, special:magic

# Scroll through existing workspaces with mainMod + scroll
         bind = $mainMod, mouse_down, workspace, e+1
         bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
         bindm = $mainMod, mouse:272, movewindow
         bindm = $mainMod, mouse:273, resizewindow
         '';
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 22;
        output = [
          "eDP-1"
          "HDMI-A-1"
        ];
        modules-left = [ 
        "custom/power_btn"
        "custom/lock_screen"
        "custom/kb_bk_light"
        ];
        modules-center = [ "clock" ];
        modules-right = [
        "cpu"
        "network"
        "pulseaudio" 
        "pulseaudio#microphone"
        "tray"
        "temperature"
        "hyprland/language"
        ];

        "custom/power_btn" = {
          format = "";
          on-click = "sh -c '(sleep 0.5s; wlogout --protocol layer-shell)' & disown";
          tooltip = false;
        };

        "custom/lock_screen" = {
          format = "";
          on-click = "sh -c '(sleep 0.5s; swaylock)' & disown";
          tooltip = false;
        };

        "custom/kb_bk_light" = {
          format = "";
          # Normally this would work, but at this point it requires root permission since /sys is read-only
          on-click = "sudo echo 1 > /sys/class/leds/input3::scrolllock/brightness";
          tooltip = false;
        };

        cpu = {
          interval = 2;
          format = "";
          max-length = 10;
          format-alt-click = "click-right";
          format-alt = "  {usage}%";
        };

        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "{ipaddr}/{cidr}";
          tooltip-format = "{essid} - {ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}:{essid} {ipaddr}/{cidr}";
        };

        tray = {
          icon-size = 16;
          spacing = 10;
        };

        pulseaudio = {
          format = "{icon}";
          format-muted = "";
          on-click = pkgs.writeShellScript "toggle-sound" ''
            if [ "$(pamixer --get-mute)" == "false" ]; then
              pamixer -m
            elif [ "$(pamixer --get-mute)" == "true" ]; then
              pamixer -u
            fi
          '';
          scroll-step = 5;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          tooltip = true;
          tooltip-format  = "{icon} at {volume}%";
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = "";
          format-source-muted= "";
          on-click = pkgs.writeShellScript "toggle-mic" ''
            if [ "$(pamixer --default-source --get-mute)" == "false" ]; then
              pamixer --default-source -m
            elif [ "$(pamixer --default-source --get-mute)" == "true" ]; then
                pamixer -u --default-source u
            fi
          '';
          on-scroll-down = pkgs.writeShellScript "dec-mic-vol" ''
            pamixer --default-source -d 5 && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "" "Mic-Level : $(pamixer --default-source --get-volume) %"
          '';
          on-scroll-up = pkgs.writeShellScript "inc-mic-vol" ''
            pamixer --default-source -i 5 && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "" "Mic-Level : $(pamixer --default-source --get-volume) %"
          '';
           tooltip = true;
           tooltip-format  = " at {volume}%";
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-weight: bold;
        font-size: 16px;
        min-height: 0;
      }

    window#waybar {
      background: rgba(21, 18, 27, 0);
      color: #f6f7fc;
    }

    tooltip {
      background: #1e1e2e;
      opacity: 0.8;
      border-radius: 10px;
      border-width: 2px;
      border-style: solid;
      border-color: #11111b;
    }

    tooltip label {
     color: #cdd6f4;
    }

    #custom-lock_screen,
    #custom-power_btn,
    #custom-kb_bk_light,
    #window,
    #cpu,
    #disk,
    #memory,
    #clock,
    #pulseaudio,
    #temperature,
    #network,
    #tray {
      background: rgba(21, 18, 27, 0);
      opacity: 1;
      padding: 0px 8px;
      margin: 0px 3px;
      border: 0px;
    }
    '';
  };

  services.mako = {
    enable = true;
    font = "Fantasque Sans Mono 14";
    anchor = "center";
    defaultTimeout = 5000;
    sort = "-time";

    backgroundColor = "#1e1e2e";
    borderColor = "#313244";
    progressColor = "over #89b4fa";
    textColor = "#d9e0ee";
    padding = "15";
    borderSize = 2;
    borderRadius = 10;
    maxIconSize = 48;

    extraConfig = ''
      max-history=100
      # BINDING OPTIONS
      on-button-left=dismiss
      on-button-middle=none
      on-button-right=dismiss-all
      on-touch=dismiss

      [urgency=low]
      border-color=#313244
      default-timeout=2000

      [urgency=normal]
      border-color=#313244
      default-timeout=5000

      [urgency=high]
      border-color=#f38ba8
      text-color=#f38ba8
      default-timeout=0

      [category=mpd]
      border-color=#f9e2af
      default-timeout=2000
      group-by=category

      icon-location=left
      history=1
      text-alignment=center
      ignore-timeout=0
      layer=overlay
    '';
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
    daemonize = true;
    show-failed-attempts = true;
    clock = true;
    screenshot = true;
    effect-blur="9x5";
    effect-vignette="0.5:0.5";
    color="1f1d2e80";
    font="Inter";
    indicator=true;
    indicator-radius=200;
    indicator-thickness=20;
    line-color="1f1d2e";
    ring-color="191724";
    inside-color="1f1d2e";
    key-hl-color="eb6f92";
    separator-color="00000000";
    text-color="e0def4";
    text-caps-lock-color="";
    line-ver-color="eb6f92";
    ring-ver-color="eb6f92";
    inside-ver-color="1f1d2e";
    text-ver-color="e0def4";
    ring-wrong-color="31748f";
    text-wrong-color="31748f";
    inside-wrong-color="1f1d2e";
    inside-clear-color="1f1d2e";
    text-clear-color="e0def4";
    ring-clear-color="9ccfd8";
    line-clear-color="1f1d2e";
    line-wrong-color="1f1d2e";
    bs-hl-color="31748f";
    grace=2;
    grace-no-mouse = true;
    grace-no-touch = true;
    datestr="%a, %B %e";
    timestr="%I:%M %p";
    fade-in=0.2;
    ignore-empty-password = true;
    };
  };

  programs.wlogout = {
    enable = true;
    layout = [
    {
      label = "lock";
      action = "swaylock";
      text = "Lock";
    }

    {
      label = "hibernate";
      action = "systemctl hibernate";
      text = "Hibernate";
    }

    {
      label = "logout";
      action = "hyprctl dispatch exit 0";
      text = "Logout";
    }

    {
      label = "shutdown";
      action = "systemctl poweroff";
      text = "Shutdown";
    }

    {
      label = "suspend";
      action = "systemctl suspend";
      text = "Suspend";
    }

    {
      label = "reboot";
      action = "systemctl reboot";
      text ="Reboot";
    }
    ];
  };

 
  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
