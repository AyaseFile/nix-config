{ config, lib, ... }:

let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.podman.calibre-web;
in
{
  options.modules.podman.calibre-web = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    port = mkOption {
      type = types.port;
      default = 8083;
    };
    configPath = mkOption {
      type = types.path;
      default = "/mnt/data/calibre/config";
    };
    booksPath = mkOption {
      type = types.path;
      default = "/mnt/data/calibre/books";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    virtualisation.podman.enable = true;

    virtualisation.oci-containers.containers.calibre-web = {
      autoStart = true;
      image = "linuxserver/calibre-web:latest";
      volumes = [
        "${cfg.configPath}:/config"
        "${cfg.booksPath}:/books"
      ];
      ports = [ "${toString cfg.port}:8083" ];
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "Asia/Shanghai";
      };
    };
  };
}
