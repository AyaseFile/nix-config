{ nix-config, ... }:

{
  imports = [
    nix-config.nixosModules.pkgs
    nix-config.nixosModules.direnv
  ];

  modules.pkgs = {
    cli.enable = true;
    dev.enable = true;
    fonts.enable = true;
    utils.enable = true;
  };

  modules.direnv.enable = true;

  homebrew = {
    brews = [
      "pinentry-mac"
    ];
    casks = [
      "wezterm"
    ];
  };
}
