# 6.10. Adjusting the Toolchain

# <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/adjusting.html>

set -e
set -x

mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld

gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs

# *Note:* verification
# echo 'int main(){}' > dummy.c
# cc dummy.c -v -Wl,--verbose &> dummy.log
# readelf -l a.out | grep ': /lib'
#       [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]

# grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
#     /usr/lib/../lib/crt1.o succeeded
#     /usr/lib/../lib/crti.o succeeded
#     /usr/lib/../lib/crtn.o succeeded

# grep -B1 '^ /usr/include' dummy.log
#     #include <...> search starts here:
#         /usr/include

# grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
#     SEARCH_DIR("=/tools/x86_64-pc-linux-gnu/lib64")
#     SEARCH_DIR("/usr/lib")
#     SEARCH_DIR("/lib")
#     SEARCH_DIR("=/tools/x86_64-pc-linux-gnu/lib");

# grep "/lib.*/libc.so.6 " dummy.log
#     attempt to open /lib/libc.so.6 succeeded

# grep found dummy.log
#     found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2

# rm -v dummy.c a.out dummy.log