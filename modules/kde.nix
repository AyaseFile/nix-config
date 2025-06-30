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
  cfg = config.modules.kde;
in
{
  options.modules.kde.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable {
    services = {
      displayManager = {
        sddm = {
          enable = true;
          wayland = {
            enable = true;
            compositor = "kwin";
          };
          settings.General.DisplayServer = "wayland";
        };
        autoLogin.enable = false;
      };
      desktopManager.plasma6.enable = true;
    };

    services.flatpak.enable = false;
    services.fprintd.enable = true;
    services.gnome.gnome-keyring.enable = true;

    hardware.bluetooth.enable = true;

    programs.ssh.enableAskPassword = true;
    programs.ssh.askPassword = mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-color-emoji
    ];

    fonts.fontconfig.localConf = ''
      <match target="font">
        <test name="family" qual="first">
          <string>Noto Color Emoji</string>
        </test>
        <edit name="antialias" mode="assign">
          <bool>false</bool>
        </edit>
      </match>
    '';

    environment.systemPackages =
      with pkgs;
      [
        pinentry-gnome3
        seahorse
        kdePackages.kdialog
      ]
      ++ [
        sof-firmware
        fprintd
      ];

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      khelpcenter
      krdp
      xwaylandvideobridge
    ];

    i18n = {
      defaultLocale = "zh_CN.UTF-8";
      supportedLocales = [
        "zh_CN.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
      ];
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          addons = with pkgs; [
            kdePackages.fcitx5-qt
            fcitx5-fluent
            (fcitx5-rime.override {
              rimeDataPkgs = [ rime-ice ];
            })
          ];
          waylandFrontend = true;
          settings = {
            addons = {
              classicui.globalSection.Theme = "FluentDark-solid";
            };
            inputMethod = {
              "Groups/0" = {
                Name = "Default";
                "Default Layout" = "us";
                DefaultIM = "keyboard-us";
              };
              "Groups/0/Items/0" = {
                Name = "rime";
                Layout = "";
              };
              "Groups/0/Items/1" = {
                Name = "keyboard-us";
                Layout = "";
              };
            };
          };
        };
      };
    };

    environment.extraSetup = ''
      rm -f $out/share/applications/cups.desktop
    '';

    documentation.nixos.enable = false;
  };
}
