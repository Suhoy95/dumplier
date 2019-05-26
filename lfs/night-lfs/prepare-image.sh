#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/Config.sh

function clear_mount_lfs()
{
    losetup -P /dev/loop0 lfs.img
    mkfs.vfat /dev/loop0p1
    mkfs.ext4 -F /dev/loop0p2

    mkdir -pv $LFS
    mount -v -t ext4 /dev/loop0p2 $LFS

    mkdir -vp $LFS/boot
    mount -v -t vfat /dev/loop0p1 $LFS/boot

# 6.2. Preparing Virtual Kernel File Systems
# www.linuxfromscratch.org/lfs/view/stable/chapter06/kernfs.html>
    mkdir -pv $LFS/{dev,proc,sys,run}
    mknod -m 600 $LFS/dev/console c 5 1
    mknod -m 666 $LFS/dev/null c 1 3
    mount -v --bind /dev $LFS/dev

    mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
    mount -vt proc proc $LFS/proc
    mount -vt sysfs sysfs $LFS/sys
    mount -vt tmpfs tmpfs $LFS/run
}

function umount_lfs()
{
    set +e
    rm $LFS/dev/console
    rm $LFS/dev/null
    umount $LFS/dev/pts
    umount $LFS/dev
    umount $LFS/proc
    umount $LFS/sys
    umount $LFS/run

    umount $LFS/boot
    umount $LFS/host
    umount $LFS
    losetup -d /dev/loop0
    set -e
}

echo "TODO: image name as parameter"
set -e
set -x

if [ ! -f lfs.img ]; then
dd bs=1GiB count=15 status=progress if=/dev/zero of=lfs.img
fi

gdisk lfs.img <<'GDISK_INPUT'
o
Y
n
1
2048
+512M
ef00
n
2
1050624
+6G
8300
w
Y
GDISK_INPUT

umount_lfs
clear_mount_lfs

#=======================================
# Retrieve sources and built tools
mkdir -vp $LFS/sources
mkdir -vp $LFS/host
mount -v -t ext4 $HOST_LFS $LFS/host
cp -v $LFS/host/sources/*.tar.{gz,xz,bz2} $LFS/sources/
cp -v $LFS/host/sources/*.patch $LFS/sources/
cp -v $LFS/host/sources/md5sums $LFS/sources/
umount $HOST_LFS
rmdir $LFS/host

pushd $LFS/sources
md5sum -c md5sums
popd

#=======================================
# Extract build tools from Chapter 5
cp -v $DIR/../tools.tar $LFS/
pushd $LFS
tar xf tools.tar
mv -v $LFS/mnt/lfs/tools $LFS/tools
rm tools.tar
rm -rf mnt
popd

# 5.35. Stripping
# http://www.linuxfromscratch.org/lfs/view/stable/chapter05/stripping.html
set +e
/usr/bin/strip --strip-debug $LFS/tools/lib/*
/usr/bin/strip --strip-unneeded $LFS/tools/{,s}bin/*
set -e
rm -rf $LFS/tools/{,share}/{info,man,doc}
find $LFS/tools/{lib,libexec} -name \*.la -delete

# 5.36. Changing Ownership
# http://www.linuxfromscratch.org/lfs/view/stable/chapter05/changingowner.html
chown -R root:root $LFS/{tools,sources}
