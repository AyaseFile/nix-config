{
  pkgs,
  username,
  hostname,
  allowUnfree,
  ...
}:

{
  imports = [
    ./hardware-config.nix
  ];

  fileSystems."/".options = [
    "compress=zstd"
    "noatime"
  ];

  fileSystems."/home".options = [
    "compress=zstd"
    "noatime"
  ];

  fileSystems."/nix".options = [
    "compress=zstd"
    "noatime"
  ];

  fileSystems."/swap".options = [
    "noatime"
  ];

  fileSystems."/var/log".options = [
    "compress=zstd"
    "noatime"
  ];

  fileSystems."/var/log".neededForBoot = true;

  swapDevices = [ { device = "/swap/swapfile"; } ];

  services.fstrim.enable = true;

  services.btrfs.autoScrub.enable = true;

  boot.initrd.compressor = "zstd";

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

  hardware.enableAllFirmware = true;

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

  services.fwupd.enable = true;

  networking.firewall.enable = true;

  system.stateVersion = "25.05";
}
