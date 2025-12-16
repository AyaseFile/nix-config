{ lanzaboote }:

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
  cfg = config.modules.secureboot;
in
{
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];

  options.modules.secureboot = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    msKeys = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sbctl
    ];

    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        includeMicrosoftKeys = cfg.msKeys;
        allowBrickingMyMachine = !cfg.msKeys;
        includeChecksumsFromTPM = true;
        autoReboot = true;
      };
    };
  };
}
