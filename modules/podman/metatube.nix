{ config, lib, ... }:

let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.podman.metatube;
in
{
  options.modules.podman.metatube = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    port = mkOption {
      type = types.port;
      default = 8080;
    };
    configPath = mkOption {
      type = types.path;
      default = "/mnt/data/metatube/config";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    virtualisation.podman.enable = true;

    virtualisation.oci-containers.containers.metatube = {
      autoStart = true;
      image = "ghcr.io/metatube-community/metatube-server:latest";
      user = "1000:100";
      volumes = [
        "${cfg.configPath}:/config"
      ];
      ports = [ "${toString cfg.port}:8080" ];
      cmd = [
        "-dsn"
        "/config/metatube.db"
      ];
    };
  };
}
