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
    mkForce
    types
    ;
  cfg = config.modules.linux;
in
{
  options.modules.linux = {
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
        ssh
        tty
        flake
        ;
    in
    mkIf enable {
      nix.settings = {
        sandbox = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      nixpkgs.config.allowUnfree = unfree;

      networking.hostName = host;
      networking.firewall.enable = true;

      time.timeZone = "Asia/Shanghai";

      users = {
        defaultUserShell = pkgs.fish;
        users.${user} = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
        };
      };

      programs.fish = {
        enable = true;
        vendor.config.enable = true;
        vendor.functions.enable = true;
      };

      services.openssh = {
        enable = ssh;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          Ciphers = [
            "aes256-gcm@openssh.com"
            "chacha20-poly1305@openssh.com"
          ];
          KexAlgorithms = [
            "mlkem768x25519-sha256"
            "sntrup761x25519-sha512"
            "sntrup761x25519-sha512@openssh.com"
          ];
          Macs = [
            "hmac-sha2-512-etm@openssh.com"
          ];
        };
      };

      console.enable = mkForce tty;

      environment.systemPackages = with pkgs; [
        git
      ];

      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          dates = "daily";
          extraArgs = "--nogcroots";
        };
        flake = flake;
      };

      i18n = {
        defaultLocale = "zh_CN.UTF-8";
        supportedLocales = [
          "zh_CN.UTF-8/UTF-8"
          "en_US.UTF-8/UTF-8"
        ];
      };

      documentation.man.generateCaches = false;

      system.stateVersion = stateVersion;
    };
}
