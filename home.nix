{ config, pkgs, inputs, ... }:

let
  # Absolute (not ./relative) so mkOutOfStoreSymlink points at the live
  # checkout instead of the ephemeral store copy Nix makes to evaluate the
  # flake -- a relative path here resolves against that store copy, which
  # has no GC root and can vanish out from under the symlink.
  dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles";
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  home.username = "david";
  home.homeDirectory = "/home/david";
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    userName = "dmirak";
    userEmail = "dmirakian1023@gmail.com";
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "z" "sudo" "colored-man-pages" "command-not-found" ];
    };
    initContent = "fastfetch";
    shellAliases = {
	note = "nvim ~/.notes.md";
    };
};

  home.sessionVariables.EDITOR = "nvim";

  # legacy-v4 module namespace is `noctalia-shell`, not `noctalia` (that's v5's).
  programs.noctalia-shell = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
  };

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    claude-code
    gnumake # telescope-fzf-native.nvim build step
    fuzzel
    swaylock
    playerctl
    brightnessctl
    orca
    yazi
    fastfetch
    btop
  ];

  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/niri/config.kdl";
  xdg.configFile."niri/noctalia.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/niri/noctalia.kdl";

  xdg.configFile."noctalia/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/noctalia/settings.json";
  xdg.configFile."noctalia/colors.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/noctalia/colors.json";
  xdg.configFile."noctalia/plugins.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/noctalia/plugins.json";
  xdg.configFile."noctalia/user-templates.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/noctalia/user-templates.toml";

  home.file.".local/bin/wallpaper-random.sh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/scripts/wallpaper-random.sh";
  };

  systemd.user.services.wallpaper-rotate = {
    Unit.Description = "Rotate wallpaper via Noctalia";
    Service = {
      Type = "oneshot";
      ExecStart = "%h/.local/bin/wallpaper-random.sh";
    };
  };

  systemd.user.timers.wallpaper-rotate = {
    Unit.Description = "Rotate wallpaper once per day";
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";

  xdg.configFile."yazi".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/yazi";
  xdg.configFile."kitty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/kitty";

  xdg.configFile."fuzzel".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/fuzzel";
  xdg.configFile."btop".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/btop";
  xdg.configFile."fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/fastfetch";
}

