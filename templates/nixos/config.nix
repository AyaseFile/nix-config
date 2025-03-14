{
  pkgs,
  config,
  lib,
  username,
  hostname,
  allowUnfree,
  ...
}:

{
  imports = [
    ./hardware-config.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = allowUnfree;

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = [ "btrfs" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."system".crypttabExtraOpts = [
    "tpm2-device=auto"
    "password-echo=no"
    "discard"
  ];

  fileSystems."/var/log".neededForBoot = true;

  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  users.defaultUserShell = pkgs.fish;

  programs.fish = {
    enable = true;
    vendor.config.enable = true;
    vendor.functions.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  programs.gnupg.agent = {
    enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  networking.firewall.enable = true;

  system.stateVersion = "25.05";
}
