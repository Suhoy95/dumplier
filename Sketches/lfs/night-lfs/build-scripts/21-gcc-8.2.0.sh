# 6.21. GCC-8.2.0

# <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/gcc.html>

set -e
set -x

cd /sources
rm -rf gcc-8.2.0 && tar xf gcc-8.2.0.tar.xz && cd gcc-8.2.0

sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64

rm -f /usr/lib/gcc
mkdir -v build && cd build

SED=sed                               \
../configure --prefix=/usr            \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-libmpx         \
             --with-system-zlib
make

# ulimit -s 32768
# rm ../gcc/testsuite/g++.dg/pr83239.C
# chown -Rv nobody .
# su nobody -s /bin/bash -c "PATH=$PATH make -j 5 -k check"
# ../contrib/test_summary | grep -A7 Summ

# # *Note:* verification
# echo 'int main(){}' > dummy.c
# cc dummy.c -v -Wl,--verbose &> dummy.log
# readelf -l a.out | grep ': /lib'
#       [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
# grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
#     /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crt1.o succeeded
#     /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crti.o succeeded
#     /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crtn.o succeeded
# grep -B4 '^ /usr/include' dummy.log
#     #include <...> search starts here:
#     /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include
#     /usr/local/include
#     /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include-fixed
#     /usr/include
# grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
#     SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")
#     SEARCH_DIR("/usr/local/lib64")
#     SEARCH_DIR("/lib64")
#     SEARCH_DIR("/usr/lib64")
#     SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")
#     SEARCH_DIR("/usr/local/lib")
#     SEARCH_DIR("/lib")
#     SEARCH_DIR("/usr/lib");
# grep "/lib.*/libc.so.6 " dummy.log
#     attempt to open /lib/libc.so.6 succeeded
# grep found dummy.log
#     found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2
# rm -v dummy.c a.out dummy.log


mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

cd /sources
rm -rf gcc-8.2.0
