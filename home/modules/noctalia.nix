{ config, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  programs.noctalia.enable = true;

  xdg.configFile."noctalia/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/noctalia/config.toml";
}
