_:
{
  home.sessionVariables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "z" "sudo" "colored-man-pages" "command-not-found" ];
    };
    initContent = ''
      DEFAULT_USER="$USER"

      # kernel-modules is the closure of every module, out-of-tree ones
      # (nvidia) included, so a driver bump shows up even when the kernel
      # itself is unchanged.
      nixos-needs-reboot() {
        local part
        local -a stale
        for part in kernel initrd kernel-modules; do
          if [ "$(readlink -f /run/booted-system/$part)" != "$(readlink -f /run/current-system/$part)" ]; then
            stale+=("$part")
          fi
        done
        if (( ''${#stale} )); then
          print -P "%F{yellow}reboot pending:%f ''${(j:, :)stale} changed since boot"
        else
          print -P "%F{green}no reboot needed%f"
        fi
      }

      fastfetch
    '';
    shellAliases = {
      note = "nvim ~/.notes.md";
      nixos-rebuild-switch = "sudo nixos-rebuild switch --flake ~/nix-config#nixos-pc && nixos-needs-reboot";
      nixos-upgrade = "sudo chown -R david ~/nix-config/.git/objects && nh os switch -u -H nixos-pc ~/nix-config && nixos-needs-reboot";
    };
  };
}
