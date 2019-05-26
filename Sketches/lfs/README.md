# Linux From Scratch

Plan outline:

- Compile LFS version 8.4 (<http://www.linuxfromscratch.org/lfs/view/stable/index.html>)
- Strip Linux kernel:
    - Boot
    - USB drive
    - Disable `/dev/mem` limitation

```bash
dd if=/dev/mem of=/dev/sdbX
```

*Note:* plan has not been done yet. Bur it was glory Linux building in
one continuos day from Friday 17 May to Saturday 18 May.

## Refresh Knowledge links

- <http://www.tldp.org/HOWTO/Software-Building-HOWTO.html> --
 Building and Installing Software Packages for Linux
- <https://web.archive.org/web/20190505064248/http://moi.vonos.net/linux/beginners-installing-from-source/>
-- Beginner's Guide to Installing from Source
- <http://www.linuxfromscratch.org/lfs/view/stable/chapter02/stages.html>
-- checklist of pre-requirements on each stage

## 2.2. Host System Requirements

- <www.linuxfromscratch.org/lfs/view/stable/chapter02/hostreqs.html>
- [./version-check.sh](./version-check.sh)

```bash
ll /bin/sh
> lrwxrwxrwx 1 root root 4 мая  2 19:15 /bin/sh -> dash*
rm /bin/sh && ln --symbolic /bin/bash /bin/sh
```

```bash
sudo apt-get install bash binutils binutils-dev bison bzip2 coreutils diffutils \
    findutils gawk gcc g++ glibc-doc glibc-source grep gzip \
    linux-headers-4.18.0-18-generic m4 make patch perl sed tar texinfo xz-utils
```

**TODO:** validate the version according with chapter, it should be OK.

```text
$ bash version-check.sh
bash, version 4.4.19(1)-release
/bin/sh -> /bin/bash
Binutils: (GNU Binutils for Ubuntu) 2.30
bison (GNU Bison) 3.0.4
/usr/bin/yacc -> /usr/bin/bison.yacc
bzip2,  Version 1.0.6, 6-Sept-2010.
Coreutils:  8.28
diff (GNU diffutils) 3.6
find (GNU findutils) 4.7.0-git
GNU Awk 4.1.4, API: 1.1 (GNU MPFR 4.0.1, GNU MP 6.1.2)
/usr/bin/awk -> /usr/bin/gawk
gcc (Ubuntu 7.4.0-1ubuntu1~18.04) 7.4.0
g++ (Ubuntu 7.4.0-1ubuntu1~18.04) 7.4.0
(Ubuntu GLIBC 2.27-3ubuntu1) 2.27
grep (GNU grep) 3.1
gzip 1.6
Linux version 4.18.0-18-generic (buildd@lcy01-amd64-006) (gcc version 7.3.0 \
    (Ubuntu 7.3.0-16ubuntu3)) #19~18.04.1-Ubuntu SMP Fri Apr 5 10:22:13 UTC 2019
m4 (GNU M4) 1.4.18
GNU Make 4.1
GNU patch 2.7.6
Perl version='5.26.1';
Python 3.6.7
sed (GNU sed) 4.4
tar (GNU tar) 1.29
texi2any (GNU texinfo) 6.5
xz (XZ Utils) 5.2.2
g++ compilation OK
```

## Creating Partition for LFS

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter02/creatingpartition.html>

```bash
fdisk /dev/sda
...
Device         Start       End   Sectors   Size Type
/dev/sda1       2048    206847    204800   100M EFI System
/dev/sda2     206848    468991    262144   128M Microsoft reserved
/dev/sda3     468992 298465279 297996288 142,1G Microsoft basic data
/dev/sda4  364001280 461658111  97656832  46,6G Linux filesystem
/dev/sda5  461658112 468860927   7202816   3,4G Linux swap
/dev/sda6  298465280 364001279  65536000  31,3G Linux filesystem <<==== LFS HERE
```

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter02/creatingfilesystem.html>

```bash
mkfs.ext4 /dev/sda6
```

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter02/aboutlfs.html>

```bash
export LFS=/mnt/lfs
```

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter02/mounting.html>

```bash
mkdir -pv $LFS
mount -v -t ext4 /dev/sda6 $LFS
```

## Chapter 3. Packages and Patches

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter03/introduction.html>

```bash
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

wget http://www.linuxfromscratch.org/lfs/view/stable/wget-list
wget --input-file=wget-list --continue --directory-prefix=$LFS/sources

pushd $LFS/sources
wget http://www.linuxfromscratch.org/lfs/view/stable/md5sums
md5sum -c md5sums # OK
popd
```

## 4. Final Preparations

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter04/creatingtoolsdir.html>

```bash
mkdir -v $LFS/tools
ln -sv $LFS/tools /
> '/tools' -> '/mnt/lfs/tools'
```

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter04/addinguser.html>

```bash
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs
```

```bash
chown -v lfs:lfs $LFS/tools
chown -v lfs:lfs $LFS/sources
```

```bash
su - lfs
```

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter04/settingenvironment.html>
- <http://www.linuxfromscratch.org/lfs/view/stable/chapter04/aboutsbus.html>

```bash
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
set +h #  turns off bash's hash function
umask 022

/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
export MAKEFLAGS='-j 5'

alias ll='ls -alF'
alias la='ls -A'

PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

__prompt_command() {
    local EXIT="$?"             # This needs to be first
    PS1=""

    local RCol='\[\e[0m\]'

    local Red='\[\e[0;31m\]'
    local Gre='\[\e[0;32m\]'
    local BYel='\[\e[1;33m\]'
    local BBlu='\[\e[1;34m\]'
    local Pur='\[\e[0;35m\]'

    PS1+="$EXIT|"
    if [ $EXIT != 0 ]; then
        PS1+="${Red}\u${RCol}"      # Add red if exit code non 0
    else
        PS1+="${Gre}\u${RCol}"
    fi

    PS1+="${RCol}@${BBlu}\h ${Pur}\W${BYel}\\$ ${RCol}"
}
EOF
```

## 5. Constructing a Temporary System

### 5.4. Binutils-2.32 - Pass 1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/binutils-pass1.html>

```bash
cd /mnt/lfs/sources/
tar xf binutils-2.32.tar.xz && cd binutils-2.32
mkdir build && cd build
```

```bash
time {
../configure --prefix=/tools            \
             --with-sysroot=$LFS        \
             --with-lib-path=/tools/lib \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror &&
make &&
mkdir -v /tools/lib && ln -sv lib /tools/lib64 &&
make install
}
```

```text
real    1m19.287s <<============= ~1 SBU
user    3m29.534s
sys     0m27.115s
```

### 5.5. GCC-8.2.0 - Pass 1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/gcc-pass1.html>

```bash
cd /mnt/lfs/sources/
tar xf gcc-8.2.0.tar.xz && cd gcc-8.2.0
tar -xf ../mpfr-4.0.2.tar.xz && mv -v mpfr-4.0.2 mpfr
tar -xf ../gmp-6.1.2.tar.xz && mv -v gmp-6.1.2 gmp
tar -xf ../mpc-1.1.0.tar.gz && mv -v mpc-1.1.0 mpc

for file in gcc/config/{linux,i386/linux{,64}}.h
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

> 'gcc/config/linux.h' -> 'gcc/config/linux.h.orig'
> 'gcc/config/i386/linux.h' -> 'gcc/config/i386/linux.h.orig'
> 'gcc/config/i386/linux64.h' -> 'gcc/config/i386/linux64.h.orig'

sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64

mkdir build && cd build

../configure                                       \
    --target=$LFS_TGT                              \
    --prefix=/tools                                \
    --with-glibc-version=2.11                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libmpx                               \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++
make
make install
```

## 5.6. Linux-4.20.12 API Headers

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/linux-headers.html>

```bash
cd $LFS/sources
tar xf linux-4.20.12.tar.xz && cd linux-4.20.12

make mrproper
make INSTALL_HDR_PATH=dest headers_install
mkdir -vp /tools/include && cp -rv dest/include/* /tools/include
```

### 5.7. Glibc-2.29

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/glibc.html>

```bash
cd $LFS/sources
tar xf glibc-2.29.tar.xz && cd glibc-2.29
mkdir -v build && cd build

../configure                             \
      --prefix=/tools                    \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=/tools/include
make
make install
```

*Note*: verification of previous steps

```bash
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools'
    [Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2
rm -v dummy.c a.out
```

### 5.8. Libstdc++ from GCC-8.2.0

```bash
cd /mnt/lfs/sources/gcc-8.2.0
mkdir build-libstdc++ && cd build-libstdc++

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/8.2.0
make
make install
```

## 5.9. Binutils-2.32 - Pass 2

```bash
cd /mnt/lfs/sources/binutils-2.32
mkdir -v build-pass2 && cd build-pass2


CC=$LFS_TGT-gcc                \
AR=$LFS_TGT-ar                 \
RANLIB=$LFS_TGT-ranlib         \
../configure                   \
    --prefix=/tools            \
    --disable-nls              \
    --disable-werror           \
    --with-lib-path=/tools/lib \
    --with-sysroot

make
make install
```

Re-adjusting

```bash
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin
```

### 5.10. GCC-8.2.0 - Pass 2

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/gcc-pass2.html>

```bash
rm -rf gcc-8.2.0 && tar xf gcc-8.2.0.tar.xz
cd /mnt/lfs/sources/gcc-8.2.0
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

for file in gcc/config/{linux,i386/linux{,64}}.h
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64

tar -xf ../mpfr-4.0.2.tar.xz && mv -v mpfr-4.0.2 mpfr
tar -xf ../gmp-6.1.2.tar.xz && mv -v gmp-6.1.2 gmp
tar -xf ../mpc-1.1.0.tar.gz && mv -v mpc-1.1.0 mpc

mkdir -v build && cd build

CC=$LFS_TGT-gcc                                    \
CXX=$LFS_TGT-g++                                   \
AR=$LFS_TGT-ar                                     \
RANLIB=$LFS_TGT-ranlib                             \
../configure                                       \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp

make
make install
ln -sv gcc /tools/bin/cc
```

*Note*: verification of previous steps

```bash
echo 'int main(){}' > dummy.c
cc dummy.c
readelf -l a.out | grep ': /tools'
      [Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]
rm -v dummy.c a.out
```

### 5.11. Tcl-8.6.9

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/tcl.html>

```bash
cd /mnt/lfs/sources
tar xf tcl8.6.9-src.tar.gz && cd tcl8.6.9

cd unix
./configure --prefix=/tools
make
# AWAIT
make install
make install-private-headers

ln -sv tclsh8.6 /tools/bin/tclsh

# Make the installed library writable so debugging symbols can be removed later:
chmod -v u+w /tools/lib/libtcl8.6.so
```

### 5.12. Expect-5.45.4

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/expect.html>

```bash
cd $LFS/sources
tar xf expect5.45.4.tar.gz && cd expect5.45.4

cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure

./configure --prefix=/tools       \
            --with-tcl=/tools/lib \
            --with-tclinclude=/tools/include

make
make SCRIPTS="" install
```

### 5.13. DejaGNU-1.6.2

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/dejagnu.html>

```bash
cd $LFS/sources
tar xf dejagnu-1.6.2.tar.gz && cd dejagnu-1.6.2

./configure --prefix=/tools
make install
make check
```

### 5.14. M4-1.4.18

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/m4.html>

```bash
cd $LFS/sources
tar xf m4-1.4.18.tar.xz && cd m4-1.4.18

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

./configure --prefix=/tools
make
make check
make install
```

### 5.15. Ncurses-6.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/ncurses.html>

```bash
cd $LFS/sources
tar xf ncurses-6.1.tar.gz && cd ncurses-6.1

sed -i s/mawk// configure
./configure --prefix=/tools \
            --with-shared   \
            --without-debug \
            --without-ada   \
            --enable-widec  \
            --enable-overwrite
make
make install
ln -s libncursesw.so /tools/lib/libncurses.so
```

### 5.16. Bash-5.0

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/bash.html>

```bash
cd $LFS/sources
tar xf bash-5.0.tar.gz && cd bash-5.0

./configure --prefix=/tools --without-bash-malloc
make
make install
ln -sv bash /tools/bin/sh
```

### 5.17. Bison-3.3.2

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/bison.html>

```bash
cd $LFS/sources
tar xf bison-3.3.2.tar.xz && cd bison-3.3.2

./configure --prefix=/tools
make
make check
make install
```

### 5.18. Bzip2-1.0.6

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/bzip2.html>

```bash
cd $LFS/sources
tar xf bzip2-1.0.6.tar.gz && cd bzip2-1.0.6

make
make PREFIX=/tools install
```

### 5.19. Coreutils-8.30

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/coreutils.html>

```bash
cd $LFS/sources
tar xf coreutils-8.30.tar.xz && cd coreutils-8.30

./configure --prefix=/tools --enable-install-program=hostname
make
make RUN_EXPENSIVE_TESTS=yes check
make install
```

### 5.20. Diffutils-3.7

- <www.linuxfromscratch.org/lfs/view/stable/chapter05/diffutils.html>

```bash
cd $LFS/sources
tar xf diffutils-3.7.tar.xz && cd diffutils-3.7

./configure --prefix=/tools
make
make check
make install
```

### 5.21. File-5.36

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/file.html>

```bash
cd $LFS/sources
tar xf file-5.36.tar.gz && cd file-5.36

./configure --prefix=/tools
make
make check
make install
```

### 5.22. Findutils-4.6.0

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/findutils.html>

```bash
cd $LFS/sources
tar xf findutils-4.6.0.tar.gz && cd findutils-4.6.0

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h

./configure --prefix=/tools
make
make check
make install
```

### 5.23. Gawk-4.2.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/gawk.html>

```bash
cd $LFS/sources
tar xf gawk-4.2.1.tar.xz && cd gawk-4.2.1

./configure --prefix=/tools
make
make check # 2 TESTS FAILED
make install
```

### 5.24. Gettext-0.19.8.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/gettext.html>

```bash
cd $LFS/sources
tar xf gettext-0.19.8.1.tar.xz && cd gettext-0.19.8.1

cd gettext-tools
EMACS="no" ./configure --prefix=/tools --disable-shared

make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext

cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin # install
```

### 5.25. Grep-3.3

- <www.linuxfromscratch.org/lfs/view/stable/chapter05/grep.html>

```bash
cd $LFS/sources
tar xf grep-3.3.tar.xz && cd grep-3.3

./configure --prefix=/tools
make
make check
make install
```

### 5.26. Gzip-1.10

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/gzip.html>

```bash
cd $LFS/sources
tar xf gzip-1.10.tar.xz && cd gzip-1.10

./configure --prefix=/tools
make
make check
make install
```

### 5.27. Make-4.2.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/make.html>

```bash
cd $LFS/sources
tar xf make-4.2.1.tar.bz2 && cd make-4.2.1

sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
./configure --prefix=/tools --without-guile
make
make check # FAILED
make install
```

### 5.28. Patch-2.7.6

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/patch.html>

```bash
cd $LFS/sources
tar xf patch-2.7.6.tar.xz && cd patch-2.7.6

./configure --prefix=/tools
make
make check
make install
```

### 5.29. Perl-5.28.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/perl.html>

```bash
cd $LFS/sources
tar xf perl-5.28.1.tar.xz && cd perl-5.28.1

sh Configure -des -Dprefix=/tools -Dlibs=-lm -Uloclibpth -Ulocincpth
make

cp -v perl cpan/podlators/scripts/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.28.1
cp -Rv lib/* /tools/lib/perl5/5.28.1
```

### 5.30. Python-3.7.2

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/Python.html>

```bash
cd $LFS/sources
tar xf Python-3.7.2.tar.xz && cd Python-3.7.2

sed -i '/def add_multiarch_paths/a \        return' setup.py
./configure --prefix=/tools --without-ensurepip
make
make install
```

### 5.31. Sed-4.7

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/sed.html>

```bash
cd $LFS/sources
tar xf sed-4.7.tar.xz && cd sed-4.7

./configure --prefix=/tools
make
make check
make install
```

### 5.32. Tar-1.31

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/tar.html>

```bash
cd $LFS/sources
tar xf tar-1.31.tar.xz && cd tar-1.31

./configure --prefix=/tools
make
make check # 1 failed unexpectedly.
make install
```

### 5.33. Texinfo-6.5

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/texinfo.html>

```bash
cd $LFS/sources
tar xf texinfo-6.5.tar.xz && cd texinfo-6.5

./configure --prefix=/tools
make
make check # FULL FAIL
make install
```

### 5.34. Xz-5.2.4

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/xz.html>

```bash
cd $LFS/sources
tar xf xz-5.2.4.tar.xz && cd xz-5.2.4

./configure --prefix=/tools
make
make check
make install
```

### 5.35. Stripping

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/stripping.html>

**OPTIONAL: SKIPPED.**

### 5.36. Changing Ownership

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter05/changingowner.html>

```bash
sudo -i
export /mnt/lfs
chown -R root:root $LFS/tools
tar -cvf tools.tar $LFS/tools
```

# III. Building the LFS System

## 6. Installing Basic System Software

### 6.2. Preparing Virtual Kernel File Systems

- <www.linuxfromscratch.org/lfs/view/stable/chapter06/kernfs.html>

```bash
mkdir -pv $LFS/{dev,proc,sys,run}
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3
mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
```

### 6.4. Entering the Chroot Environment

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/chroot.html>

```bash
chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h
```

### 6.5. Creating Directories

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/creatingdirs.html>
- <https://wiki.linuxfoundation.org/en/FHS>

```bash
mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -v  /usr/libexec
mkdir -pv /usr/{,local/}share/man/man{1..8}

case $(uname -m) in
 x86_64) mkdir -v /lib64 ;;
esac

mkdir -v /var/{log,mail,spool}
ln -sv /run /var/run
ln -sv /run/lock /var/lock
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}
```

### 6.6. Creating Essential Files and Symlinks

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/createfiles.html>

```bash
ln -sv /tools/bin/{bash,cat,chmod,dd,echo,ln,mkdir,pwd,rm,stty,touch} /bin
ln -sv /tools/bin/{env,install,perl,printf}         /usr/bin
ln -sv /tools/lib/libgcc_s.so{,.1}                  /usr/lib
ln -sv /tools/lib/libstdc++.{a,so{,.6}}             /usr/lib

install -vdm755 /usr/lib/pkgconfig

ln -sv bash /bin/sh

ln -sv /proc/self/mounts /etc/mtab
```

```bash
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
wheel:x:97:
nogroup:x:99:
users:x:999:
EOF
```

```bash
exec /tools/bin/bash --login +h
```

```bash
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp
```

### 6.7. Linux-4.20.12 API Headers

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/linux-headers.html>

```bash
cd /sources/linux-4.20.12/
make mrproper
make INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* /usr/include
```

### 6.8. Man-pages-4.16

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/man-pages.html>

```bash
cd /sources
tar xf man-pages-4.16.tar.xz && cd man-pages-4.16
make install
```

### 6.9. Glibc-2.29

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/glibc.html>

```bash
cd /sources
rm -rf glibc-2.29 && tar xf glibc-2.29.tar.xz && cd glibc-2.29

patch -Np1 -i ../glibc-2.29-fhs-1.patch
ln -sfv /tools/lib/gcc /usr/lib


case $(uname -m) in
    i?86)    GCC_INCDIR=/usr/lib/gcc/$(uname -m)-pc-linux-gnu/8.2.0/include
            ln -sfv ld-linux.so.2 /lib/ld-lsb.so.3
    ;;
    x86_64) GCC_INCDIR=/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include
            ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
    ;;
esac
#'/lib64/ld-linux-x86-64.so.2' -> '../lib/ld-linux-x86-64.so.2'
#'/lib64/ld-lsb-x86-64.so.3' -> '../lib/ld-linux-x86-64.so.2'

rm -f /usr/include/limits.h

mkdir -v build && cd build
CC="gcc -isystem $GCC_INCDIR -isystem /usr/include" \
../configure --prefix=/usr                          \
             --disable-werror                       \
             --enable-kernel=3.2                    \
             --enable-stack-protector=strong        \
             libc_cv_slibdir=/lib
unset GCC_INCDIR
make

case $(uname -m) in
  i?86)   ln -sfnv $PWD/elf/ld-linux.so.2        /lib ;;
  x86_64) ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 /lib ;;
esac
# '/lib/ld-linux-x86-64.so.2' -> '/sources/glibc-2.29/build/elf/ld-linux-x86-64.so.2'
make check
```

```text
FAIL: inet/tst-idna_name_classify (is known to fail in the LFS chroot environment)
FAIL: misc/tst-ttyname (is known to fail in the LFS chroot environment)
Summary of test results:
      2 FAIL
   5956 PASS
     24 UNSUPPORTED
     17 XFAIL
      2 XPASS
```

```bash
touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make install

cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd
```

```bash
make localedata/install-locales
```

**NOTE:** <http://www.linuxfromscratch.org/blfs/view/8.4/general/libidn2.html>

#### 6.9.2. Configuring Glibc

```bash
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
```

```bash
tar -xf ../../tzdata2018i.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO

tzselect
cp -v /usr/share/zoneinfo/Europe/Moscow /etc/localtime
```

```bash
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
# /opt/lib
# Add an include directory
# include /etc/ld.so.conf.d/*.conf
# mkdir -pv /etc/ld.so.conf.d
EOF
```

### 6.10. Adjusting the Toolchain

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/adjusting.html>

```bash
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld
```

```bash
gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs
```

*Note:* verification

```bash
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
    /usr/lib/../lib/crt1.o succeeded
    /usr/lib/../lib/crti.o succeeded
    /usr/lib/../lib/crtn.o succeeded

grep -B1 '^ /usr/include' dummy.log
    #include <...> search starts here:
        /usr/include

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
    SEARCH_DIR("=/tools/x86_64-pc-linux-gnu/lib64")
    SEARCH_DIR("/usr/lib")
    SEARCH_DIR("/lib")
    SEARCH_DIR("=/tools/x86_64-pc-linux-gnu/lib");

grep "/lib.*/libc.so.6 " dummy.log
    attempt to open /lib/libc.so.6 succeeded

grep found dummy.log
    found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2

rm -v dummy.c a.out dummy.log
```

### 6.11. Zlib-1.2.11

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/zlib.html>

```bash
cd /sources/
tar xf zlib-1.2.11.tar.xz && cd zlib-1.2.11

./configure --prefix=/usr
make
make check
make install

mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
```

### 6.12. File-5.36

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/file.html>

```bash
cd /sources && rm -rf file-5.36 && tar xf file-5.36.tar.gz && cd file-5.36
./configure --prefix=/usr
make
make check
make install
```

### 6.13. Readline-8.0

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/readline.html>

```bash
cd /sources
tar xf readline-8.0.tar.gz && cd readline-8.0

sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/readline-8.0
make SHLIB_LIBS="-L/tools/lib -lncursesw"
make SHLIB_LIBS="-L/tools/lib -lncursesw" install


mv -v /usr/lib/lib{readline,history}.so.* /lib
chmod -v u+w /lib/lib{readline,history}.so.*
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.0
```

### 6.14. M4-1.4.18

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/m4.html>

```bash
cd /sources
tar xf m4-1.4.18.tar.xz && cd m4-1.4.18

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

./configure --prefix=/usr
make
make check
make install
```

### 6.15. Bc-1.07.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/bc.html>

```bash
cd /sources
tar xf bc-1.07.1.tar.gz && cd bc-1.07.1

cat > bc/fix-libmath_h << "EOF"
#! /bin/bash
sed -e '1   s/^/{"/' \
    -e     's/$/",/' \
    -e '2,$ s/^/"/'  \
    -e   '$ d'       \
    -i libmath.h

sed -e '$ s/$/0}/' \
    -i libmath.h
EOF

ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
ln -sfv libncursesw.so.6 /usr/lib/libncurses.so

sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure

./configure --prefix=/usr           \
            --with-readline         \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info
make
echo "quit" | ./bc/bc -l Test/checklib.b
make install
```

### 6.16. Binutils-2.32

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/binutils.html>

```bash
cd /sources/binutils-2.32
mkdir -v build-lfs && cd build-lfs

../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib

make tooldir=/usr
make -k check
     (debug_msg.sh is known to fail)

make tooldir=/usr install
```

### 6.17. GMP-6.1.2

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/gmp.html>

```bash
cd /sources
tar xf gmp-6.1.2.tar.xz && cd gmp-6.1.2

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.2
make
make html
make check 2>&1 | tee gmp-check-log
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
awk '/# FAIL:/{total+=$3} ; END{print total}' gmp-check-log
awk '/# XPASS:/{total+=$3} ; END{print total}' gmp-check-log

make install
make install-html
```

### 6.18. MPFR-4.0.2

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/mpfr.html>

```bash
cd /sources
tar xf mpfr-4.0.2.tar.xz && cd mpfr-4.0.2

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.0.2
make
make html
make check
make install
make install-html
```

### 6.19. MPC-1.1.0

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/mpc.html>

```bash
cd /sources && tar xf mpc-1.1.0.tar.gz && cd mpc-1.1.0

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.1.0
make
make html
make check
make install
make install-html
```

### 6.20. Shadow-4.6

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/shadow.html>
- **NOTE:** <http://www.linuxfromscratch.org/blfs/view/8.4/postlfs/cracklib.html>

```bash
cd /sources && tar xf shadow-4.6.tar.xz && cd shadow-4.6

sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
       -e 's@/var/spool/mail@/var/mail@' etc/login.defs
sed -i 's/1000/999/' etc/useradd

./configure --sysconfdir=/etc --with-group-name-max-length=32
make
make install
mv -v /usr/bin/passwd /bin
```

Configuring Shadow

```bash
pwconv
grpconv
passwd root
```

### 6.21. GCC-8.2.0

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/gcc.html>

```bash
cd /sources && rm -rf gcc-8.2.0 && tar xf gcc-8.2.0.tar.xz && cd gcc-8.2.0
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

#
ulimit -s 32768
rm ../gcc/testsuite/g++.dg/pr83239.C
chown -Rv nobody .
su nobody -s /bin/bash -c "PATH=$PATH make -j 5 -k check"
../contrib/test_summary | grep -A7 Summ
```

```text
        === g++ Summary ===

# of expected passes        125327
# of expected failures      504
# of unsupported tests      4931
/sources/gcc-8.2.0/build/gcc/xg++  version 8.2.0 (GCC)

        === gcc tests ===
--
        === gcc Summary ===

# of expected passes        130955
# of unexpected failures    1
# of expected failures      393
# of unsupported tests      2094
/sources/gcc-8.2.0/build/gcc/xgcc  version 8.2.0 (GCC)

--
        === libatomic Summary ===

# of expected passes        54
        === libgomp tests ===


Running target unix

        === libgomp Summary ===

# of expected passes        1837
# of unsupported tests      192
        === libitm tests ===


Running target unix
--
        === libitm Summary ===

# of expected passes        42
# of expected failures        3
# of unsupported tests        1
        === libstdc++ tests ===


--
        === libstdc++ Summary ===

# of expected passes        12286
# of unexpected failures    7
# of expected failures        71
# of unsupported tests        259
```

```bash
make install
ln -sv ../usr/bin/cpp /lib
ln -sv gcc /usr/bin/cc
install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/8.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/
```

*Note:* verification

```bash
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
    /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crt1.o succeeded
    /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crti.o succeeded
    /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crtn.o succeeded
grep -B4 '^ /usr/include' dummy.log
    #include <...> search starts here:
    /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include
    /usr/local/include
    /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include-fixed
    /usr/include
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
    SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")
    SEARCH_DIR("/usr/local/lib64")
    SEARCH_DIR("/lib64")
    SEARCH_DIR("/usr/lib64")
    SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")
    SEARCH_DIR("/usr/local/lib")
    SEARCH_DIR("/lib")
    SEARCH_DIR("/usr/lib");
grep "/lib.*/libc.so.6 " dummy.log
    attempt to open /lib/libc.so.6 succeeded
grep found dummy.log
    found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2
rm -v dummy.c a.out dummy.log
```

```bash
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
```

### 6.22. Bzip2-1.0.6

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/bzip2.html>

```bash
cd /sources
rm -rf bzip2-1.0.6 && tar xf bzip2-1.0.6.tar.gz && cd bzip2-1.0.6

patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean

make
make PREFIX=/usr install

cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat
```

### 6.23. Pkg-config-0.29.2

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/pkg-config.html>

```bash
cd /sources/
tar xf pkg-config-0.29.2.tar.gz && cd pkg-config-0.29.2

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2
make
make check
make install
```

### 6.24. Ncurses-6.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/ncurses.html>

```bash
rm -rf ncurses-6.1 && tar xf ncurses-6.1.tar.gz && cd ncurses-6.1

sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec
make
make install

mv -v /usr/lib/libncursesw.so.6* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so
for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done
rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so

mkdir -v       /usr/share/doc/ncurses-6.1
cp -v -R doc/* /usr/share/doc/ncurses-6.1
```

### 6.25. Attr-2.4.48

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/attr.html>

```bash
tar xf attr-2.4.48.tar.gz && cd attr-2.4.48
./configure --prefix=/usr     \
            --bindir=/bin     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.4.48
make
make check
make install

mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
```

### 6.26. Acl-2.2.53

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/acl.html>

```bash
tar xf acl-2.2.53.tar.gz && cd acl-2.2.53

./configure --prefix=/usr         \
            --bindir=/bin         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/acl-2.2.53
make
make install

mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
```

### 6.27. Libcap-2.26

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/libcap.html>

```bash
tar xf libcap-2.26.tar.xz && cd libcap-2.26

sed -i '/install.*STALIBNAME/d' libcap/Makefile
make
make RAISE_SETFCAP=no lib=lib prefix=/usr install
chmod -v 755 /usr/lib/libcap.so.2.26

mv -v /usr/lib/libcap.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
```

### 6.28. Sed-4.7

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/sed.html>

```bash
rm -rf sed-4.7/ && tar xf sed-4.7.tar.xz && cd sed-4.7

sed -i 's/usr/tools/'                 build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in

./configure --prefix=/usr --bindir=/bin
make
make html
make check

make install
install -d -m755           /usr/share/doc/sed-4.7
install -m644 doc/sed.html /usr/share/doc/sed-4.7
```

### 6.29. Psmisc-23.2

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/psmisc.html>

```bash
tar xf psmisc-23.2.tar.xz && cd psmisc-23.2

./configure --prefix=/usr
make
make install

mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin
```

### 6.30. Iana-Etc-2.30

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/iana-etc.html>

```bash
tar xf iana-etc-2.30.tar.bz2 && cd iana-etc-2.30
make
make install
```

### 6.31. Bison-3.3.2

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/bison.html>

```bash
rm -rf bison-3.3.2 && tar xf bison-3.3.2.tar.xz && cd bison-3.3.2

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.3.2
make
make install
```

### 6.32. Flex-2.6.4

- <www.linuxfromscratch.org/lfs/view/stable/chapter06/flex.html>

```bash
tar xf flex-2.6.4.tar.gz && cd flex-2.6.4

sed -i "/math.h/a #include <malloc.h>" src/flexdef.h

HELP2MAN=/tools/bin/true \
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4

make
make check
make install

ln -sv flex /usr/bin/lex
```

### 6.33. Grep-3.3

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/grep.html>

```bash
rm -rf grep-3.3 && tar xf grep-3.3.tar.xz && cd grep-3.3

./configure --prefix=/usr --bindir=/bin
make
make -k check
make install
```

### 6.34. Bash-5.0

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/bash.html>

```bash
rm -rf bash-5.0 && tar xf bash-5.0.tar.gz && cd bash-5.0

./configure --prefix=/usr                    \
            --docdir=/usr/share/doc/bash-5.0 \
            --without-bash-malloc            \
            --with-installed-readline
make

# chown -Rv nobody .
# su nobody -s /bin/bash -c "PATH=$PATH HOME=/home make tests"
# (useless)

make install
mv -vf /usr/bin/bash /bin

exec /bin/bash --login +h
```

### 6.35. Libtool-2.4.6

- <www.linuxfromscratch.org/lfs/view/stable/chapter06/libtool.html>

```bash
tar xf libtool-2.4.6.tar.xz && cd libtool-2.4.6

./configure --prefix=/usr
make
# make -j4 check
# (Five tests are known to fail in the LFS build environment due to a circular
# dependency, but all tests pass if rechecked after automake is installed. )
make install
```

### 6.36. GDBM-1.18.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/gdbm.html>

```bash
tar xf gdbm-1.18.1.tar.gz && cd gdbm-1.18.1
./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make
make check
make install
```

### 6.37. Gperf-3.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/gperf.html>

```bash
tar xf gperf-3.1.tar.gz && cd gperf-3.1

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make
make -j1 check
make install
```

### 6.38. Expat-2.2.6

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/expat.html>

```bash
tar xf expat-2.2.6.tar.bz2 && cd expat-2.2.6

sed -i 's|usr/bin/env |bin/|' run.sh.in

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.2.6
make
make check

make install
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.6
```

## 6.39. Inetutils-1.9.4

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/inetutils.html>

```bash
tar xf inetutils-1.9.4.tar.xz && cd inetutils-1.9.4

./configure --prefix=/usr        \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
make
make check

make install
mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
mv -v /usr/bin/ifconfig /sbin
```

## 6.40. Perl-5.28.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/perl.html>

```bash
rm -rf perl-5.28.1 && tar xf perl-5.28.1.tar.xz && cd perl-5.28.1

echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh Configure -des -Dprefix=/usr                 \
                  -Dvendorprefix=/usr           \
                  -Dman1dir=/usr/share/man/man1 \
                  -Dman3dir=/usr/share/man/man3 \
                  -Dpager="/usr/bin/less -isR"  \
                  -Duseshrplib                  \
                  -Dusethreads
make
make -k test
# Failed 1 test out of 2542, 99.96% okay.
#   ../ext/GDBM_File/t/fatal.t

make install
unset BUILD_ZLIB BUILD_BZIP2
```

## 6.41. XML::Parser-2.44

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/xml-parser.html>

```bash
tar -xf XML-Parser-2.44.tar.gz && cd XML-Parser-2.44

perl Makefile.PL
make
make test
make install
```

## 6.42. Intltool-0.51.0

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/intltool.html>

```bash
tar xf intltool-0.51.0.tar.gz && cd intltool-0.51.0

sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
make
make check

make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
```

## 6.43. Autoconf-2.69

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/autoconf.html>

```bash
tar xf autoconf-2.69.tar.xz && cd autoconf-2.69

sed '361 s/{/\\{/' -i bin/autoscan.in
./configure --prefix=/usr
make
# make check

make install
```

## 6.44. Automake-1.16.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/automake.html>

```bash
tar xf automake-1.16.1.tar.xz && cd automake-1.16.1

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.1
make
make -j4 check
# (One test is known to fail in the LFS environment: subobj.sh)

make install
```

## 6.45. Xz-5.2.4

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/xz.html>

```bash
rm -rf xz-5.2.4 && tar xf xz-5.2.4.tar.xz && cd xz-5.2.4
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.2.4
make
make check

make install
mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
mv -v /usr/lib/liblzma.so.* /lib
ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
```

## 6.46. Kmod-26

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/kmod.html>

```bash
tar xf kmod-26.tar.xz && cd kmod-26

./configure --prefix=/usr          \
            --bindir=/bin          \
            --sysconfdir=/etc      \
            --with-rootlibdir=/lib \
            --with-xz              \
            --with-zlib
make

make install

for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /sbin/$target
done

ln -sfv kmod /bin/lsmod
```

## 6.47. Gettext-0.19.8.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/gettext.html>

```bash
rm -rf gettext-0.19.8.1 && tar xf gettext-0.19.8.1.tar.xz && cd gettext-0.19.8.1

sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in &&
sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in
sed -e '/AppData/{N;N;p;s/\.appdata\./.metainfo./}' \
    -i gettext-tools/its/appdata.loc

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.19.8.1
make
make check

make install
chmod -v 0755 /usr/lib/preloadable_libintl.so
```

## 6.48. Libelf from Elfutils-0.176

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/libelf.html>

```bash
tar xf elfutils-0.176.tar.bz2 && cd elfutils-0.176

./configure --prefix=/usr
make
make check

make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
```

## 6.49. Libffi-3.2.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/libffi.html>

```bash
tar xf libffi-3.2.1.tar.gz && cd libffi-3.2.1

sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
    -i include/Makefile.in

sed -e '/^includedir/ s/=.*$/=@includedir@/' \
    -e 's/^Cflags: -I${includedir}/Cflags:/' \
    -i libffi.pc.in

./configure --prefix=/usr --disable-static --with-gcc-arch=native
make
make check

make install
```

## 6.50. OpenSSL-1.1.1a

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/openssl.html>

```bash
tar xf openssl-1.1.1a.tar.gz && cd openssl-1.1.1a

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make
make -j5 test

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.1a
cp -vfr doc/* /usr/share/doc/openssl-1.1.1a
```

## 6.51. Python-3.7.2

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/Python.html>

```bash
 rm -rf Python-3.7.2 && tar xf Python-3.7.2.tar.xz && cd Python-3.7.2

./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes
make -j5

make install
chmod -v 755 /usr/lib/libpython3.7m.so
chmod -v 755 /usr/lib/libpython3.so
install -v -dm755 /usr/share/doc/python-3.7.2/html

tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.7.2/html \
    -xvf ../python-3.7.2-docs-html.tar.bz2
```

## 6.52. Ninja-1.9.0

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/ninja.html>

```bash
tar xf ninja-1.9.0.tar.gz && cd ninja-1.9.0

python3 configure.py --bootstrap
python3 configure.py
./ninja ninja_test
./ninja_test --gtest_filter=-SubprocessTest.SetWithLots

install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja
```

## 6.53. Meson-0.49.2

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/meson.html>

```bash
tar xf meson-0.49.2.tar.gz && cd meson-0.49.2

python3 setup.py build
python3 setup.py install --root=dest
cp -rv dest/* /
```

## 6.54. Coreutils-8.30

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/coreutils.html>

```bash
rm -rf coreutils-8.30 && tar xf coreutils-8.30.tar.xz && cd coreutils-8.30

patch -Np1 -i ../coreutils-8.30-i18n-1.patch
sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk

autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
# Tests skipped

make -j5 install
mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
mv -v /usr/bin/{head,nice,sleep,touch} /bin
```

## 6.55. Check-0.12.0

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/check.html>

```bash
tar xf check-0.12.0.tar.gz && cd check-0.12.0

./configure --prefix=/usr
make
# make -j 5 check # SKIPPED HANGING

make install
sed -i '1 s/tools/usr/' /usr/bin/checkmk
```

## 6.56. Diffutils-3.7

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/diffutils.html>

```bash
rm -rf diffutils-3.7 && tar xf diffutils-3.7.tar.xz && cd diffutils-3.7

./configure --prefix=/usr
make
make check

make install
```

## 6.57. Gawk-4.2.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/gawk.html>

```bash
rm -rf gawk-4.2.1 && tar xf gawk-4.2.1.tar.xz && cd gawk-4.2.1

sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make
make check

make install
mkdir -v /usr/share/doc/gawk-4.2.1
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.2.1
```

## 6.58. Findutils-4.6.0

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/findutils.html>

```bash
rm -rf findutils-4.6.0 && tar xf findutils-4.6.0.tar.gz && cd findutils-4.6.0

sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h

./configure --prefix=/usr --localstatedir=/var/lib/locate
make
make check

make install
mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
```

## 6.59. Groff-1.22.4

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/groff.html>

```bash
tar xf groff-1.22.4.tar.gz && cd groff-1.22.4

PAGE=letter ./configure --prefix=/usr
make -j1
make install
```

## 6.60. GRUB-2.02

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/grub.html>

```bash
tar xf grub-2.02.tar.xz && cd grub-2.02

./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror
make
make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
```

## 6.61. Less-530

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/less.html>

```bash
tar xf less-530.tar.gz && cd less-530

./configure --prefix=/usr --sysconfdir=/etc
make
make install
```

## 6.62. Gzip-1.10

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/gzip.html>

```bash
tar xf gzip-1.10.tar.xz && cd gzip-1.10

./configure --prefix=/usr
make
make check
# FAIL help-version (exit status: 1)

make install
mv -v /usr/bin/gzip /bin
```

## 6.63. IPRoute2-4.20.0

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/iproute2.html>

```bash
tar xf iproute2-4.20.0.tar.xz && cd iproute2-4.20.0

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

sed -i 's/.m_ipt.o//' tc/Makefile
make
make DOCDIR=/usr/share/doc/iproute2-4.20.0 install
```

## 6.64. Kbd-2.0.4

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/kbd.html>

```bash
tar xf kbd-2.0.4.tar.xz && cd kbd-2.0.4

patch -Np1 -i ../kbd-2.0.4-backspace-1.patch
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock
make
make check

make install
mkdir -v       /usr/share/doc/kbd-2.0.4
cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.4
```

## 6.65. Libpipeline-1.5.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/libpipeline.html>

```bash
tar xf libpipeline-1.5.1.tar.gz && cd libpipeline-1.5.1

./configure --prefix=/usr
make
make check

make install
```

## 6.66. Make-4.2.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/make.html>

```bash
rm -rf make-4.2.1 && tar xf make-4.2.1.tar.bz2 && cd make-4.2.1

sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
./configure --prefix=/usr
make
make PERL5LIB=$PWD/tests/ check

make install
```

## 6.67. Patch-2.7.6

- <www.linuxfromscratch.org/lfs/view/stable/chapter06/patch.html>

```bash
rm -rf patch-2.7.6/ && tar xf patch-2.7.6.tar.xz && cd patch-2.7.6

./configure --prefix=/usr
make
make check

make install
```

## 6.68. Man-DB-2.8.5

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/man-db.html>

```bash
tar xf man-db-2.8.5.tar.xz && cd man-db-2.8.5

./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.8.5 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --enable-cache-owner=bin             \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap            \
            --with-systemdtmpfilesdir=           \
            --with-systemdsystemunitdir=
make
make check

make install
```

## 6.69. Tar-1.31

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/tar.html>

```bash
rm -rf tar-1.31 && tar xf tar-1.31.tar.xz && cd tar-1.31

sed -i 's/abort.*/FALLTHROUGH;/' src/extract.c
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin
make
make check
# 1 failed unexpectedly.
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.31
```

## 6.70. Texinfo-6.5

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/texinfo.html>

```bash
rm -rf texinfo-6.5 && tar xf texinfo-6.5.tar.xz && cd texinfo-6.5

sed -i '5481,5485 s/({/(\\{/' tp/Texinfo/Parser.pm
./configure --prefix=/usr --disable-static
make
make check

make install
make TEXMF=/usr/share/texmf install-tex
```

**NOTE:**

```bash
pushd /usr/share/info
rm -v dir
for f in *
  do install-info $f dir 2>/dev/null
done
popd
```

## 6.71. Vim-8.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/vim.html>

```bash
tar xf vim-8.1.tar.bz2 && cd vim81

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
make

LANG=en_US.UTF-8 make -j1 test &> vim-test.log
# test1 FAILED - terminal size must be 80x24 or larger

make install
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim81/doc /usr/share/doc/vim-8.1
```

```bash
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
```

## 6.72. Procps-ng-3.3.15

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/procps-ng.html>

```bash
tar xf procps-ng-3.3.15.tar.xz && cd procps-ng-3.3.15

./configure --prefix=/usr                            \
            --exec-prefix=                           \
            --libdir=/usr/lib                        \
            --docdir=/usr/share/doc/procps-ng-3.3.15 \
            --disable-static                         \
            --disable-kill
make
sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
sed -i '/set tty/d' testsuite/pkill.test/pkill.exp
rm testsuite/pgrep.test/pgrep.exp
make check

make install
mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so
```

## 6.73. Util-linux-2.33.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/util-linux.html>

```bash
tar xf util-linux-2.33.1.tar.xz && cd util-linux-2.33.1

mkdir -pv /var/lib/hwclock
rm -vf /usr/include/{blkid,libmount,uuid}
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --docdir=/usr/share/doc/util-linux-2.33.1 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            --without-systemd    \
            --without-systemdsystemunitdir
make
make install
```

## 6.74. E2fsprogs-1.44.5

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/e2fsprogs.html>

```bash
tar xf e2fsprogs-1.44.5.tar.gz && cd e2fsprogs-1.44.5

mkdir -v build && cd build
../configure --prefix=/usr           \
             --bindir=/bin           \
             --with-root-prefix=""   \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck
make
make check

make install
make install-libs
chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
```

## 6.75. Sysklogd-1.5.1

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/sysklogd.html>

```bash
tar xf sysklogd-1.5.1.tar.gz && cd sysklogd-1.5.1

sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
sed -i 's/union wait/int/' syslogd.c

make
make BINDIR=/sbin install
```

```bash
cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF
```

## 6.76. Sysvinit-2.93

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/sysvinit.html>

```bash
tar xf sysvinit-2.93.tar.xz && cd sysvinit-2.93

patch -Np1 -i ../sysvinit-2.93-consolidated-1.patch
make
make install
```

## 6.77. Eudev-3.2.7

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/eudev.html>

```bash
tar xf eudev-3.2.7.tar.gz && cd eudev-3.2.7

cat > config.cache << "EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF
./configure --prefix=/usr           \
            --bindir=/sbin          \
            --sbindir=/sbin         \
            --libdir=/usr/lib       \
            --sysconfdir=/etc       \
            --libexecdir=/lib       \
            --with-rootprefix=      \
            --with-rootlibdir=/lib  \
            --enable-manpages       \
            --disable-static        \
            --config-cache
LIBRARY_PATH=/tools/lib make

mkdir -pv /lib/udev/rules.d
mkdir -pv /etc/udev/rules.d
make LD_LIBRARY_PATH=/tools/lib check

make LD_LIBRARY_PATH=/tools/lib install
tar -xvf ../udev-lfs-20171102.tar.bz2
make -f udev-lfs-20171102/Makefile.lfs install
```

```bash
LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update
```

## 6.79. Stripping Again

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/strippingagain.html>

**SKIPPED: I AM PROGRAMMER, I WANT TO DEBUG.**

## 6.80. Cleaning Up

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/revisedchroot.html>

```bash
rm -rf /tmp/*

logout

chroot "$LFS" /usr/bin/env -i          \
    HOME=/root TERM="$TERM"            \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login

rm -f /usr/lib/lib{bfd,opcodes}.a
rm -f /usr/lib/libbz2.a
rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
rm -f /usr/lib/libltdl.a
rm -f /usr/lib/libfl.a
rm -f /usr/lib/libz.a

find /usr/lib /usr/libexec -name \*.la -delete
```

# 7. System Configuration

## 7.2. LFS-Bootscripts-20180820

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter07/bootscripts.html>

```bash
cd /sources
tar xf lfs-bootscripts-20180820.tar.bz2 && cd lfs-bootscripts-20180820
make install
```

## 7.6. System V Bootscript Usage and Configuration

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter07/usage.html>

```text
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
```

```text
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
```

## 7.8. Creating the /etc/inputrc File

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter07/inputrc.html>

```text
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
```

## 7.9. Creating the /etc/shells File

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter07/etcshells.html>

```text
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
```

# 8. Making the LFS System Bootable

## 8.2. Creating the /etc/fstab File

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter08/fstab.html>

```text
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

/dev/sda6     /            ext4    defaults            1     1
/dev/sda5     swap         swap     pri=1               0     0
proc           /proc        proc     nosuid,noexec,nodev 0     0
sysfs          /sys         sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts     devpts   gid=5,mode=620      0     0
tmpfs          /run         tmpfs    defaults            0     0
devtmpfs       /dev         devtmpfs mode=0755,nosuid    0     0

# End /etc/fstab

```

## 8.3. Linux-4.20.12

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter08/kernel.html>

```bash
cd /sources/linux-4.20.12
make mrproper
make defconfig
```

```text
Device Drivers  --->
  Generic Driver Options  --->
   [ ] Support for uevent helper [CONFIG_UEVENT_HELPER]                     [OK]
   [*] Maintain a devtmpfs filesystem to mount at /dev [CONFIG_DEVTMPFS]    [OK]

Kernel hacking  --->
       Choose kernel unwinder (Frame pointer unwinder)
                                      ---> [CONFIG_UNWINDER_FRAME_POINTER]  [OK]

Processor type and features  --->
   [*]   EFI stub support  [CONFIG_EFI_STUB]   [OK]
```

```bash
make -j5
#
make modules_install

cp -iv arch/x86_64/boot/bzImage /boot/vmlinuz-4.20.12-lfs-8.4
cp -iv System.map /boot/System.map-4.20.12
cp -iv .config /boot/config-4.20.12

install -d /usr/share/doc/linux-4.20.12
cp -r Documentation/* /usr/share/doc/linux-4.20.12
```

```text
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
```

## 8.4. Using GRUB to Set Up the Boot Process

- <http://www.linuxfromscratch.org/lfs/view/stable/chapter08/grub.html>

### Prepare rescue

```bash
cd /tmp
grub-mkrescue --output=grub-img.iso
sudo dd if=grub-img.iso of=/dev/sdb

```

```bash
export LFS=/mnt/lfs
mkdir -pv $LFS
mount -v -t ext4 /dev/sda6 $LFS
mkdir -pv $LFS/{dev,proc,sys,run}
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3
mount -v --bind /dev $LFS/dev
mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

chroot "$LFS" /usr/bin/env -i \
            HOME=/root TERM="$TERM" \
            PS1='(lfs chroot) \u:\w\$ ' \
            PATH=/bin:/usr/bin:/sbin:/usr/sbin \
            /bin/bash --login
```