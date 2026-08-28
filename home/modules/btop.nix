{ config, pkgs, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  home.packages = [ pkgs.btop-cuda ];
  xdg.configFile."btop".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/btop";
}
