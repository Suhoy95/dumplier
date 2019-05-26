# 6.14. M4-1.4.18

# <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/m4.html>

set -e
set -x

cd /sources
tar xf m4-1.4.18.tar.xz && cd m4-1.4.18

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

./configure --prefix=/usr
make
# make check
make install

cd /sources
rm -rf m4-1.4.18
