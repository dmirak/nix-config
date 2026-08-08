{ config, pkgs, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  home.packages = [ pkgs.yazi ];
  xdg.configFile."yazi".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/yazi";
}
