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
  cfg = config.modules.vfio;
in
{
  options.modules.vfio = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    pciIds = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    blacklist = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [
      ("vfio-pci.ids=" + builtins.concatStringsSep "," cfg.pciIds)
    ];

    boot.kernelModules = [
      "vfio"
      "vfio_pci"
      "vfio_iommu_type1"
    ];

    boot.blacklistedKernelModules = cfg.blacklist;
  };
}
