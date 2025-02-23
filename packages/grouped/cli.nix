{ pkgs, ... }:

{
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
      p7zip
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
      openssl
    ]
    ++ [
      fishPlugins.fifc
    ]
    ++ lib.optionals (system == "aarch64-darwin") [
      pinentry_mac
    ];
}
