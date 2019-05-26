# 6.23. Pkg-config-0.29.2

# - <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/pkg-config.html>

set -e
set -x

cd /sources/
tar xf pkg-config-0.29.2.tar.gz && cd pkg-config-0.29.2

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2
make
# make check
make install

cd /sources/
rm -rf pkg-config-0.29.2
