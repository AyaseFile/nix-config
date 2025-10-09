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
    ;
  cfg = config.modules.btrfs;
in
{
  options.modules.btrfs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    rootfs = mkOption {
      type = types.bool;
      default = true;
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
    fileSystems = mkIf cfg.rootfs {
      "/".options = [
        "noatime"
        "compress=zstd"
      ];
      "/home".options = [
        "noatime"
        "compress=zstd"
      ];
      "/nix".options = [
        "noatime"
        "compress=zstd"
      ];
      "/swap".options = [
        "noatime"
      ];
      "/var/log" = {
        options = [
          "noatime"
          "compress=zstd"
        ];
      };
    };

    services.btrfs.autoScrub.enable = true;

    swapDevices = mkIf cfg.swap.enable [ { device = cfg.swap.swapfile; } ];

    boot.supportedFilesystems = [ "btrfs" ];
  };
}
