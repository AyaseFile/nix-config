{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.pkgs.utils;
in
{
  options.modules.pkgs.utils = {
    enable = mkEnableOption "Utility packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        libarchive
        zip
        unzip
        unar
      ]
      ++ [
        xz
        zstd
      ]
      ++ [
        par2cmdline
      ]
      ++ [
        jq
      ]
      ++ [
        ffmpeg-full
        imagemagick
      ];
  };
}
