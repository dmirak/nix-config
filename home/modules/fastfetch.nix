{ config, pkgs, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  home.packages = [ pkgs.fastfetch ];
  xdg.configFile."fastfetch".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/fastfetch";
}
