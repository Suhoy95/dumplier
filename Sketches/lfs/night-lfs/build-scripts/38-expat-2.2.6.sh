# 6.38. Expat-2.2.6

# - <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/expat.html>

cd /sources
tar xf expat-2.2.6.tar.bz2 && cd expat-2.2.6

sed -i 's|usr/bin/env |bin/|' run.sh.in

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.2.6
make
make check

make install
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.6

cd /sources
rm -rf expat-2.2.6
