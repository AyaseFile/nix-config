{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.podman.jellyfin;
in
{
  options.modules.podman.jellyfin = {
    enable = mkEnableOption "Free Software Media System";

    port = mkOption {
      type = types.port;
      default = 8096;
    };

    mediaPath = mkOption {
      type = types.path;
      default = "/mnt/data/jellyfin/media";
    };

    configPath = mkOption {
      type = types.path;
      default = "/mnt/data/jellyfin/config";
    };

    cachePath = mkOption {
      type = types.path;
      default = "/mnt/data/jellyfin/cache";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    virtualisation.podman.enable = true;

    virtualisation.oci-containers.containers."jellyfin" = {
      autoStart = true;
      image = "jellyfin/jellyfin:latest";
      user = "1000:100";
      volumes = [
        "${cfg.configPath}:/config"
        "${cfg.cachePath}:/cache"
        "${cfg.mediaPath}:/media"
      ];
      extraOptions = [
        "--net=host"
        "--group-add=26" # video group
        "--group-add=303" # render group
      ];
    };
  };
}
