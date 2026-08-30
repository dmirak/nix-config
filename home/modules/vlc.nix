{ lib, pkgs, ... }:
let
  mediaTypes = [
    "audio/aac"
    "audio/flac"
    "audio/mp4"
    "audio/mpeg"
    "audio/ogg"
    "audio/opus"
    "audio/webm"
    "audio/x-m4a"
    "audio/x-matroska"
    "audio/x-vorbis+ogg"
    "audio/x-wav"
    "video/mp4"
    "video/mpeg"
    "video/ogg"
    "video/quicktime"
    "video/webm"
    "video/x-flv"
    "video/x-m4v"
    "video/x-matroska"
    "video/x-ms-wmv"
    "video/x-msvideo"
  ];
in
{
  home.packages = [ pkgs.vlc ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.genAttrs mediaTypes (_: "vlc.desktop");
  };
}
