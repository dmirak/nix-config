{ pkgs, inputs, ... }:
{
  home.packages = [
    (pkgs.python3Packages.callPackage "${inputs.terrascope}/packaging/nix/default.nix" { })
  ];
}
