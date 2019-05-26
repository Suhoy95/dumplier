# 6.25. Attr-2.4.48

# - <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/attr.html>

set -e
set -x

cd /sources
tar xf attr-2.4.48.tar.gz && cd attr-2.4.48
./configure --prefix=/usr     \
            --bindir=/bin     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.4.48
make
# make check
make install

mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so

cd /sources
rm -rf attr-2.4.48
