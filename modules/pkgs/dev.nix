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
  cfg = config.modules.pkgs.dev;
in
{
  options.modules.pkgs.dev = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        nixd
        nixfmt-rfc-style
      ]
      ++ [
        uv
      ];
  };
}
