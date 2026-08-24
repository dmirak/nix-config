{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles";
in
{
  home.packages = with pkgs; [
    neovim
    nixd
    nixfmt
  ];
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
}
