# 6.17. GMP-6.1.2

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/gmp.html>

set -e
set -x

cd /sources
tar xf gmp-6.1.2.tar.xz && cd gmp-6.1.2

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.2
make
make html
# make check 2>&1 | tee gmp-check-log
# awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
# awk '/# FAIL:/{total+=$3} ; END{print total}' gmp-check-log
# awk '/# XPASS:/{total+=$3} ; END{print total}' gmp-check-log

make install
make install-html

cd /sources
rm -rf gmp-6.1.2
