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
    discord
  ];
}
