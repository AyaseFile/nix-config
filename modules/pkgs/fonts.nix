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
  cfg = config.modules.pkgs.fonts;
in
{
  options.modules.pkgs.fonts = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.code-new-roman
    ];
  };
}
