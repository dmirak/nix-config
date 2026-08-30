{ pkgs, ... }:
{
  imports = [
    ./modules/git.nix
    ./modules/zsh.nix
    ./modules/firefox.nix
    ./modules/librewolf.nix
    ./modules/niri.nix
    ./modules/noctalia.nix
    ./modules/nvim.nix
    ./modules/yazi.nix
    ./modules/imv.nix
    ./modules/vlc.nix
    ./modules/kitty.nix
    ./modules/fuzzel.nix
    ./modules/gtk.nix
    ./modules/btop.nix
    ./modules/fastfetch.nix
    ./modules/wallpaper.nix
    ./modules/civ5.nix
    ./modules/creamlinux.nix
    ./modules/packages.nix
  ];

  home.username = "david";
  home.homeDirectory = "/home/david";
  home.stateVersion = "26.05";

  home.pointerCursor.enable = true;
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };
}
