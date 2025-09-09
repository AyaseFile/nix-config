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
  cfg = config.modules.jellyfin;
in
{
  options.modules.jellyfin = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    user = mkOption {
      type = types.singleLineStr;
    };
    group = mkOption {
      type = types.singleLineStr;
    };
    serviceConfig = mkOption {
      type = types.attrsOf types.str;
      default = { };
    };
    configDir = mkOption {
      type = types.path;
    };
    dataDir = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      user = cfg.user;
      group = cfg.group;
      configDir = cfg.configDir;
      dataDir = cfg.dataDir;
    };

    systemd.services.jellyfin.serviceConfig = cfg.serviceConfig;

    environment.systemPackages = with pkgs; [
      jellyfin
    ];
  };
}
