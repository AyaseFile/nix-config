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
        secureboot = {
          imports = [
            lanzaboote.nixosModules.lanzaboote
            ./modules/secureboot.nix
          ];
        };
      };
      packages = {
        grouped = {
          cli = import ./packages/grouped/cli.nix;
          dev = import ./packages/grouped/dev.nix;
          fonts = import ./packages/grouped/fonts.nix;
          utils = import ./packages/grouped/utils.nix;
        };
        direnv = import ./packages/direnv.nix;
        samba = import ./packages/samba.nix;
        vscode-server = {
          imports = [
            vscode-server.nixosModules.default
            ./packages/vscode-server.nix
          ];
        };
        frpc = import ./packages/frpc.nix;
        frps = import ./packages/frps.nix;
        tailscale = import ./packages/tailscale.nix;
        caddy-cf-dns = import ./packages/caddy-cf-dns.nix;
      };
      podman = import ./podman;
    };
}
