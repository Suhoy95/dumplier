# 6.30. Iana-Etc-2.30

# - <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/iana-etc.html>

set -e
set -x

cd /sources
tar xf iana-etc-2.30.tar.bz2 && cd iana-etc-2.30

make
make install

cd /sources
rm -rf iana-etc-2.30
