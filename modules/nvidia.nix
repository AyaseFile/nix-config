{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.modules.nvidia;
in
{
  options.modules.nvidia.enable = mkEnableOption "NVIDIA open-source driver";

  config = mkIf cfg.enable {
    hardware.graphics.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    nixpkgs.config.cudaSupport = true;

    environment.variables = {
      LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}/lib";
    };
  };
}
