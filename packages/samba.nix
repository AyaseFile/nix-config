smbConfig:
{ pkgs, ... }:

let
  cfg = import smbConfig;
in
{
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
        "workgroup" = "WORKGROUP";
        "security" = "user";
        "map to guest" = "bad user";
        "vfs objects" = "streams_xattr";
      } // (cfg.global or { });
    } // cfg.settings;
    openFirewall = true;
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowPing = true;
}
