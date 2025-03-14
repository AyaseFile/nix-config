{ nix-config, ... }:

{
  imports = [
    nix-config.nixosModules.pkgs
  ];

  modules.pkgs.cli.enable = true;
}
