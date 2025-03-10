{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.pkgs.fonts;
in
{
  options.modules.pkgs.fonts = {
    enable = mkEnableOption "Font packages";
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.code-new-roman
    ];
  };
}
