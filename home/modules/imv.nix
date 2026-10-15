{ lib, pkgs, ... }:
let
  imageTypes = [
    "image/avif"
    "image/bmp"
    "image/gif"
    "image/heif"
    "image/jpeg"
    "image/jxl"
    "image/png"
    "image/svg+xml"
    "image/tiff"
    "image/webp"
  ];
in
{
  home.packages = [ pkgs.imv ];

  # upstream imv.desktop sets NoDisplay=true; this hiPrio entry replaces it
  xdg.desktopEntries.imv = {
    name = "imv";
    genericName = "Image Viewer";
    comment = "Fast Image Viewer";
    exec = "imv %F";
    icon = "multimedia-photo-viewer";
    terminal = false;
    noDisplay = false;
    categories = [ "Graphics" "2DGraphics" "Viewer" ];
    mimeType = imageTypes;
    settings.Keywords = "photo;picture;";
  };

  xdg.configFile."imv/config".text = ''
    [binds]
    <bracketleft> = rotate by -90
    <bracketright> = rotate by 90
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.genAttrs imageTypes (_: "imv.desktop");
  };
}
