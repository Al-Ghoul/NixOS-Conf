{ ... }:

{
  imports = [
    ./modules/home-manager/neovim.nix
    ./modules/home-manager/packages.nix
    ./modules/home-manager/starship.nix
    ./modules/home-manager/shell.nix
    ./modules/home-manager/hyprland.nix
    ./modules/home-manager/git.nix
    ./modules/home-manager/gtk.nix
    ./modules/home-manager/direnv.nix
  ];

  home.username = "alghoul";
  home.homeDirectory = "/home/alghoul";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
