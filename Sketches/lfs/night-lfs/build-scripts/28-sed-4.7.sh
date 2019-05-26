# 6.28. Sed-4.7
# - <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/sed.html>

set -e
set -x

cd /sources
tar xf sed-4.7.tar.xz && cd sed-4.7

sed -i 's/usr/tools/'                 build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in

./configure --prefix=/usr --bindir=/bin
make
make html
# make check

make install
install -d -m755           /usr/share/doc/sed-4.7
install -m644 doc/sed.html /usr/share/doc/sed-4.7

cd /sources
rm -rf sed-4.7/
