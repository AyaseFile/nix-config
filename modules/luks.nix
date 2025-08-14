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
  cfg = config.modules.luks;
in
{
  options.modules.luks = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config =
    let
      inherit (cfg)
        enable
        ;
    in
    mkIf enable {
      boot.initrd.luks.devices.system.crypttabExtraOpts = [
        "tpm2-device=auto"
        "tpm2-measure-pcr=yes"
        "password-echo=no"
        "no-read-workqueue"
        "no-write-workqueue"
        "discard"
      ];
    };
}
