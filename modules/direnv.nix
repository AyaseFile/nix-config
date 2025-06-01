{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.direnv;
in
{
  options.modules.direnv = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.direnv = with pkgs; {
      enable = true;
      package = direnv;
      nix-direnv = {
        enable = true;
        package = nix-direnv;
      };
    };
  };
}
