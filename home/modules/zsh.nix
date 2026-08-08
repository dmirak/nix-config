{ ... }:
{
  home.sessionVariables.EDITOR = "nvim";

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
      nixos-rebuild-switch = "sudo nixos-rebuild switch --flake ~/nix-config#nixos-pc";
      nixos-upgrade = "nix flake update ~/nix-config && sudo nixos-rebuild switch --flake ~/nix-config#nixos-pc";
    };
  };
}
