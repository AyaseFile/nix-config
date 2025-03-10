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
        fzf
        fd
        zoxide
        eza
        yazi
        bat
        less
        glow
        chafa
        gnutar
        _7zz
        btop
        lsof
        dust
        ncdu
        ripgrep
        jq
        delta
        vim
        byobu
        tmux
        fastfetch
        starship
        git
        lazygit
        git-lfs
        gnupg
        tealdeer
        coreutils
        file
        openssl
      ]
      ++ [
        fishPlugins.fifc
      ]
      ++ lib.optionals (system == "aarch64-darwin") [
        pinentry_mac
      ];
  };
}
