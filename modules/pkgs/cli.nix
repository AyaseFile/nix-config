{
  config,
  lib,
  pkgs,
  nur-overlays,
  ...
}:

let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.pkgs.cli;
in
{
  imports = [ nur-overlays.btop ];

  options.modules.pkgs.cli = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
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
      ]
      ++ [
        nixd
        nixfmt-rfc-style
      ];
  };
}
