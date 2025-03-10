{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.samba;
in
{
  options.modules.samba = {
    enable = mkEnableOption "Standard Windows interoperability suite of programs for Linux and Unix";

    workgroup = mkOption {
      type = types.str;
      default = "WORKGROUP";
    };

    security = mkOption {
      type = types.str;
      default = "user";
    };

    shares = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
    };

    globalExtraOptions = mkOption {
      type = types.attrsOf types.str;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    users.users.smbuser = {
      isNormalUser = true;
      group = "nogroup";
      shell = pkgs.shadow + "/bin/nologin";
      createHome = false;
    };

    services.samba = {
      enable = true;
      settings = {
        global = {
          "workgroup" = cfg.workgroup;
          "security" = cfg.security;
          "map to guest" = "bad user";
          "vfs objects" = "streams_xattr";
        } // cfg.globalExtraOptions;
      } // cfg.shares;
      openFirewall = true;
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    networking.firewall.allowPing = true;
  };
}
