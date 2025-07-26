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
    concatStringsSep
    ;
  cfg = config.modules.vfio;
in
{
  options.modules.vfio = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    gpuDevices = mkOption {
      type = types.listOf types.str;
      default = [
        "pci_0000_01_00_0"
        "pci_0000_01_00_1"
      ];
    };
    hostModules = mkOption {
      type = types.listOf types.str;
      default = [
        "nvidia_uvm"
        "nvidia_drm"
        "nvidia_modeset"
        "nvidia"
      ];
    };
    blacklist = mkOption {
      type = types.listOf types.str;
      default = [
        "btmtk"
        "btintel"
        "btbcm"
        "btusb"
        "bluetooth"
      ];
    };
    vmName = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [
      "vfio"
      "vfio_pci"
      "vfio_iommu_type1"
    ];

    boot.blacklistedKernelModules = cfg.blacklist;

    virtualisation.libvirtd.hooks.qemu = {
      "pt" = lib.getExe (
        pkgs.writeShellApplication {
          name = "qemu-hook";
          runtimeInputs = with pkgs; [
            kmod
            libvirt
          ];
          text = ''
            if [ "$1" != "${cfg.vmName}" ]; then
              exit 0;
            fi

            if [ "$2" == "prepare" ]; then
              modprobe -r -a ${concatStringsSep " " cfg.hostModules}
              for dev in ${concatStringsSep " " cfg.gpuDevices}; do
                virsh nodedev-detach "$dev"
              done
            fi

            if [ "$2" == "release" ]; then
              for dev in ${concatStringsSep " " cfg.gpuDevices}; do
                virsh nodedev-reattach "$dev"
              done
              modprobe -a ${concatStringsSep " " cfg.hostModules}
            fi
          '';
        }
      );
    };
  };
}
