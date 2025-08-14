{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.darwin;
in
{
  options.modules.darwin = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    uid = mkOption {
      type = types.int;
    };
    user = mkOption {
      type = types.singleLineStr;
    };
    rev = mkOption {
      type = types.nullOr types.singleLineStr;
    };
    unfree = mkOption {
      type = types.bool;
    };
    flake = mkOption {
      type = types.path;
    };
  };

  config =
    let
      inherit (cfg)
        enable
        uid
        user
        rev
        unfree
        flake
        ;
    in
    mkIf enable {
      nix = {
        enable = true;
        settings = {
          sandbox = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };
      };

      nixpkgs.config.allowUnfree = unfree;

      users = {
        knownUsers = [ user ];
        users.${user} = {
          uid = uid;
          shell = pkgs.fish;
        };
      };

      security.pam.services.sudo_local.touchIdAuth = true;

      programs.fish = {
        enable = true;
        vendor.config.enable = true;
        vendor.functions.enable = true;
      };

      environment.systemPackages = with pkgs; [
        git
        nh
      ];

      environment.variables = {
        NH_FLAKE = flake;
      };

      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
          extraFlags = [
            "--verbose"
          ];
        };
      };

      system = {
        primaryUser = user;
        configurationRevision = rev;
        stateVersion = 6;
      };
    };
}
