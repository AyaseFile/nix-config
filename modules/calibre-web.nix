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
  cfg = config.modules.calibre-web;
in
{
  options.modules.calibre-web = {
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
    port = mkOption {
      type = types.port;
      default = 8083;
    };
    dataDir = mkOption {
      type = types.path;
    };
    calibreLibrary = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    services.calibre-web = {
      enable = true;
      user = cfg.user;
      group = cfg.group;
      listen = {
        ip = "127.0.0.1";
        port = cfg.port;
      };
      dataDir = cfg.dataDir;
      options.calibreLibrary = cfg.calibreLibrary;
    };

    systemd.services.calibre-web.serviceConfig = cfg.serviceConfig;

    environment.systemPackages = with pkgs; [
      calibre-web
    ];
  };
}
