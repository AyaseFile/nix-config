{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.podman.lazydocker;
in
{
  options.modules.podman.lazydocker = {
    enable = mkEnableOption "Simple terminal UI for both docker and docker-compose";

    username = mkOption {
      type = types.str;
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

    users.users.${cfg.username}.extraGroups = [ "podman" ];
  };
}
