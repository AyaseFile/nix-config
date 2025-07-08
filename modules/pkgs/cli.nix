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
        less
        ripgrep
      ]
      ++ [
        btop
        dust
        ncdu
      ]
      ++ [
        gnutar
        zstd
        (if pkgs.config.allowUnfree then _7zz-rar else _7zz)
      ]
      ++ [
        byobu
        tmux
        vim
      ]
      ++ [
        fastfetch
        starship
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
