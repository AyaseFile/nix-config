{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      lanzaboote,
    }:
    {
      specialArgs = { inherit inputs; };
      nixosModules = {
        direnv = import ./modules/direnv.nix;
        secureboot = {
          imports = [
            lanzaboote.nixosModules.lanzaboote
            ./modules/secureboot.nix
          ];
        };
      };
      packages = {
        cli = import ./packages/cli.nix;
        dev = import ./packages/dev.nix;
        fonts = import ./packages/fonts.nix;
      };
    };
}
