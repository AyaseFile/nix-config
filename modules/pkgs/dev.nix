{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.pkgs.dev;
in
{
  options.modules.pkgs.dev = {
    enable = mkEnableOption "Dev packages";
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
