# 6.29. Psmisc-23.2

# - <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/psmisc.html>
set -e
set -x

cd /sources
tar xf psmisc-23.2.tar.xz && cd psmisc-23.2

./configure --prefix=/usr
make
make install

mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin

cd /sources
rm -rf psmisc-23.2
