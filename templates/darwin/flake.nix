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
    inputs@{ nix-darwin, ... }:
    let
      uid = 501;
      user = "<user>";
      host = "<host>";
      system = "aarch64-darwin";
      unfree = true;
      nix-mods = inputs.nix-config.modules;
    in
    {
      darwinConfigurations.${host} = nix-darwin.lib.darwinSystem {
        system = "${system}";
        specialArgs = inputs // {
          inherit
            uid
            user
            host
            system
            unfree
            nix-mods
            ;
        };
        modules = [
          ./config.nix
          ./nix-config.nix
        ];
      };
    };
}
