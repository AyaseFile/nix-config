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
      libarchive
      zip
      unzip
      p7zip
      unar
      xz
      zstd
      par2cmdline
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
      ffmpeg-full
      imagemagick
      git
      lazygit
      git-lfs
      gnupg
      tealdeer
    ]
    ++ [
      fishPlugins.fifc
    ]
    ++ lib.optionals (system == "aarch64-darwin") [
      pinentry_mac
    ];
}
