{
  disko.devices = {
    disk = {
      luks-btrfs = {
        type = "disk";
        device = "<disk>";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "system";
                settings = {
                  crypttabExtraOpts = [
                    "tpm2-device=auto"
                    "password-echo=no"
                    "discard"
                  ];
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [
                        "subvol=@"
                        "noatime"
                        "compress=zstd"
                      ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "subvol=@home"
                        "noatime"
                        "compress=zstd"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "subvol=@nix"
                        "noatime"
                        "compress=zstd"
                      ];
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "subvol=@log"
                        "noatime"
                        "compress=zstd"
                      ];
                    };
                    "@swap" = {
                      mountpoint = "/swap";
                      mountOptions = [
                        "subvol=@swap"
                        "noatime"
                      ];
                      swap.swapfile.size = "<swap_size>";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
