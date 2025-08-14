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
  cfg = config.modules.nixos;
in
{
  imports = [ ./linux.nix ];

  options.modules.nixos = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    user = mkOption {
      type = types.singleLineStr;
    };
    host = mkOption {
      type = types.singleLineStr;
    };
    stateVersion = mkOption {
      type = types.singleLineStr;
    };
    useZen = mkOption {
      type = types.bool;
    };
    unfree = mkOption {
      type = types.bool;
    };
    ssh = mkOption {
      type = types.bool;
    };
    tty = mkOption {
      type = types.bool;
    };
    flake = mkOption {
      type = types.path;
    };
  };

  config =
    let
      inherit (cfg)
        enable
        user
        host
        stateVersion
        unfree
        ssh
        tty
        flake
        ;
    in
    mkIf enable {
      services.fstrim.enable = true;

      boot.kernelPackages = if cfg.useZen then pkgs.linuxPackages_zen else pkgs.linuxPackages_latest;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.efi.efiSysMountPoint = "/efi";

      boot.initrd.compressor = "zstd";
      boot.initrd.systemd.enable = true;

      hardware.enableAllFirmware = true;
      services.fwupd.enable = true;

      networking.networkmanager.enable = true;

      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };

      programs.gnupg.agent.enable = true;

      systemd.targets = {
        sleep.enable = false;
        suspend.enable = false;
        hibernate.enable = false;
        hybrid-sleep.enable = false;
      };

      system.stateVersion = stateVersion;

      modules.linux = {
        enable = true;
        inherit
          user
          host
          stateVersion
          unfree
          ssh
          tty
          flake
          ;
      };
    };
}
