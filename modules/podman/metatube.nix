{ config, lib, ... }:

let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.podman.metatube;
  utils = import ./utils.nix;
in
{
  options.modules.podman.metatube = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    ver = mkOption {
      type = types.singleLineStr;
      default = "latest";
    };
    user = mkOption {
      type = types.singleLineStr;
    };
    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    port = mkOption {
      type = types.port;
      default = 8080;
    };
    configPath = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.metatube = {
      autoStart = true;
      image = "ghcr.io/metatube-community/metatube-server:${cfg.ver}";
      podman = {
        user = cfg.user;
        sdnotify = "healthy";
      };
      volumes = [
        "${cfg.configPath}:/config"
      ];
      ports = [ "${toString cfg.port}:8080" ];
      cmd = [
        "-dsn"
        "/config/metatube.db"
      ];
      extraOptions = utils.genOpts "curl -f http://127.0.0.1:8080 || exit 1" ++ cfg.extraOptions;
    };
  };
}
