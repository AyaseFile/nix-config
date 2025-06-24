{
  pkgs,
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

    virtualisation.libvirtd = with pkgs; {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (OVMFFull.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
