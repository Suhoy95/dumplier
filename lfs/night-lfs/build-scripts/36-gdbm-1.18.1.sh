# 6.36. GDBM-1.18.1

# - <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/gdbm.html>

cd /sources
tar xf gdbm-1.18.1.tar.gz && cd gdbm-1.18.1

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make
# make check
make install

cd /sources
rm -rf gdbm-1.18.1
