{ pkgs, ... }: {
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
        gaps_out = 5
        border_size = 2
        col.active_border = rgba(13ACACee) rgba(16A0F3ee) 90deg
        col.inactive_border = rgba(595959aa)

        layout = dwindle
        allow_tearing = false
      }

      misc {
        disable_hyprland_logo = yes
      }

      decoration {
        rounding = 5

          blur {
            enabled = true
              size = 5
              passes = 3
              ignore_opacity = true
              new_optimizations = true
              popups = true
          }


        blurls = lockscreen


          drop_shadow = false
          shadow_range = 10
          shadow_render_power = 4
          col.shadow = rgba(1a1a1aee)
          col.shadow_inactive=0x50000000
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
        no_gaps_when_only = -2
        special_scale_factor = 1 # Enables mainMod + P to put the screen on special work space on full
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


      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

      # Kitty animation/opacity
      windowrulev2 = animation popin,class:^(kitty)$,title:^(update-sys)$1

      # Brave
      windowrulev2 = opacity 0.8 0.8,class:^(brave)$
      windowrulev2 = animation popin,class:^(brave)$

      # Obsidian
      windowrulev2 = opacity 0.7 0.7,class:^(obsidian)$
      windowrulev2 = animation popin,class:^(obsidian)$

      # Vesktop/Discord
      windowrulev2 = opacity 0.8 0.5,class:^(vesktop)$
      windowrulev2 = animation popin,class:^(vesktop)$

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
      bind = $mainMod, [, exit, 
      bind = $mainMod, L, exec, swaylock # Lock the screen
      bind = $mainMod, E, exec, thunar # Show the graphical file browser
      bind = $mainMod, V, togglefloating, 
      bind = $mainMod, SPACE, exec, wofi # Show the graphical app launcher
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle
      bind = ALT, V, exec, cliphist list | wofi -dmenu | cliphist decode | wl-copy # open clipboard manager
      bind = $mainMod, M, exec, wlogout --protocol layer-shell # show the logout window
      bind = $mainMod, x, exec, grim -g "$(slurp)" - | swappy -f - # take a screenshot
      # Example special workspace (scratchpad)
      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic


      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # workspaces
      # binds $mainMod + [shift +] {1..10} to [move to] workspace {1..10}
      ${builtins.concatStringsSep "\n" (builtins.genList (x:
        let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
        in ''
          bind = $mainMod, ${ws}, workspace, ${toString (x + 1)}
          bind = $mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
        '') 10)}

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
        height = 20;
        spacing = 10;
        margin-left = 5;
        margin-right = 5;
        output = [ "eDP-1" "HDMI-A-1" ];
        modules-center = [ "hyprland/window" ];
        modules-left = [ "hyprland/workspaces" ];
        "modules-right" = [
          "tray"
          "idle_inhibitor"

          "network"
          "disk"
          "memory"
          "cpu"
          "temperature"

          "pulseaudio"
          "pulseaudio#microphone"

          "hyprland/language"
          "clock"
        ];

        tray = {
          icon-size = 16;
          spacing = 10;
        };

        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "󰛊 ";
            "deactivated" = "󰾫 ";
          };
        };

        "hyprland/workspaces" = {
          "show-special" = true;
          "persistent-workspaces" = { "*" = [ 1 2 3 4 5 6 7 ]; };
          "format" = "{icon}";
          "format-icons" = {
            "active" = "";
            "empty" = "";
            "default" = "";
            "urgent" = "";
            "special" = "";
          };
        };

        "hyprland/window" = { "rewrite" = { "" = "❄️ NixOS ❄️"; }; };

        network = {
          interface = "enp8s0";
          interval = 2;
          "format-icons" = [ "󰤯 " "󰤟 " "󰤢 " "󰤥 " "󰤨 " ];
          format = "Error";
          "tooltip-format" = "Error";
          "format-wifi" = "{icon}";
          "tooltip-format-wifi" = ''
            {ipaddr}/{cidr}
            {essid} ({signalStrength}%) {icon}

            {ifname}
            {frequency}GHz {signaldBm}dBm  

             {bandwidthUpBits} |  {bandwidthDownBits} |  {bandwidthTotalBits}'';
          "format-ethernet" = " ";
          "tooltip-format-ethernet" = ''
            {ipaddr}/{cidr}
            {essid}

            {ifname}

            {bandwidthUpBits} {bandwidthDownBits} {bandwidthTotalBits}'';
          "format-disconnected" = " ";
          "tooltip-format-disconnected" = "  Disconnected";
        };

        disk = {
          interval = 15;
          format = "󰋊 {percentage_used}%";
          "tooltip-format" = ''
            Used  : {used}
            Total : {total} ({percentage_used}%)
            Disk  : {path}'';
        };

        memory = {
          interval = 10;
          format = " {used}";
          "tooltip-format" = ''
            Used  : {used}GiB
            Total : {total}GiB ({percentage}%)'';
        };

        cpu = {
          interval = 10;
          format = " {usage}%";
        };

        temperature = { interval = 10; };

        clock = {
          interval = 1;
          format = "{:%H:%M:%S}";
          "tooltip-format" = "<small>{calendar}</small>";
          calendar = {
            mode = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>w{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            "on-click-right" = "mode";
            "on-click-middle" = "shift_reset";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
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
            default = [ "" "" "" ];
          };
          tooltip = true;
          tooltip-format = "{icon} at {volume}%";
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = "";
          format-source-muted = "";
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
          tooltip-format = " at {volume}%";
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
      }
      
      window#waybar {
        background: rgba(0, 0, 0, 0);
        font-size: 0.8rem;
        border-radius: 0.5rem;
      }

      tooltip {
        font-size: 0.8rem;
      }

      .modules-left,
      .modules-center {
        background: linear-gradient(45deg, rgba(8, 84, 203, 1), rgba(8, 147, 203, 1));
        border-radius: 0.5rem;
        padding: 2px;
      }

      .modules-right {
        background-color: rgba(18,18,18,0.7);
        border-radius: 0.5rem;
        border-width: 1px;
        border-style: solid;
        border-color: #1A5ECA;
        padding: 2px 2px 2px 10px;
      }

      #pulseaudio {
        padding-right: 5px;
      }

      #workspaces {
        background-color: rgba(0,0,0,0.7);
        border-radius: 0.5rem;
        padding: 4px;
      }

       #workspaces button {
         font-size: 0.7rem;
         padding: 0 0.3rem 0 0;
       }

       #workspaces button.special {
         font-size: 0.7rem;
         padding: 0 0.3rem 0 0;
       }

       #workspaces button.active {
         color: #1A5ECA;
       }

       #workspaces button.urgent {
         color: red;
       }     

       #window {
         background-color: rgba(0,0,0,0.7);
         border-radius: 0.5rem;
         padding: 2px 5px;
       }

       #clock {
         font-weight: bolder;
         border-radius: 0.5rem;
         padding: 0 3px 0 0;
       }

       #memory {
         color: lightpink;
       }

       #disk {
         color: lightskyblue;
       }

       #cpu {
         color: lightgoldenrodyellow;
       }

       #temperature {
         color: lightslategray;
       }
    '';
  };

  services.mako = {
    enable = true;
    font = "Fantasque Sans Mono 14";
    anchor = "top-right";
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
      effect-blur = "9x5";
      effect-vignette = "0.5:0.5";
      color = "1f1d2e80";
      font = "Inter";
      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 20;
      line-color = "1f1d2e";
      ring-color = "191724";
      inside-color = "1f1d2e";
      key-hl-color = "eb6f92";
      separator-color = "00000000";
      text-color = "e0def4";
      text-caps-lock-color = "";
      line-ver-color = "eb6f92";
      ring-ver-color = "eb6f92";
      inside-ver-color = "1f1d2e";
      text-ver-color = "e0def4";
      ring-wrong-color = "31748f";
      text-wrong-color = "31748f";
      inside-wrong-color = "1f1d2e";
      inside-clear-color = "1f1d2e";
      text-clear-color = "e0def4";
      ring-clear-color = "9ccfd8";
      line-clear-color = "1f1d2e";
      line-wrong-color = "1f1d2e";
      bs-hl-color = "31748f";
      grace = 2;
      grace-no-mouse = true;
      grace-no-touch = true;
      datestr = "%a, %B %e";
      timestr = "%I:%M %p";
      fade-in = 0.2;
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
        text = "Reboot";
      }
    ];
  };

  # Application Launcher
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 300;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
      dynamic_lines = true;
    };
    style = ''
         window {
           margin: 0px;
           border: 5px solid #1e1e2e;
           background-color: #cdd6f4;
           border-radius: 15px;
         }

         #input {
           padding: 4px;
           margin: 4px;
           padding-left: 20px;
           border: none;
           color: #cdd6f4;
           font-weight: bold;
           background-color: #1e1e2e;
      	    outline: none;
           border-radius: 15px;
           margin: 10px;
           margin-bottom: 2px;
       }

       #input:focus {
         border: 0px solid #1e1e2e;
         margin-bottom: 0px;
       }

       #inner-box {
         margin: 4px;
         border: 10px solid #1e1e2e;
         color: #cdd6f4;
         font-weight: bold;
         background-color: #1e1e2e;
         border-radius: 15px;
       }

       #outer-box {
         margin: 0px;
         border: none;
         border-radius: 15px;
         background-color: #1e1e2e;
       }

       #scroll {
         margin-top: 5px;
         border: none;
         border-radius: 15px;
         margin-bottom: 5px;
       }

       #img:selected {
         background-color: #89b4fa;
         border-radius: 15px;
       }

       #text:selected {
         color: #cdd6f4;
         margin: 0px 0px;
         border: none;
         border-radius: 15px;
         background-color: #89b4fa;
       }

       #entry {
         margin: 0px 0px;
         border: none;
         border-radius: 15px;
         background-color: transparent;
       }

       #entry:selected {
         margin: 0px 0px;
         border: none;
         border-radius: 15px;
         background-color: #89b4fa;
       }
    '';
  };
}
