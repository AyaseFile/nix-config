{
  config,
  lib,
  username,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.modules.virt-manager;
in
{
  options.modules.virt-manager.enable = mkEnableOption "Desktop user interface for managing virtual machines";

  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;

    users.groups.libvirtd.members = [ username ];

    virtualisation.libvirtd.enable = true;

    virtualisation.libvirtd.qemu.swtpm.enable = true;

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
