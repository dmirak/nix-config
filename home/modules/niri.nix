{ config, ... }:
let
  # Absolute path so mkOutOfStoreSymlink points at the live checkout rather
  # than the ephemeral store copy Nix makes to evaluate the flake.
  dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles";
in
{
  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/niri/config.kdl";
  xdg.configFile."niri/noctalia.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/niri/noctalia.kdl";
}
