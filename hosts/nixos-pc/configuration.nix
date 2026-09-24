{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.edk2-uefi-shell.enable = false;
  boot.loader.systemd-boot.extraEntries."arch.conf" = ''
    title Arch Linux
    efi /efi/edk2-uefi-shell/shell.efi
    options -nointerrupt -nomap -noversion HD2b:EFI\GRUB\grubx64.efi
    sort-key z_arch
  '';

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-pc";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  services.displayManager.ly.enable = true;

  boot.kernel.sysctl."vm.swappiness" = 0;

  users.users.david = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "ydotool"
      "lpadmin"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  fileSystems."/".options = [
    "compress=zstd"
    "noatime"
    "discard=async"
    "space_cache=v2"
  ];

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/ecb93dad-adab-45a9-93db-98cfd2ed8b02";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "discard=async"
      "space_cache=v2"
      "nofail"
    ];
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/99eef260-1730-4e2d-ae30-7f19210dd08f";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "space_cache=v2"
      "nofail"
    ];
  };

  fileSystems."/mnt/arch-root" = {
    device = "/dev/disk/by-uuid/3d3a5f2a-052f-4256-8e74-61cc2aa59781";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd"
      "noatime"
      "nofail"
    ];
  };

  fileSystems."/mnt/arch-home" = {
    device = "/dev/disk/by-uuid/3d3a5f2a-052f-4256-8e74-61cc2aa59781";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd"
      "noatime"
      "nofail"
    ];
  };

  fileSystems."/mnt/arch-boot" = {
    device = "/dev/disk/by-uuid/76A3-4CC1";
    fsType = "vfat";
    options = [
      "uid=1000"
      "gid=100"
      "umask=0077"
      "nofail"
    ];
  };

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  programs.xwayland.enable = true;
  programs.zsh.enable = true;
  programs.niri.enable = true;
  # ydotoold backend for minecraft-autoclick.sh: synthesizes input via
  # /dev/uinput, so it works regardless of window focus restrictions on
  # synthetic Wayland input.
  programs.ydotool.enable = true;
  # Stable niri (niri-flake's default) predates the "include" directive
  # (added Oct 2025) and "maximize-window-to-edges", both used in
  # dotfiles/niri/{config,noctalia}.kdl. Track niri's main branch instead.
  programs.niri.package = pkgs.niri-unstable;

  # The GNOME portal niri-flake installs delegates FileChooser to
  # org.gnome.portal.filechooser, which only a full GNOME session provides, so
  # every save/open dialog silently fails. Hand that one interface to the GTK
  # portal and leave the rest (screencast, etc.) with GNOME.
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.niri = {
    default = [ "gnome" ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    kitty
    wireplumber # provides wpctl, used by niri's volume/mic binds
    xwayland-satellite
  ];

  fonts.packages = with pkgs; [
    #nerd-fonts.jetbrains-mono
    maple-mono.NF-unhinted
    noto-fonts
  ];

  # without an explicit sans-serif, GTK's default Cantarell falls back to
  # Noto Sans CJK, which renders latin text at CJK widths
  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Noto Sans"
      "Noto Sans CJK SC"
    ];
    serif = [
      "Noto Serif"
      "Noto Serif CJK SC"
    ];
    monospace = [ "Maple Mono NF" ];
    emoji = [ "Noto Color Emoji" ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  # fullscreen games assume origin (0,0); Xwayland puts DP-1 at y=1440
  programs.gamescope.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;
  };

  system.stateVersion = "26.05";
}
