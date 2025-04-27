{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-config = {
      url = "github:AyaseFile/nix-config/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      unfree = true;
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = unfree;
        };
      };
      evalModule =
        module:
        let
          fakeLib = nixpkgs.lib // {
            mkOption = _: true;
            mkIf = cond: val: if cond then val else { };
          };
          result = module {
            inherit pkgs;
            lib = fakeLib;
            config.modules.pkgs = {
              cli.enable = true;
              dev.enable = true;
              fonts.enable = true;
              utils.enable = true;
            };
          };
          config = result.config or { };
        in
        config.environment.systemPackages or config.fonts.packages or [ ];
      cli = evalModule (import "${inputs.nix-config}/modules/pkgs/cli.nix");
      dev = evalModule (import "${inputs.nix-config}/modules/pkgs/dev.nix");
      fonts = evalModule (import "${inputs.nix-config}/modules/pkgs/fonts.nix");
      utils = evalModule (import "${inputs.nix-config}/modules/pkgs/utils.nix");
    in
    {
      packages.${system} = {
        default = pkgs.symlinkJoin {
          name = "default";
          paths = [
            cli
            dev
            fonts
            utils
            pkgs.man
            pkgs.fish
            pkgs.direnv
            pkgs.nix-direnv
          ];
        };
      };
    };
}
