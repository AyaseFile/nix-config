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
  cfg = config.services.fanbox-archive;
  pkg = pkgs.callPackage ../packages/fanbox-archive.nix { };
in
{
  options.services.fanbox-archive = {
    enable = mkEnableOption "FanboxArchive";
    user = mkOption {
      type = types.str;
      description = "User under which the service runs";
    };
    group = mkOption {
      type = types.str;
      description = "Group under which the service runs";
    };
    sessid = mkOption {
      type = types.str;
      description = "Your `FANBOXSESSID` cookie";
    };
    output = mkOption {
      type = types.path;
      description = "Which you path want to save";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.fanbox-archive = {
      description = "FanboxArchive";
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkg}/bin/fanbox-archive";
        User = cfg.user;
        Group = cfg.group;
        StandardOutput = "journal";
        StandardError = "journal";
      };
      environment = {
        FANBOXSESSID = cfg.sessid;
        OUTPUT = cfg.output;
      };
    };

    systemd.timers.fanbox-archive = {
      description = "Timer for FanboxArchive";
      wantedBy = [ "timers.target" ];
      wants = [ "fanbox-archive.service" ];
      timerConfig = {
        OnUnitActiveSec = "14d";
        AccuracySec = "1h";
        Persistent = true;
      };
    };
  };
}
