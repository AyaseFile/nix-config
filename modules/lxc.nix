{
  modulesPath,
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
  cfg = config.modules.lxc;
in
{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./linux.nix
  ];

  options.modules.lxc = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    user = mkOption {
      type = types.singleLineStr;
    };
    host = mkOption {
      type = types.singleLineStr;
    };
    stateVersion = mkOption {
      type = types.singleLineStr;
    };
    unfree = mkOption {
      type = types.bool;
    };
    privileged = mkOption {
      type = types.bool;
    };
    ssh = mkOption {
      type = types.bool;
    };
    tty = mkOption {
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
        user
        host
        stateVersion
        unfree
        privileged
        ssh
        tty
        flake
        ;
    in
    mkIf enable {
      proxmoxLXC = {
        manageNetwork = false;
        privileged = privileged;
      };

      security.sudo.extraRules = [
        {
          users = [ user ];
          commands = [
            {
              command = "ALL";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];

      modules.linux = {
        enable = true;
        inherit
          user
          host
          stateVersion
          unfree
          ssh
          tty
          flake
          ;
      };
    };
}
