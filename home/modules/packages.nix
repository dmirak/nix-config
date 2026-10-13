{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    nodejs
    gcc
    claude-code
    gnumake # telescope-fzf-native.nvim build step
    swaylock
    playerctl
    brightnessctl
    orca
    prismlauncher
    protontricks
    p7zip
    discord
    gh
    statix
    deadnix
    shellcheck
    jq
    fd
    taplo
    difftastic
    nvd
    nix-diff
    nix-tree
    nh
    satty
    obsidian
    a2ps
    ghostscript
    gimp
    depotdownloader
  ];
}
