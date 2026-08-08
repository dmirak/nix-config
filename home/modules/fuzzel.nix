{ config, pkgs, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  home.packages = [ pkgs.fuzzel ];
  xdg.configFile."fuzzel".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/fuzzel";
}
