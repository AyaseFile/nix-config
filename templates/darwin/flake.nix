{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-config = {
      url = "github:AyaseFile/nix-config/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      nix-config,
    }:
    let
      username = "<user>";
      uid = 501;
      hostname = "<host>";
      system = "aarch64-darwin";
      allowUnfree = true;
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        system = "${system}";
        specialArgs = inputs // {
          inherit
            username
            uid
            hostname
            system
            allowUnfree
            ;
        };
        modules = [
          ./config.nix
          nix-config.packages.cli
          nix-config.packages.fonts
          nix-config.packages.dev
          nix-config.nixosModules.direnv
        ];
      };
    };
}
