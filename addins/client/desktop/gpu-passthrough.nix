{ config, pkgs, ... }:

{
  # see https://alexbakker.me/post/nixos-pci-passthrough-qemu-vfio.html for setup guide

  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "amd_iommu=on" "pcie_aspm=off" ]; # pcie_aspm turned off because of AER errors
  boot.kernelModules = [ "kvm-amd"
    "vfio_virtqfd" "vfio_iommu_type1" "vfio"
  ];

  boot.initrd.availableKernelModules = [ "nouveau" "vfio-pci" ];
  boot.initrd.preDeviceCommands = ''
    DEVS="0000:33:00.0 0000:33:00.1"
    for DEV in $DEVS; do
      echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    done
    modprobe -i vfio-pci
  '';
}
