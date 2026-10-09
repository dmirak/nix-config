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
    ./modules/libreoffice.nix
    ./modules/kitty.nix
    ./modules/fuzzel.nix
    ./modules/gtk.nix
    ./modules/btop.nix
    ./modules/fastfetch.nix
    ./modules/wallpaper.nix
    ./modules/civ5.nix
    ./modules/creamlinux.nix
    ./modules/terrascope.nix
    ./modules/minecraft-autoclick.nix
    ./modules/packages.nix
  ];

  home = {
    username = "david";
    homeDirectory = "/home/david";
    stateVersion = "26.05";

    pointerCursor = {
      enable = true;
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
      gtk.enable = true;
    };
  };
}
