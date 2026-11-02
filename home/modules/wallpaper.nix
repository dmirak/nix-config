_:
{
  systemd.user.services.wallpaper-rotate = {
    Unit.Description = "Rotate wallpaper via Noctalia";
    Service = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c 'noctalia msg wallpaper-random'";
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
