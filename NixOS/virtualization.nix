{ ... }:

{
  boot.kernelModules = [ "kvm-amd" ];

  # Virt-Manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["xero"];
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  services = {
    spice-vdagentd.enable = true;
    qemuGuest.enable = true;
  };
}
