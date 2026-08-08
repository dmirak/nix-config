{ config, ... }:
let dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles"; in
{
  home.file.".local/bin/wallpaper-random.sh".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/scripts/wallpaper-random.sh";

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
}
