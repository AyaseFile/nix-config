{ pkgs, nix-mods, ... }:

{
  imports = [
    nix-mods.pkgs
    nix-mods.direnv
  ];

  modules.pkgs = {
    cli.enable = true;
    dev.enable = true;
    fonts.enable = true;
    utils.enable = true;
  };

  modules.direnv.enable = true;

  environment.systemPackages = with pkgs; [
    coreutils
    rsync
  ];

  homebrew = {
    brews = [
      "pinentry-mac"
    ];
    casks = [
      "wezterm@nightly"
    ];
  };
}
