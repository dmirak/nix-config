{ pkgs, ... }:
{
  home.packages = with pkgs; [
    blender
    aseprite
    renderdoc
    tracy
    sfxr-qt
    (writeShellScriptBin "csharp-ls" ''
      export PATH=${dotnetCorePackages.sdk_10_0}/bin:$PATH
      exec ${csharp-ls}/bin/csharp-ls "$@"
    '')
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git.lfs.enable = true;
}
