{ nix-config, ... }:

{
  imports = [
    nix-config.nixosModules.pkgs
    nix-config.nixosModules.secureboot
  ];

  modules.pkgs.cli.enable = true;

  modules.secureboot.enable = true;
}
