{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Ensure that LUKS device is decrypted at startup
  boot.initrd.luks.devices.crypted.device =
    "/dev/disk/by-uuid/b45ff963-e7f7-4cbe-8581-7b9468889f52";

  fileSystems."/" = {
    # Mount the root filesystem as the named "root" volume on the LUKS device
    device = "/dev/vg/root";
    fsType = "ext4";
    options = [ "noatime" "nodiratime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2B83-A9CF";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/vg/swap"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
