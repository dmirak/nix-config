{ pkgs, ... }:
{
  imports = [
    ./modules/git.nix
    ./modules/zsh.nix
    ./modules/firefox.nix
    ./modules/niri.nix
    ./modules/noctalia.nix
    ./modules/nvim.nix
    ./modules/yazi.nix
    ./modules/kitty.nix
    ./modules/fuzzel.nix
    ./modules/btop.nix
    ./modules/fastfetch.nix
    ./modules/wallpaper.nix
    ./modules/packages.nix
  ];

  home.username = "david";
  home.homeDirectory = "/home/david";
  home.stateVersion = "26.05";

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };
}
