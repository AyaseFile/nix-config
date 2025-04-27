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
  cfg = config.modules.podman.lazydocker;
in
{
  options.modules.podman.lazydocker = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    user = mkOption {
      type = types.singleLineStr;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lazydocker
    ];

    virtualisation.podman = {
      enable = true;
      dockerSocket.enable = true;
    };

    users.users.${cfg.user}.extraGroups = [ "podman" ];
  };
}
