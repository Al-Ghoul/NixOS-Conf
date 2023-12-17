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
    pkgs.wofi

    # Text colorizes for fish
    pkgs.grc
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
                                                                                                                                                                                                                                                                                                                                                                     bind = $mainMod, M, exit, 
                                                                                                                                                                                                                                                                                                                                                                   bind = $mainMod, E, exec, thunar # Show the graphical file browser
                                                                                                                                                                                                                                                                                                                                                                     bind = $mainMod, V, togglefloating, 
                                                                                                                                                                                                                                                                                                                                                                   bind = $mainMod, R, exec, wofi --show drun
                                                                                                                                                                                                                                                                                                                                                                     bind = $mainMod, SPACE, exec, wofi # Show the graphical app launcher
                                                                                                                                                                                                                                                                                                                                                                     bind = $mainMod, P, pseudo, # dwindle
                                                                                                                                                                                                                                                                                                                                                                     bind = $mainMod, J, togglesplit, # dwindle

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
