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
  cfg = config.services.post-archiver-viewer;
  pkg = pkgs.callPackage ../packages/post-archiver-viewer.nix { };
in
{
  options.services.post-archiver-viewer = {
    enable = mkEnableOption "PostArchiverViewer";
    user = mkOption {
      type = types.str;
      description = "User under which the service runs";
    };
    group = mkOption {
      type = types.str;
      description = "Group under which the service runs";
    };
    archiver = mkOption {
      type = types.path;
      description = "Path to the archiver library";
    };
    port = mkOption {
      type = types.int;
      default = 3000;
      description = "Port to run the server on";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    systemd.services.post-archiver-viewer = {
      description = "PostArchiverViewer";
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkg}/bin/post-archiver-viewer --port ${toString cfg.port}";
        User = cfg.user;
        Group = cfg.group;
        StandardOutput = "journal";
        StandardError = "journal";
      };
      environment = {
        ARCHIVER_PATH = cfg.archiver;
      };
    };
  };
}
