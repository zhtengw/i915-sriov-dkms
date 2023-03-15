#!/bin/bash
BZROOT=$1;
if [ -z "${BZROOT}" ] || [ ! -e ${BZROOT} ];
then
    echo "Path for bzroot not provided."
    exit
fi

EXTDIR=$2
SKIPBLK=$(cpio -ivt -H newc < ${BZROOT} 2>&1 > /dev/null | awk '{print $1}')
TMPROOT=./tmproot

echo "Skip ${SKIPBLK} to extract "${BZROOT};

/bin/rm -r ${TMPROOT}
mkdir ${TMPROOT}
# Extract ${EXTDIR}
dd if=${BZROOT} bs=512 skip=${SKIPBLK} | xzcat | (cd ./tmproot; cpio -i -d -H newc --no-absolute-filenames ${EXTDIR} ) 
