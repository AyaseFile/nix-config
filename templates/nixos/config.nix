{
  pkgs,
  host,
  unfree,
  user,
  ...
}:

{
  imports = [ ./hardware-config.nix ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = unfree;

  fileSystems = {
    "/".options = [
      "compress=zstd"
      "noatime"
    ];
    "/home".options = [
      "compress=zstd"
      "noatime"
    ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
    "/swap".options = [
      "noatime"
    ];
    "/var/log" = {
      options = [
        "compress=zstd"
        "noatime"
      ];
      neededForBoot = true;
    };
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  services.fstrim.enable = true;

  services.btrfs.autoScrub.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = [ "btrfs" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  boot.initrd.compressor = "zstd";
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."system".crypttabExtraOpts = [
    "tpm2-device=auto"
    "password-echo=no"
    "discard"
  ];

  hardware.enableAllFirmware = true;
  services.fwupd.enable = true;

  networking.hostName = host;
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "Asia/Shanghai";

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

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
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  programs.gnupg.agent.enable = true;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  system.stateVersion = "25.05";
}
