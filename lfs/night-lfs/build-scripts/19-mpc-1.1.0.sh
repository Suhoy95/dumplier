# 6.19. MPC-1.1.0

# <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/mpc.html>

set -e
set -x

cd /sources
tar xf mpc-1.1.0.tar.gz && cd mpc-1.1.0

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.1.0
make
make html
# make check
make install
make install-html

cd /sources
rm -rf mpc-1.1.0
