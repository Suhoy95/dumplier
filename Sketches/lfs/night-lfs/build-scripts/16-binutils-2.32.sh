# 6.16. Binutils-2.32

# <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/binutils.html>

set -e
set -x

cd /sources/
tar xf binutils-2.32.tar.xz && cd binutils-2.32

mkdir -v build-lfs && cd build-lfs

../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib

make tooldir=/usr
# make -k check
#      (debug_msg.sh is known to fail)

make tooldir=/usr install

cd /sources/
rm -rf binutils-2.32
