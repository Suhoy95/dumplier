# 6.37. Gperf-3.1

# - <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/gperf.html>

cd /sources
tar xf gperf-3.1.tar.gz && cd gperf-3.1

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make
# make -j1 check
make install

cd /sources
rm -rf gperf-3.1
