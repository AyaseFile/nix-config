{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libarchive
    zip
    unzip
    unar
    xz
    zstd
    par2cmdline
    ffmpeg-full
    imagemagick
  ];
}
