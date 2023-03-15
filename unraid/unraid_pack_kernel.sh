#!/bin/bash
URVER="6.11.5"
URZIP="unRAIDServer-${URVER}-x86_64.zip"
PWD=$(pwd)

# The link is found from https://unraid.net/download
# echo https://unraid-dl.sfo2.cdn.digitaloceanspaces.com/stable/${URZIP}
wget -c https://unraid-dl.sfo2.cdn.digitaloceanspaces.com/stable/${URZIP}

unzip ${URZIP} -d ${PWD}/tmp
BZROOT=${PWD}/tmp/bzroot
TMPROOT=${PWD}/tmproot

# Extract usr/src
EXTDIR="usr/src/linux-*"
if [[ -e unraid_unpack_bzroot.sh  ]];
then
    bash unraid_unpack_bzroot.sh ${BZROOT} ${EXTDIR}
else
    SKIPBLK=$(cpio -ivt -H newc < ${BZROOT} 2>&1 > /dev/null | awk '{print $1}')

    echo "Skip ${SKIPBLK} to extract "${BZROOT};

    /bin/rm -r ${TMPROOT}
    mkdir ${TMPROOT}
    dd if=${BZROOT} bs=512 skip=${SKIPBLK} | xzcat | (cd ${TMPROOT}; cpio -i -d -H newc --no-absolute-filenames ${EXTDIR} ) 
fi

KERNAME=$(ls ${TMPROOT}/usr/src/)
KERVER=$(echo ${KERNAME} | cut -d'-' -f2)
KERVERUR=$(echo ${KERNAME} | cut -d'-' -f2-)
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

# Compile kernel
#cp config-${KERVERUR} ${KERNAME}/.config
#cd ${KERNAME}
#make oldconfig
#make -j4
#make modules_install
#cd ${PWD}

# Get new kernel image after building
#cp linux-5.19.17-Unraid/arch/x86/boot/bzImage ./bzimage
#sha256sum bzimage > bzimage.sha256
#
# Extract bzmodules with squashfs-tools-ng
#rdsquashfs -q -u / -p tmpmodules bzmodules
# 
# Generate new bzmodules with squashfs-tools-ng
#
#cp -r /lib/modules/${KERVERUR} tmpmodules 
#gensquashfs -q -D tmpmodules  bzmodules
#sha256sum bzmodules > bzmodules.sha256
