{ config, pkgs, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  home.packages = [ pkgs.btop ];
  xdg.configFile."btop".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/btop";
}
