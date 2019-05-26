# 6.31. Bison-3.3.2

# - <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/bison.html>

cd /sources
tar xf bison-3.3.2.tar.xz && cd bison-3.3.2

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.3.2
make
make install

cd /sources
rm -rf bison-3.3.2
