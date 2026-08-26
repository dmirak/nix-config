{ pkgs, inputs, ... }:
let
  creamlinux = pkgs.callPackage "${inputs.creamlinux}/package.nix" { };
in
{
  home.packages = [
    # Upstream's webkit renderer deadlocks on nvidia without this.
    (pkgs.symlinkJoin {
      name = "creamlinux";
      paths = [ creamlinux ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/creamlinux \
          --set WEBKIT_DISABLE_DMABUF_RENDERER 1
      '';
    })
  ];
}
