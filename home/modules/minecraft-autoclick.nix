{ config, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  home.file.".local/bin/minecraft-autoclick.sh".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/scripts/minecraft-autoclick.sh";
}
