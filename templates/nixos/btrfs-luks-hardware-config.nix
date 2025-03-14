# ...
{
  # ...
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/<btrfs>";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd"
      "noatime"
    ];
  };

  boot.initrd.luks.devices."system".device = "/dev/disk/by-uuid/<luks>";

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/<esp>";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/<btrfs>";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/<btrfs>";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/<btrfs>";
    fsType = "btrfs";
    options = [
      "subvol=@swap"
      "noatime"
    ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/<btrfs>";
    fsType = "btrfs";
    options = [
      "subvol=@log"
      "compress=zstd"
      "noatime"
    ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];
  # ...
}
