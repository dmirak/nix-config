# nix-config

My personal NixOS flake config. [Niri](https://github.com/YaLTeR/niri)/Wayland desktop, themed with
[noctalia-shell](https://github.com/noctalia-dev/noctalia-shell).

This is posted for reference, not as a template — `hardware-configuration.nix`
is specific to my machine, and some choices (pinned forks, personal keybinds)
won't make sense outside my setup.

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

## Inputs

niri and noctalia both come from nixpkgs, not flake inputs. The only
non-nixpkgs input is `creamlinux`, which is unpackaged and used via its own
`package.nix`.

## Building

```sh
# dry-run — builds the system without switching, no sudo needed
nixos-rebuild build --flake .

# apply (zsh alias for sudo nixos-rebuild switch --flake ~/nix-config#nixos-pc)
nixos-rebuild-switch

# update flake inputs and apply (zsh alias, uses nh)
nixos-upgrade
```

## Secrets

Config files that need a secret (e.g. `dotfiles/noctalia/settings.json`'s
`wallhavenApiKey`) keep the field blank in the repo. The real value lives
in an untracked, permission-locked file outside the repo and gets injected
at spawn time via an environment variable that the app prioritizes over
the (blank) JSON field. See `CLAUDE.md` for the exact pattern.

## License

[MIT](LICENSE)
