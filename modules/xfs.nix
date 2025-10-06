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
  cfg = config.modules.xfs;
in
{
  options.modules.xfs = {
    enable = mkOption {
      type = types.bool;
      default = false;
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
    swapDevices = mkIf cfg.swap.enable [ { device = cfg.swap.swapfile; } ];

    boot.supportedFilesystems = [ "xfs" ];
  };
}
