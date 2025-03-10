{ vscode-server }:

{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.vscode-server;
in
{
  imports = [
    vscode-server.nixosModules.default
  ];

  options.modules.vscode-server = {
    enable = mkEnableOption "Visual Studio Code Server support in NixOS";
  };

  config = mkIf cfg.enable {
    services.vscode-server.enable = true;
  };
}
