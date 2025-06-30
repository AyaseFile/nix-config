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
  cfg = config.programs.qbee-nox;
in
{
  options.programs.qbee-nox = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    port = mkOption {
      type = types.port;
      default = 8080;
    };
    dataPath = mkOption {
      type = types.path;
      default = "/mnt/data/qbee-nox";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    systemd.services.qbee-nox = {
      description = "qbee-nox daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.qbittorrent-enhanced-nox}/bin/qbittorrent-nox --confirm-legal-notice";
        User = "1000";
        Group = "100";
      };
      environment = {
        QBT_WEBUI_PORT = "${toString cfg.port}";
        QBT_PROFILE = cfg.dataPath;
      };
    };

    environment.systemPackages = with pkgs; [
      qbittorrent-enhanced-nox
    ];
  };
}
