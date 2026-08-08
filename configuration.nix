{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-pc";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago"; 

  services.displayManager.ly.enable = true;

  users.users.david = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  programs.zsh.enable = true;
  programs.niri.enable = true;
  # Stable niri (niri-flake's default) predates the "include" directive
  # (added Oct 2025) and "maximize-window-to-edges", both used in
  # dotfiles/niri/{config,noctalia}.kdl. Track niri's main branch instead.
  programs.niri.package = pkgs.niri-unstable;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    kitty
    wireplumber # provides wpctl, used by niri's volume/mic binds
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05"; 
}

