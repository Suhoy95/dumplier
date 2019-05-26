# 6.27. Libcap-2.26

# - <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/libcap.html>

set -e
set -x

cd /sources
tar xf libcap-2.26.tar.xz && cd libcap-2.26

sed -i '/install.*STALIBNAME/d' libcap/Makefile
make
make RAISE_SETFCAP=no lib=lib prefix=/usr install
chmod -v 755 /usr/lib/libcap.so.2.26

mv -v /usr/lib/libcap.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so

cd /sources
rm -rf libcap-2.26
