{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      username = "<user>";
      hostname = "<host>";
      system = "x86_64-linux";
      allowUnfree = true;
      privileged = false;
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        system = "${system}";
        specialArgs = inputs // {
          inherit
            username
            hostname
            system
            allowUnfree
            privileged
            ;
        };
        modules = [
          ./config.nix
          ./nix-config.nix
        ];
      };
    };
}
