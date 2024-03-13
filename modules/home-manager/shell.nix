{ pkgs, ... }: {
  programs.fish = {
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

  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      name = "jetbrains mono nerd font";
    };
    settings = {
      background_opacity = 0;
      inactive_border_color = "#062C6F";
      active_border_color = "#16caf3";
      enabled_layouts = "vertical,horizontal";
    };
    theme = "GitHub Dark";
    keybindings = {
      "ctrl+right" = "resize_window narrower";
      "ctrl+left" = "resize_window wider";
      "ctrl+up" = "resize_window taller";
      "ctrl+down" = "resize_window shorter";
      "ctrl+home" = "resize_window reset";
      "ctrl+shift+t" = "new_tab_with_cwd";
    };
    shellIntegration = { enableFishIntegration = true; };
  };
}
