{ vscode-server }:

{ config, lib, ... }:

let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.vscode-server;
in
{
  imports = [
    vscode-server.nixosModules.default
  ];

  options.modules.vscode-server = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.vscode-server.enable = true;
  };
}
