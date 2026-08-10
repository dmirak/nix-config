{ config, pkgs, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  home.packages = [ pkgs.yazi ];
  xdg.configFile."yazi".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/yazi";

  xdg.desktopEntries.yazi = {
    name = "Yazi";
    genericName = "File Manager";
    exec = "kitty -- yazi %f";
    terminal = false;
    mimeType = [ "inode/directory" ];
    categories = [ "System" "FileManager" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "yazi.desktop";
    };
  };
}
