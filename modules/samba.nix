{ config, lib, ... }:

let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.samba;
in
{
  options.modules.samba = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    workgroup = mkOption {
      type = types.singleLineStr;
      default = "WORKGROUP";
    };
    security = mkOption {
      type = types.enum [
        "auto"
        "user"
        "domain"
        "ads"
      ];
      default = "user";
    };
    shares = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
    };
    extraOpts = mkOption {
      type = types.attrsOf types.str;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    services.samba = {
      enable = true;
      settings = {
        global = {
          "workgroup" = cfg.workgroup;
          "security" = cfg.security;
          "map to guest" = "bad user";
          "vfs objects" = "fruit streams_xattr";
          "fruit:copyfile" = "yes";
        }
        // cfg.extraOpts;
      }
      // cfg.shares;
      openFirewall = true;
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    networking.firewall.allowPing = true;
  };
}
