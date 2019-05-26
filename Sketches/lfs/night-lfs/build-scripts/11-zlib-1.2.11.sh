# 6.11. Zlib-1.2.11
# <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/zlib.html>

set -e
set -x

cd /sources/
tar xf zlib-1.2.11.tar.xz && cd zlib-1.2.11

./configure --prefix=/usr
make
# make check
make install

mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so

cd /sources && rm -rf zlib-1.2.11