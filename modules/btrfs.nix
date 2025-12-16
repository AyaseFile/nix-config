{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkOption
    mkIf
    types
    optional
    ;
  cfg = config.modules.btrfs;

  mkOpts = [ "noatime" ] ++ optional (cfg.zstd != null) "compress=zstd:${toString cfg.zstd}";
in
{
  options.modules.btrfs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    zstd = mkOption {
      type = types.nullOr types.int;
      default = null;
    };
    swap = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      swapfile = mkOption {
        type = types.path;
        default = "/swap/swapfile";
      };
    };
  };

  config = mkIf cfg.enable {
    fileSystems = {
      "/".options = mkOpts;
      "/home".options = mkOpts;
      "/nix".options = mkOpts;
      "/swap".options = [ "noatime" ];
      "/var/log".options = mkOpts;
    };

    services.btrfs.autoScrub.enable = true;

    swapDevices = mkIf cfg.swap.enable [ { device = cfg.swap.swapfile; } ];

    boot.supportedFilesystems = [ "btrfs" ];
  };
}
