{ config, lib, ... }:

let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.virt-manager;
in
{
  options.modules.virt-manager = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    user = mkOption {
      type = types.singleLineStr;
    };
  };

  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;

    users.groups.libvirtd.members = [ cfg.user ];

    virtualisation.libvirtd.enable = true;

    virtualisation.libvirtd.qemu.swtpm.enable = true;

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
