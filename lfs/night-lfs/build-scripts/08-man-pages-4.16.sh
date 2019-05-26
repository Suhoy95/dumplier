# 6.8. Man-pages-4.16
# <http://www.linuxfromscratch.org/lfs/view/stable/chapter06/man-pages.html>

set -e
set -x

cd /sources
tar xf man-pages-4.16.tar.xz && cd man-pages-4.16
make install

cd /sources && rm -rf man-pages-4.16
