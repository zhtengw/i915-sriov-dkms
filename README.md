# Linux i915 driver with SR-IOV support (dkms module) for linux 6.2 only

Originally from [linux-intel-lts](https://github.com/intel/linux-intel-lts/tree/lts-v5.15.49-adl-linux-220826T092047Z/drivers/gpu/drm/i915)
Update to [5.15.86](https://github.com/intel/linux-intel-lts/tree/lts-v5.15.86-linux-230131T143409Z/drivers/gpu/drm/i915)

## Notice

This package is **highly experimental**, you should only use it when you know what you are doing.

You need to install this dkms module in **both host and VM!**

For Arch Linux users, it is available in AUR. [i915-sriov-dkms-git](https://aur.archlinux.org/packages/i915-sriov-dkms-git)

Tested kernel versions: 

* `linux-6.2.0-rc7` on Gentoo VM Guest

Tested usages:

- VA-API video acceleration in VM (need to remove any other display device such as virtio-gpu)

## My testing cmdline

```
intel_iommu=on i915.enable_guc=7
```

## Creating virtual functions

```
echo 2 > /sys/devices/pci0000:00/0000:00:02.0/sriov_numvfs
```

You can create up to 7 VFs on UHD Graphics 770
