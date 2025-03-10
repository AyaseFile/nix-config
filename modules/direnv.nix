{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.direnv;
in
{
  options.modules.direnv = {
    enable = mkEnableOption "Shell extension that manages your environment";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      package = pkgs.direnv;
      nix-direnv = {
        enable = true;
        package = pkgs.nix-direnv;
      };
    };
  };
}
