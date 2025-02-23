{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    coreutils
    openssl
    gnutar
    libarchive
    zip
    unzip
    p7zip
    unar
    xz
    zstd
    par2cmdline
    ffmpeg-full
    imagemagick
  ];
}
