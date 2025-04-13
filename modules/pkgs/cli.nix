{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.pkgs.cli;
in
{
  options.modules.pkgs.cli = {
    enable = mkEnableOption "CLI packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        fd
        fzf
        yazi
        zoxide
      ]
      ++ [
        eza
        file
        lsof
      ]
      ++ [
        bat
        delta
        chafa
        glow
        less
        ripgrep
      ]
      ++ [
        btop
        dust
        ncdu
      ]
      ++ [
        _7zz
        gnutar
      ]
      ++ [
        byobu
        tmux
        vim
      ]
      ++ [
        fastfetch
        starship
        tealdeer
      ]
      ++ [
        git
        git-lfs
        lazygit
      ]
      ++ [
        gnupg
        openssl
      ]
      ++ [
        fishPlugins.fifc
      ];
  };
}
