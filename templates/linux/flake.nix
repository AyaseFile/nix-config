{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-config = {
      url = "github:AyaseFile/nix-config/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-config,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      specialArgs = inputs // {
        inherit system pkgs;
      };
      mod = src: if builtins.isFunction src then src specialArgs else import src specialArgs;
    in
    {
      packages.${system} = {
        default = pkgs.symlinkJoin {
          name = "default";
          paths = [
            (mod nix-config.packages.cli).environment.systemPackages
            (mod nix-config.packages.dev).environment.systemPackages
            (mod nix-config.packages.fonts).fonts.packages
            pkgs.fish
            pkgs.direnv
            pkgs.nix-direnv
          ];
        };
      };
    };
}
