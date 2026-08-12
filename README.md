# nix-config

My personal NixOS flake config for `nixos-pc` — a single-host, nvidia,
[niri](https://github.com/YaLTeR/niri)/Wayland desktop, themed with
[noctalia-shell](https://github.com/noctalia-dev/noctalia-shell).

This is posted for reference, not as a template — `hardware-configuration.nix`
is specific to my machine, and some choices (pinned forks, personal keybinds)
won't make sense outside my setup. Feel free to steal whatever's useful.

<!-- screenshot goes here -->

## Layout

```
nix-config/
├── flake.nix / flake.lock
├── hosts/nixos-pc/
│   ├── configuration.nix          # system-level (boot, services, users, drivers)
│   └── hardware-configuration.nix
├── home/
│   ├── david.nix                  # imports every module below
│   └── modules/                   # one file per program (git.nix, niri.nix, ...)
└── dotfiles/                      # raw config files for unmanaged programs
    ├── niri/ noctalia/ nvim/ yazi/ kitty/ fuzzel/ btop/ fastfetch/
    └── scripts/
```

Most programs are configured one of two ways:

- **Home-manager options** (e.g. `programs.git`) declared directly in a
  `home/modules/<name>.nix`.
- **Raw configs** without full home-manager option coverage (niri's KDL,
  nvim's Lua tree, ...) live under `dotfiles/`, and the matching
  `home/modules/<name>.nix` symlinks it into place with
  `mkOutOfStoreSymlink` so edits show up without a rebuild.

## Notable pins

- `niri` tracks `pkgs.niri-unstable` via
  [epireyn's niri-flake fork](https://github.com/epireyn/niri-flake),
  because the stable release predates the `include` directive and
  `maximize-window-to-edges`, both used in `dotfiles/niri/*.kdl`.
- `noctalia-shell` is pinned to the `legacy-v4` branch; v5 (default branch)
  isn't configured here yet.

## Building

```sh
# dry-run — builds the system without switching, no sudo needed
nixos-rebuild build --flake .

# apply
sudo nixos-rebuild switch --flake .#nixos-pc
```

There's no CI — "does it build" is the bar.

## Secrets

Config files that need a secret (e.g. `dotfiles/noctalia/settings.json`'s
`wallhavenApiKey`) keep the field blank in the repo. The real value lives
in an untracked, permission-locked file outside the repo and gets injected
at spawn time via an environment variable that the app prioritizes over
the (blank) JSON field. See `CLAUDE.md` for the exact pattern.

## License

[MIT](LICENSE)
