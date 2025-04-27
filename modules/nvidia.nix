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
  cfg = config.modules.nvidia;
in
{
  options.modules.nvidia.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable {
    hardware.graphics.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      package = pkgs.linuxKernel.packages.linux_zen.nvidia_x11;
    };

    nixpkgs.config.cudaSupport = true;

    environment.variables = {
      LD_LIBRARY_PATH = "${config.hardware.nvidia.package}/lib";
    };
  };
}
