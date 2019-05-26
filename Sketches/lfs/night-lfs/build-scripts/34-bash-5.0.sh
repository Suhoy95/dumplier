# 6.34. Bash-5.0

# - <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/bash.html>

cd /sources
tar xf bash-5.0.tar.gz && cd bash-5.0

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
cd /sources
rm -rf bash-5.0