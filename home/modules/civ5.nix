{ config, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  home.file.".local/bin/civ5-to-dp1.sh".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/scripts/civ5-to-dp1.sh";
}
