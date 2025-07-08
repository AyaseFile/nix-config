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
        unar
      ]
      ++ [
        par2cmdline
      ]
      ++ [
        ffmpeg-full
        imagemagick
      ];
  };
}
