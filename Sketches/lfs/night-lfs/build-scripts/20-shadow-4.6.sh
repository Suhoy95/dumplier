# 6.20. Shadow-4.6

# <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/shadow.html>
# **NOTE:** <http://www.linuxfromscratch.org/blfs/view/8.4/postlfs/cracklib.html>

set -e
set -x

cd /sources
tar xf shadow-4.6.tar.xz && cd shadow-4.6

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

cd /sources
rm -rf shadow-4.6

# Configuring Shadow
# ```bash
# pwconv
# grpconv
# passwd root
# ```
