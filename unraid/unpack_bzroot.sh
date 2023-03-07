#!/bin/bash
BZROOT=$1;
if [ -z "${BZROOT}" ] || [ ! -e ${BZROOT} ];
then
    echo "Path for bzroot not provided."
    exit
fi

SKIPBLK=$(cpio -ivt -H newc < ${BZROOT} 2>&1 > /dev/null | awk '{print $1}')
TMPROOT=./tmproot

echo "Skip ${SKIPBLK} to extract "${BZROOT};

/bin/rm -r ${TMPROOT}
mkdir ${TMPROOT}
# Extract usr/src
dd if=${BZROOT} bs=512 skip=${SKIPBLK} | xzcat | (cd ./tmproot; cpio -i -d -H newc --no-absolute-filenames usr/src/linux-* ) 
#dd if=${BZROOT} bs=512 skip=${SKIPBLK} | xzcat | (cd ./tmproot; cpio -i -d -H newc --no-absolute-filenames ) 

KERNAME=$(ls ${TMPROOT}/usr/src/)
KERVER=$(echo ${KERNAME} | cut -d'-' -f2)
KERVERM=$(echo ${KERVER} | cut -d'.' -f1)

# Download source from kernel.org
wget -c  https://cdn.kernel.org/pub/linux/kernel/v${KERVERM}.x/linux-${KERVER}.tar.xz

tar xf linux-${KERVER}.tar.xz

cp -r ${TMPROOT}/usr/src/${KERNAME}/* linux-${KERVER}/
cp -r ${TMPROOT}/usr/src/${KERNAME}/.config linux-${KERVER}/

cd linux-${KERVER}
for patch in $(ls ./*.patch)
do
    patch -p1 < ${patch}
done

cd ../
mv linux-${KERVER} ${KERNAME}

echo "Kernel source ${KERNAME} prepared."

# Get new kernel image after building
#cp linux-5.19.17-unraid/arch/x86/boot/bzImage ./bzimage
#sha256sum bzimage > bzimage.sha256
#
# Extract bzmodules with squashfs-tools-ng
#rdsquashfs -q -u / -p tmpmodules bzmodules
# 
# Generate new bzmodules with squashfs-tools-ng
#
#cp -r /lib/modules/5.19.17-Unraid tmpmodules 
#gensquashfs -q -D tmpmodules  bzmodules
#sha256sum bzmodules > bzmodules.sha256
