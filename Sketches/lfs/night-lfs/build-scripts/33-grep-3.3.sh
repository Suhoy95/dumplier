# 6.33. Grep-3.3

# - <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/grep.html>

rm -rf grep-3.3 && tar xf grep-3.3.tar.xz && cd grep-3.3

./configure --prefix=/usr --bindir=/bin
make
# make -k check
make install
