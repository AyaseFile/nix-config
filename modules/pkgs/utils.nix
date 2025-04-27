{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.pkgs.utils;
in
{
  options.modules.pkgs.utils = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
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
