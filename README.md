# Linux i915 driver with SR-IOV support (dkms module) for linux-5.15 only

Originally from [linux-intel-lts](https://github.com/intel/linux-intel-lts/tree/lts-v5.10.145-yocto-221108T131909Z/drivers/gpu/drm/i915)

## Notice

This package is **highly experimental**, you should only use it when you know what you are doing.

Tested kernel version:
 * pve-kernel-5.15 on PVE VM Host
 * linux-5.15.43-Unraid on unRAID 6.10.2 Host and Guest

## My testing cmdline

```
intel_iommu=on i915.enable_guc=7
```

## Creating virtual functions

```
echo 2 > /sys/devices/pci0000:00/0000:00:02.0/sriov_numvfs
```

You can create up to 7 VFs on UHD Graphics 770
