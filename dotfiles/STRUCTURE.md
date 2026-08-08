# Repo structure

This repo is the single source of truth for this NixOS install: system config,
home-manager config, and raw dotfiles that don't have full home-manager module
coverage.

```
nix-config/
├── flake.nix
├── flake.lock
├── hosts/
│   └── nixos-pc/
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── home/
│   ├── david.nix
│   └── modules/                         # per-program home-manager modules (stub)
└── dotfiles/
    ├── STRUCTURE.md                      # this file
    ├── niri/
    ├── kitty/
    ├── nvim/
    ├── yazi/
    ├── fuzzel/
    ├── btop/
    ├── fastfetch/
    ├── noctalia/
    └── scripts/
```

## Two ways a program's config ends up managed here

1. **Home-manager options** (e.g. `programs.git`, `programs.zsh`) — declared
   in `home/david.nix` (or a future `home/modules/*.nix`). Home-manager
   generates the file and symlinks it into place. No raw file needed in
   `dotfiles/`.

2. **Raw/unmanaged configs** (niri's KDL, nvim's lua tree — anything without
   full option coverage) — the actual file lives under `dotfiles/`, and
   `home/david.nix` points at it with `mkOutOfStoreSymlink`:

   ```nix
   xdg.configFile."niri/config.kdl".source =
     config.lib.file.mkOutOfStoreSymlink "${dotfiles}/niri/config.kdl";
   ```

   This symlinks `~/.config/niri/config.kdl` straight to the repo file so
   edits show up without rebuilding. Use `.source = ../../dotfiles/...`
   (without `mkOutOfStoreSymlink`) only for files you rarely edit, as that
   copies into the store and requires a rebuild on every change.

## Notes

- **`~/Pictures/Wallpapers`** (wallpaper pool for `wallpaper-random.sh`) is
  not in this repo — copy it to the same path on a new machine via rsync/USB.
- **SSH keys** (`~/.ssh/id_ed25519`) are not in this repo — copy manually to
  a new machine.
- **Steam per-game launch parameters** live in Steam's own `userdata/`
  directory and are not declaratively managed; set them via the Steam UI.
- `flake.lock` should be regenerated on the target machine with
  `nix flake update` or `nixos-rebuild switch --flake .` on first run if
  inputs have changed.
