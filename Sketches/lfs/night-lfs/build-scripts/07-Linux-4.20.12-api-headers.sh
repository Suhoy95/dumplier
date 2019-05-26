# 6.7. Linux-4.20.12 API Headers
# http://www.linuxfromscratch.org/lfs/view/stable/chapter06/linux-headers.html

set -e
set -x

cd /sources/
tar xf linux-4.20.12.tar.xz && cd linux-4.20.12/

make mrproper
make INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* /usr/include
