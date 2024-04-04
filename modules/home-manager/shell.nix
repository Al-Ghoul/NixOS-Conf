{ pkgs, ... }: {
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        starship init fish | source
      '';
      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        {
          inherit (pkgs.fishPlugins.grc) src;
          name = "grc";
        }
      ];
    };

    kitty = {
      enable = true;
      font = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "jetbrains mono nerd font";
      };
      settings = {
        background = "#000000";
        background_opacity = "0.8";
        inactive_border_color = "#062C6F";
        active_border_color = "#16caf3";
        enabled_layouts = "vertical,horizontal";
      };
      theme = "Rosé Pine";
      keybindings = {
        "ctrl+right" = "resize_window narrower";
        "ctrl+left" = "resize_window wider";
        "ctrl+up" = "resize_window taller";
        "ctrl+down" = "resize_window shorter";
        "ctrl+home" = "resize_window reset";
        "ctrl+shift+t" = "new_tab_with_cwd";
        "ctrl+shift+n" = "no_op";
      };
      shellIntegration = { enableFishIntegration = true; };
    };

    fzf = { enable = true; };

    zoxide = { enable = true; };

    tmux = {
      enable = true;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = rose-pine;
          extraConfig = ''
            set -g @rose_pine_variant 'main' # Options are 'main', 'moon' or 'dawn'
            set -g @rose_pine_bar_bg_disable 'on' 
            set -g @rose_pine_bar_bg_disabled_color_option 'default'
          '';
        }

        {
          plugin = session-wizard;
          extraConfig = ''
            set -g @session-wizard 'T'
          '';
        }

        {
          plugin = mkTmuxPlugin rec {
            pluginName = "tmux-pomodoro-plus";
            version = "1.0.2";
            src = pkgs.fetchFromGitHub {
              owner = "olimorris";
              repo = "tmux-pomodoro-plus";
              rev = "0280f1409cd0232d6a84dff8ebad7feef3e1dddc";
              sha256 = "sha256-VmjqD4Ec0AiG6pylAxxxPO7+ghLSlHf098wwIUi/y+M=";
            };
            rtpFilePath = "pomodoro.tmux";
          };
          extraConfig = ''
            set -g status-right "#{pomodoro_status}"
            set -g @pomodoro_toggle 'p'                    # Start/pause a Pomodoro/break
            set -g @pomodoro_cancel 'P'                    # Cancel the current session
            set -g @pomodoro_skip '_'                      # Skip a Pomodoro/break

            set -g @pomodoro_mins 25                       # The duration of the Pomodoro
            set -g @pomodoro_break_mins 5                  # The duration of the break after the Pomodoro completes
            set -g @pomodoro_intervals 4                   # The number of intervals before a longer break is started
            set -g @pomodoro_long_break_mins 25            # The duration of the long break
            set -g @pomodoro_repeat 'off'                  # Automatically repeat the Pomodoros?
            set -g @pomodoro_disable_breaks 'off'          # Turn off breaks

            set -g @pomodoro_on " 🍅"                      # The formatted output when the Pomodoro is running
            set -g @pomodoro_complete " ✔︎"                 # The formatted output when the break is running
            set -g @pomodoro_pause " ⏸︎"                    # The formatted output when the Pomodoro/break is paused
            set -g @pomodoro_prompt_break " ⏲︎ break?"      # The formatted output when waiting to start a break
            set -g @pomodoro_prompt_pomodoro " ⏱︎ start?"   # The formatted output when waiting to start a Pomodoro

            set -g @pomodoro_menu_position "R"             # The location of the menu relative to the screen
            set -g @pomodoro_sound 'on'                   # Sound for desktop notifications (Run `ls /System/Library/Sounds` for a list of sounds to use on Mac)
            set -g @pomodoro_notifications 'on'           # Enable desktop notifications from your terminal
            set -g @pomodoro_granularity 'on'
            set -g status-interval 1                       # Refresh the status line every second
            set -g @pomodoro_interval_display "[%s/%s]"
          '';
        }

        { plugin = vim-tmux-navigator; }
      ];

      extraConfig = ''
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
      '';
    };

  };
}
