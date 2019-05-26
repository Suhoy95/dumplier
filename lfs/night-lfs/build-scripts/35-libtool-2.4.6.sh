# 6.35. Libtool-2.4.6

# - <www.linuxfromscratch.org/lfs/view/stable/chapter06/libtool.html>

cd /sources
tar xf libtool-2.4.6.tar.xz && cd libtool-2.4.6

./configure --prefix=/usr
make
# make -j4 check
# (Five tests are known to fail in the LFS build environment due to a circular
# dependency, but all tests pass if rechecked after automake is installed. )
make install

cd /sources
rm -rf libtool-2.4.6
