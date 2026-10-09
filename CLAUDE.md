# nix-config

Single-host NixOS flake config for `nixos-pc` (nvidia, niri/wayland). This
repo is the source of truth for system config, home-manager config, and raw
dotfiles that don't have full home-manager module coverage.

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

## Two ways a program's config ends up managed here

1. **Home-manager options** (e.g. `programs.git`, `programs.zsh`) — declared
   in a `home/modules/<name>.nix`, imported from `home/david.nix`.
   Home-manager generates the file and symlinks it into place. No raw file
   needed in `dotfiles/`.

2. **Raw/unmanaged configs** (niri's KDL, nvim's lua tree — anything without
   full option coverage) — the actual file lives under `dotfiles/`, and the
   matching `home/modules/<name>.nix` points at it with
   `mkOutOfStoreSymlink`:

   ```nix
   xdg.configFile."niri/config.kdl".source =
     config.lib.file.mkOutOfStoreSymlink "${dotfiles}/niri/config.kdl";
   ```

   This symlinks `~/.config/niri/config.kdl` straight to the repo file so
   edits show up without rebuilding. Use `.source = ../../dotfiles/...`
   (without `mkOutOfStoreSymlink`) only for files rarely edited, since that
   copies into the store and requires a rebuild on every change.

Adding a new program: create `home/modules/<name>.nix`, add it to the
`imports` list in `home/david.nix`, and pick one of the two patterns above.

## Building / testing changes

- `nixos-rebuild-switch` — shell alias (`zsh.nix`) for
  `sudo nixos-rebuild switch --flake ~/nix-config#nixos-pc`
- `nixos-upgrade` — shell alias that also runs `nix flake update` first
- Dry-run a change before switching: `nixos-rebuild build --flake .` from
  the repo root
- There is no CI or test suite — "does it build" is the bar
- After making any change to this repo, run `nixos-rebuild build --flake .`
  from the repo root to verify it builds. This does not require sudo and
  does not create a new generation. Do not run `nixos-rebuild switch`
  unless explicitly asked.
- Do not commit as part of the workflow. Leave verified changes in the
  working tree and let the user review them. Commit only when explicitly
  asked.

## Maintenance tooling

These are installed via `home/modules/packages.nix` specifically to help
with editing this repo. Use them proactively, not just when asked:

- `gh` — any GitHub interaction (issues, PRs, checks).
- `statix check .` — Nix anti-pattern linter; run after editing any
  `.nix` file, alongside the `nixos-rebuild build` check.
- `deadnix .` — finds unused bindings/imports in `.nix` files; run after
  editing or removing code from a module.
- `shellcheck` — lint any shell scripts under `dotfiles/scripts/` before
  handing them back.
- `jq` — inspect/edit JSON dotfiles precisely (e.g.
  `dotfiles/noctalia/settings.json`, `colors.json`) instead of freehand
  text edits.
- `taplo` — lint/format TOML dotfiles (e.g.
  `dotfiles/yazi/flavors/noctalia.yazi/flavor.toml`).
- `fd` — prefer over `find` for locating files in this repo.
- `difftastic` (`difft`) — structural diff for reviewing changes,
  especially in Nix/TOML/JSON where a plain line diff is noisy.
- `nvd diff /run/current-system ./result` — after `nixos-rebuild build`,
  lists which packages were added/removed/changed by the change.
- `nix-diff` — explains why two derivations differ.
- `nix-tree` — interactive closure browser (why a package is included, size).
- `nh` — front-end for rebuild/clean (`nh os build .`, `nh clean all`).

## Pins (don't casually bump)

- `niri` tracks `pkgs.niri-unstable` (via epireyn's niri-flake fork) because
  the stable release predates the `include` directive and
  `maximize-window-to-edges`, both used in `dotfiles/niri/*.kdl`.
- `noctalia` is pinned to the `legacy-v4` branch; v5 (default branch) isn't
  configured yet.

## Conventions

- Commit messages are short and lowercase, no conventional-commits prefixes
  (e.g. `librewolf`, `discord`, `prism launcher`). Do NOT add a
  "Co-Authored-By: Claude" (or similar) trailer — commit as if written
  entirely by the user. Stage only the specific files touched, not `-A`/`.`.
- Keep comments to a bare minimum. Prefer none: package lists, option
  settings, and window rules should stand on their own. Add one only where
  the reason for a line is genuinely non-obvious and can't be inferred from
  the code, and keep it to a single line.
- Indentation: tabs everywhere, except `.nix` files, which use 2 spaces.
  Nix itself is whitespace-insensitive, but every formatter in the
  ecosystem (`nixfmt`, `nixpkgs-fmt`, `alejandra`) hardcodes 2 spaces with
  no tabs option, and nixpkgs itself is formatted that way — fighting that
  isn't worth it. Everywhere else (Lua, shell, TOML, KDL) use tabs.

## Sensitive data

This repo is intended to eventually go public. Never commit secrets,
tokens, API keys, passwords, private SSH keys, or other personal/identifying
data. If a config needs a secret, keep it out of the repo (env var, local
untracked file, agenix/sops, etc.) rather than hardcoding it.

Example: noctalia's Wallhaven API key. `dotfiles/noctalia/settings.json`
keeps `wallhavenApiKey` blank and stays fully tracked; the real key lives in
`~/.config/noctalia/wallhaven-api-key` (untracked, chmod 600) and is passed
via `NOCTALIA_WALLHAVEN_API_KEY`, set in `spawn-at-startup` in
`dotfiles/niri/config.kdl`, which noctalia-shell prioritizes over the JSON
field. Prefer this pattern (native env-var override, or a local untracked
file read at spawn/build time) over `git update-index --skip-worktree`,
which silently stops tracking *all* future changes to a file, not just the
secret field.
