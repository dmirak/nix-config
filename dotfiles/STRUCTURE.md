# Target repo structure

This repo is being grown into the single source of truth for this NixOS
install: system config, home-manager config, and raw dotfiles that don't
have full home-manager module coverage.

Current state is flat (`configuration.nix`, `home.nix`,
`hardware-configuration.nix`, `flake.nix` all at repo root). The target
layout below hasn't been applied yet — do this reorg once running on NixOS
so changes can be tested immediately with `nixos-rebuild switch`.

```
nix-config/
├── flake.nix
├── flake.lock
├── hosts/
│   └── nixos-pc/
│       ├── configuration.nix        # currently configuration.nix at root
│       └── hardware-configuration.nix
├── home/
│   ├── david.nix                    # currently home.nix at root
│   └── modules/
│       ├── git.nix
│       ├── zsh.nix
│       ├── firefox.nix
│       ├── niri.nix                 # programs.niri / niri-flake settings
│       └── noctalia.nix
└── dotfiles/
    ├── STRUCTURE.md                 # this file
    ├── niri/config.kdl
    ├── kitty/kitty.conf
    └── noctalia/...
```

## Two ways a program's config ends up managed here

1. **Home-manager options** (e.g. `programs.git`, `programs.zsh`,
   `programs.kitty.settings`) — declared entirely in Nix under
   `home/modules/`. Home-manager generates the file and symlinks it into
   place. No raw file needed in `dotfiles/`.

2. **Raw/unmanaged configs** (niri's KDL, noctalia's settings — anything
   without full option coverage) — the actual file lives under
   `dotfiles/`, and a `home/modules/*.nix` file points at it:

   ```nix
   xdg.configFile."niri/config.kdl".source = ../../dotfiles/niri/config.kdl;
   ```

   Home-manager symlinks `~/.config/niri/config.kdl` into the Nix store
   at `home-manager switch` time. For faster iteration while still
   tweaking a config, use
   `config.lib.file.mkOutOfStoreSymlink ../../dotfiles/niri/config.kdl`
   instead of `.source` — this symlinks straight to the repo file so
   edits show up without rebuilding.

## Before switching over to NixOS

Three things need to be in place first:

- [x] Claude Code available to the user (declared in `home.nix`)
- [x] Arch niri config ported into `dotfiles/niri/` (`config.kdl` +
      `noctalia.kdl`, wired via `xdg.configFile` + `mkOutOfStoreSymlink`
      in `home.nix`). The `Mod+Shift+T` bind for `toggle-tv-niri.sh` was
      dropped — script wasn't working and wasn't ported.
