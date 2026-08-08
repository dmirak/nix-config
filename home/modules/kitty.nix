{ config, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  xdg.configFile."kitty".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/kitty";
}
