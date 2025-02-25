{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      lanzaboote,
      vscode-server,
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
        samba = import ./modules/samba.nix;
        vscode-server = {
          imports = [
            vscode-server.nixosModules.default
            ./modules/vscode-server.nix
          ];
        };
        frpc = import ./modules/frpc.nix;
        frps = import ./modules/frps.nix;
        tailscale = import ./modules/tailscale.nix;
      };
      packages = {
        grouped = {
          cli = import ./packages/grouped/cli.nix;
          dev = import ./packages/grouped/dev.nix;
          fonts = import ./packages/grouped/fonts.nix;
          utils = import ./packages/grouped/utils.nix;
        };
      };
      podman = import ./podman;
    };
}
