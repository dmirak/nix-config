{ config, inputs, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  imports = [ inputs.noctalia.homeModules.default ];

  # legacy-v4 module namespace is `noctalia-shell`, not `noctalia` (that's v5's).
  programs.noctalia-shell.enable = true;

  xdg.configFile."noctalia/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/noctalia/settings.json";
  xdg.configFile."noctalia/colors.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/noctalia/colors.json";
  xdg.configFile."noctalia/plugins.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/noctalia/plugins.json";
  xdg.configFile."noctalia/user-templates.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/noctalia/user-templates.toml";
}
