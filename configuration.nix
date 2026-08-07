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

  services.greetd = {
    enable = true;
    #settings.default_session = {
      #command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
      #user = "greeter";
    #};
  };

  users.users.david = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.zsh.enable = true;
  programs.niri.enable = true;

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

