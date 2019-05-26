# 6.18. MPFR-4.0.2

# <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/mpfr.html>

set -e
set -x

cd /sources
tar xf mpfr-4.0.2.tar.xz && cd mpfr-4.0.2

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.0.2
make
make html
# make check
make install
make install-html

cd /sources
rm -rf mpfr-4.0.2
