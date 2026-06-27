{ config, pkgs, ... }:

{
  home.username = "david";
  home.homeDirectory = "/home/david";
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    userName = "dmirak";
    userEmail = "dmirakian1023@gmail.com";
  };

  programs.zsh.enable = true;

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
  ];
}
