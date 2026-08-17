{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    claude-code
    gnumake # telescope-fzf-native.nvim build step
    swaylock
    playerctl
    brightnessctl
    orca
    prismlauncher
    protontricks # run mod installers inside a game's Proton prefix
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
  ];
}
