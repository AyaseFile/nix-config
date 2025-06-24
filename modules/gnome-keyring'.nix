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
  cfg = config.modules.gnome-keyring';
in
{
  options.modules.gnome-keyring'.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    systemd.user.services.gnome-keyring-daemon = {
      unitConfig = {
        Description = "GNOME Keyring Daemon";
      };
      serviceConfig = {
        ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --foreground --components=pkcs11,secrets,ssh,gpg";
        Restart = "on-failure";
      };
    };

    systemd.user.targets."default.target".wants = [
      "gnome-keyring-daemon.service"
    ];
  };
}
