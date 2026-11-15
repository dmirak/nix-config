{ pkgs, ... }:
{
  home.packages = with pkgs; [
    blender
    aseprite
    renderdoc
    tracy
    sfxr-qt
    csharp-ls
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git.lfs.enable = true;
}
