{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-config = {
      url = "github:AyaseFile/nix-config/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nur-packages.follows = "nur-packages";
    };
    nur-packages = {
      url = "github:AyaseFile/nur-packages/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      user = "<user>";
      host = "<host>";
      system = "x86_64-linux";
      unfree = true;
      flake = "<flake>";
      nix-mods = inputs.nix-config.modules;
      nur-mods = inputs.nur-packages.modules;
      nur-pkgs = inputs.nur-packages.packages.${system};
    in
    {
      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        system = "${system}";
        specialArgs = inputs // {
          inherit
            user
            host
            system
            unfree
            flake
            nix-mods
            nur-mods
            nur-pkgs
            ;
        };
        modules = [
          ./config.nix
          ./nix-config.nix
        ];
      };
    };
}
