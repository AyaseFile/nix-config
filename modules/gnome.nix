{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkOption
    mkIf
    mkForce
    types
    ;
  cfg = config.modules.gnome;
in
{
  options.modules.gnome.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable {
    services.displayManager.gdm = {
      enable = true;
      autoSuspend = false;
      wayland = true;
    };
    services.desktopManager.gnome.enable = true;

    services.displayManager.autoLogin.enable = false;

    services.flatpak.enable = false;
    services.fprintd.enable = true;
    services.gnome.gnome-keyring.enable = true;

    programs.ssh.enableAskPassword = true;
    programs.ssh.askPassword = mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];

    environment.systemPackages =
      with pkgs;
      [
        file-roller
        gnome-themes-extra
        gnome-tweaks
        nautilus-python
        pinentry-gnome3
        seahorse
        zenity
      ]
      ++ [
        gnomeExtensions.appindicator
        gnomeExtensions.blur-my-shell
        gnomeExtensions.dash-to-dock
        gnomeExtensions.space-bar
        gnomeExtensions.system-monitor
      ]
      ++ [
        gnome-firmware
        sof-firmware
        fprintd
      ]
      ++ [
        ibus-engines.rime
      ];

    environment.gnome.excludePackages = with pkgs; [
      decibels
      epiphany
      geary
      gnome-backgrounds
      gnome-connections
      gnome-console
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-tour
      gnome-user-docs
      gnome-weather
      orca
      simple-scan
      snapshot
      totem
      yelp
    ];

    programs.dconf.enable = true;

    services.desktopManager.gnome.extraGSettingsOverridePackages = with pkgs; [
      gsettings-desktop-schemas
      mutter
      nautilus
      gnome-settings-daemon
      gnome-shell
    ];

    services.xserver.excludePackages = with pkgs; [
      xterm
    ];

    i18n = {
      defaultLocale = "zh_CN.UTF-8";
      supportedLocales = [
        "zh_CN.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
      ];
      inputMethod = {
        enable = true;
        type = "ibus";
        ibus.engines = with pkgs.ibus-engines; [
          (rime.override {
            rimeDataPkgs = with pkgs; [ rime-ice ];
          })
        ];
      };
    };

    environment.extraSetup = ''
      rm -f $out/share/applications/cups.desktop
    '';

    documentation.nixos.enable = false;
  };
}