- [x] Noctalia shell 4.x with the same config as Arch, ported into
      `dotfiles/noctalia/` (`settings.json`, `colors.json`, `plugins.json`,
      `user-templates.toml`, wired via `xdg.configFile` +
      `mkOutOfStoreSymlink` in `home.nix`).
      - `flake.nix`'s `noctalia` input is pinned to the `legacy-v4` branch
        (the maintained 4.x line) instead of tracking `main` (now v5
        betas). The v5 flake in `main` remains available to switch to
        later by just changing the input `url` back and adjusting
        `home.nix` from `programs.noctalia-shell` (v4's option namespace)
        to `programs.noctalia` (v5's).
      - **`flake.lock` was not regenerated** — this Arch box's Nix daemon
        is inactive and the store needs root, so `nix flake lock` fails
        here with a permission error. Run
        `nix flake update noctalia` (or just `nixos-rebuild switch
        --flake .`, which auto-locks changed inputs) once on the real
        NixOS machine with network access, before/during the first
        switch.
      - Fixed `dotfiles/niri/config.kdl`'s startup line: NixOS's
        `noctalia-shell` package wraps `qs` with `QS_CONFIG_PATH` baked
        in and exposes a `noctalia-shell` binary, so it's launched as
        `spawn-at-startup "noctalia-shell"` rather than Arch's
        `qs -c noctalia-shell` (which relied on XDG config-dir lookup
        that the Nix package doesn't register into).

- [x] Daily wallpaper rotation ported (`dotfiles/scripts/wallpaper-random.sh`
      + `systemd.user.services.wallpaper-rotate` /
      `systemd.user.timers.wallpaper-rotate` in `home.nix`, declared
      directly rather than as raw unit files since they're only a few
      lines each).
      - Same `qs -c noctalia-shell` → `noctalia-shell` fix as the niri
        startup line, applied to the script's IPC call.
      - **`~/Pictures/Wallpapers` (248MB, 63 files) was NOT copied into
        this repo** — copy it to the same path on the NixOS box
        separately (rsync/USB/etc.); the script expects it unchanged.
      - Arch also has a `wallpaper.service` running `linux-wallpaperengine`
        (Steam Workshop animated wallpapers, hardcoded to `DP-1`/`DP-3`
        with specific wallpaper IDs) — this is unrelated to the daily
        rotation and was **not** ported; ask if you want it too.

- [x] Neovim config ported into `dotfiles/nvim/` (lazy.nvim-based, whole
      directory symlinked in one shot via `xdg.configFile."nvim".source
      = mkOutOfStoreSymlink ./dotfiles/nvim` in `home.nix` — simpler than
      per-file entries since it's a nested `lua/` tree).
      - Plugins themselves (`~/.local/share/nvim/lazy/*`, 37MB) were
        **not** copied — lazy.nvim bootstraps itself from `init.lua` and
        reinstalls everything from `lazy-lock.json` on first launch, so
        nothing to port there, just needs network on first run.
      - The live colorscheme reload (`matugen-template.lua` →
        `matugen.lua`, `SIGUSR1` to nvim) is already wired up via
        Noctalia's `user-templates.toml`, ported earlier — no separate
        `matugen` CLI package needed, and no username-specific paths to
        fix.
      - `telescope-fzf-native.nvim` needs `make` to build; not declared
        anywhere in this repo yet (only `gcc` is). Flagged below.

### Known gaps

- [x] Closed: `fuzzel`, `swaylock`, `playerctl`, `brightnessctl`, `orca`,
      `gnumake` added to `home.packages` in `home.nix`. PipeWire +
      WirePlumber enabled at the system level in `configuration.nix`
      (`services.pipewire`, `security.rtkit.enable`), with `wireplumber`
      (provides `wpctl`) added to `environment.systemPackages` — this is
      a system service, so it lives in `configuration.nix` rather than
      `home.nix`, unlike the rest of this list.
      - `orca` gives you the binary the `Super+Alt+S` bind spawns, but
        full screen-reader function typically also wants
        `services.speechd.enable` (speech-dispatcher) at the system
        level — not enabled here since it wasn't part of the original
        ask; add it if the bind doesn't actually speak.

- [x] Yazi ported into `dotfiles/yazi/` (`yazi.toml`, `theme.toml`,
      `flavors/noctalia.yazi/flavor.toml`), whole directory symlinked via
      `xdg.configFile."yazi"` in `home.nix`. `yazi` package added to
      `home.packages` (wasn't declared anywhere before).

- [x] Kitty's Arch config ported into `dotfiles/kitty/` (`kitty.conf`,
      `themes/noctalia.conf`, and the `current-theme.conf` relative
      symlink kitty's own theme-picker created — preserved as a real
      symlink via `cp -a` so it still resolves after being checked out
      elsewhere). Whole directory symlinked via `xdg.configFile."kitty"`.
      `kitty.conf.bak` was a stale backup and wasn't ported. The `kitty`
      *package* was already in `configuration.nix`'s
      `environment.systemPackages` from the start — only the config was
      missing.

- [x] oh-my-zsh ported — not by vendoring the 15MB `~/.oh-my-zsh` clone,
      but via home-manager's built-in `programs.zsh.oh-my-zsh` module
      (`home.nix`), which fetches the framework itself. Only the actual
      customization in `~/.zshrc` was carried over: `ZSH_THEME=agnoster`,
      `plugins=(git z sudo colored-man-pages command-not-found)`,
      `EDITOR=nvim` (now `home.sessionVariables.EDITOR`), and the
      `fastfetch` startup call (now `programs.zsh.initContent`).
      `~/.oh-my-zsh/custom/` had no real customizations to port — just
      the stock example scaffold files that ship with oh-my-zsh itself.
      `fastfetch` package added to `home.packages`.

- [x] Fuzzel ported into `dotfiles/fuzzel/` (`fuzzel.ini` +
      `themes/noctalia`), whole directory symlinked via
      `xdg.configFile."fuzzel"`. `fuzzel.ini`'s `include=~/.config/...`
      line resolves via `~` at runtime, not a nix path, so it needed no
      changes. Package was already in `home.packages` from the niri-bind
      gap fix.

- [x] Btop ported into `dotfiles/btop/` (`btop.conf` +
      `themes/noctalia.theme`), symlinked via `xdg.configFile."btop"`.
      `btop` package added to `home.packages` (wasn't declared before).

- [x] Fastfetch's actual config ported into `dotfiles/fastfetch/`
      (`config.jsonc`), symlinked via `xdg.configFile."fastfetch"`. The
      `fastfetch` package itself was already added when oh-my-zsh was
      ported (it's called from `.zshrc`/`initContent`) — this just adds
      the module list config that was missing.

The `hosts/` / `home/modules/` reorg described above happens after the
switch, once changes can be tested live.

The `hosts/` / `home/modules/` reorg described above happens after the
switch, once changes can be tested live.
