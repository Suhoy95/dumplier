export MAKEFLAGS='-j 5'

set -e
set -x

bash ./build-scripts/05-mkdirs.sh 2>&1                    | tee 05-mkdirs.log
bash ./build-scripts/06-essential-files.sh 2>&1           | tee 06-essential-files.log
bash ./build-scripts/07-Linux-4.20.12-api-headers.sh 2>&1 | tee 07-Linux-4.20.12-api-headers.log
bash ./build-scripts/08-man-pages-4.16.sh 2>&1            | tee 08-man-pages-4.16.log
bash ./build-scripts/09-glibc-2.29.sh 2>&1                | tee 09-glibc-2.29.log
bash ./build-scripts/10-adj-toolchain.sh 2>&1             | tee 10-adj-toolchain.log
bash ./build-scripts/11-zlib-1.2.11.sh 2>&1               | tee 11-zlib-1.2.11.log
bash ./build-scripts/12-file-5.36.sh 2>&1                 | tee 12-file-5.36.log
bash ./build-scripts/13-readline-8.0.sh 2>&1              | tee 13-readline-8.0.log
bash ./build-scripts/14-m4-1.4.18.sh 2>&1                 | tee 14-m4-1.4.18.log
bash ./build-scripts/15-bc-1.07.1.sh 2>&1                 | tee 15-bc-1.07.1.log
bash ./build-scripts/16-binutils-2.32.sh 2>&1             | tee 16-binutils-2.32.log
bash ./build-scripts/17-gmp-6.1.2.sh 2>&1                 | tee 17-gmp-6.1.2.log
bash ./build-scripts/18-mprf-4.0.2.sh 2>&1                | tee 18-mprf-4.0.2.log
bash ./build-scripts/19-mpc-1.1.0.sh 2>&1                 | tee 19-mpc-1.1.0.log
bash ./build-scripts/20-shadow-4.6.sh 2>&1                | tee 20-shadow-4.6.log
bash ./build-scripts/21-gcc-8.2.0.sh 2>&1                 | tee 21-gcc-8.2.0.log
