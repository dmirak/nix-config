{ config, inputs, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia.enable = true;

  xdg.configFile."noctalia/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/noctalia/config.toml";
}
