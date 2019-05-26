# 6.12. File-5.36
# <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/file.html>

set -e
set -x

cd /sources && rm -rf file-5.36 && tar xf file-5.36.tar.gz && cd file-5.36
./configure --prefix=/usr
make
# make check
make install

cd /sources && rm -rf file-5.36
