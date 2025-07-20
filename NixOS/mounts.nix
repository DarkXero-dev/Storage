{ ... }:

{
  # Automount Drives
  fileSystems = {
    "/mnt/XeroLinux" = {
      device = "/dev/disk/by-uuid/c17ca2c4-b59b-467d-91fb-e69af504799f";
      fsType = "ext4";
    };

    "/mnt/Stuffed" = {
      device = "/dev/disk/by-uuid/0b1f92a9-cb26-4f05-8346-4059285c5088";
      fsType = "xfs";
    };

    "/mnt/Linux" = {
      device = "/dev/disk/by-uuid/d19923d1-2482-4d8b-9d44-f83a75440165";
      fsType = "ext4";
    };

    "/mnt/Games" = {
      device = "/dev/disk/by-uuid/8a69f985-6d4d-499b-a462-decd15f00cd1";
      fsType = "xfs";
    };
  };
}
