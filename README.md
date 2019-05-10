# Dumplier

## RTFM

- <https://gcc.gnu.org/install/index.html>
- <https://www.gnu.org/software/grub/manual/multiboot/multiboot.html>

## OSDev Link Map

1. <https://wiki.osdev.org/>
2. <https://forum.osdev.org/>
3. <https://wiki.osdev.org/Books>
4. <https://wiki.osdev.org/Tutorials>
5. <https://wiki.osdev.org/Projects>
6. <https://wiki.osdev.org/Category:Executable_Formats>
7. <https://wiki.osdev.org/Category:OS_theory>
8. Hints:
   1. <https://wiki.osdev.org/Code_Management>
   2. <https://wiki.osdev.org/Testing>
   3. Tools:
      1. <https://wiki.osdev.org/GCC>
      2. <https://wiki.osdev.org/GAS>
      3. <https://wiki.osdev.org/NASM>
      4. <https://wiki.osdev.org/LD>
      5. <https://wiki.osdev.org/Visual_Studio>
      6. <https://wiki.osdev.org/GRUB>

## Preliminary Reading

1. <https://wiki.osdev.org/Main_Page> -- Entry Point
2. <https://wiki.osdev.org/Introduction> -- Community, OS, kernel, shell, GUI(desktop environment, Window Manager, widget library), reasons
3. <https://wiki.osdev.org/Required_Knowledge> -- Good hints and references
4. <https://wiki.osdev.org/Beginner_Mistakes> -- To avoid early problems
5. <https://wiki.osdev.org/Getting_Started>

## Basic Reading / Extraction Memory Reading

1. <https://wiki.osdev.org/PCI>
2. <https://wiki.osdev.org/Paging>

## Design

**Plan:** Tiny bootloader-like OS for dumping the RAM state and/or another information from machine

**TODO:**

> It may help if you write out an overview of your planned OS design, with any specific requirements or details you feel are notable or which could clarify what you need help with, and add it to your public repository if you can.

## Schedule

**TODO:** Add details during the reading

1. Preliminary reading -- *[DONE?]*
2. <https://wiki.osdev.org/Bare_Bones> -- *[Work-In-Progress]*
3. x86/Paging/DMA Reading
4. <https://wiki.osdev.org/Rolling_Your_Own_Bootloader>

**Soft deadline:** 17 May 2019

**Hard deadline:** 23 May 2019

## Bare Bones

1. <https://wiki.osdev.org/Bare_Bones>

### Cross-Compiler

1. <https://wiki.osdev.org/Target_Triplet>
2. <https://wiki.osdev.org/Why_do_I_need_a_Cross_Compiler%3F> -- problem description for future, if any is
3. <https://wiki.osdev.org/Building_GCC> -- Bootstrap target GCC
    - <http://gcc.gnu.org/install/> -- the latest GNU GCC instruction
4. <https://wiki.osdev.org/GCC_Cross-Compiler> -- Build Cross-Compiler GCC

#### Bootstrap Target GCC

- <http://gcc.gnu.org/install/>
- <https://wiki.osdev.org/Building_GCC>
- <https://wiki.osdev.org/Cross-Compiler_Successful_Builds>
- <https://en.wikipedia.org/wiki/This_Is_the_House_That_Jack_Built>

*This is the **system GCC** from system repository*

*This is the buggy **first GCC***
*Which is built by the **system GCC** from system repository*

*This is the **second GCC***
*Which is built by the buggy **first GCC***
*Which is built by the **system GCC** from system repository*

*This is the **target GCC***
*[Which should be equal to And]*
*Which is built by the not-so-buggy **second GCC***
*Which is built by the buggy **first GCC***
*Which is built by the **system GCC** from system repository*

*This is the **Cross-Compiler GCC***
*Which is built by the **target GCC***
*[Which should be equal to And]*
*Which is built by the not-so-buggy **second GCC***
*Which is built by the buggy **first GCC***
*Which is built by the **system GCC** from system repository*

#### Dependencies

- <https://gcc.gnu.org/install/prerequisites.html>
- <https://wiki.osdev.org/Building_GCC#Preparing_for_the_build>

```bash
$ uname -a
Linux quark 4.18.0-18-generic #19~18.04.1-Ubuntu SMP Fri Apr 5 10:22:13 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

- ISO C++98 compiler: `gcc --version` -> `gcc (Ubuntu 7.4.0-1ubuntu1~18.04) 7.4.0`
- C standard library and headers: `build-essential 12.4ubuntu1`
- A “working” POSIX compatible shell, or GNU bash: `/bin/bash --version` -> `GNU bash, version 4.4.19(1)-release (x86_64-pc-linux-gnu)`
- A POSIX or SVR4 awk: `awk --version` -> `GNU Awk 4.1.4, API: 1.1 (GNU MPFR 4.0.1, GNU MP 6.1.2)`
- GNU binutils
- gzip version 1.2.4 (or later): `gzip --version` -> `gzip 1.6`
- GNU make version 3.80 (or later): `make --version` -> `Built for x86_64-pc-linux-gnu`
- GNU tar version 1.14 (or later): `tar --version` -> `tar (GNU tar) 1.29`
- **[WARNING]** Perl version between 5.6.1 and 5.6.24: `perl --version` -> `perl 5, version 26, subversion 1 (v5.26.1) built for x86_64-linux-gnu-thread-multi`
- GNU Multiple Precision Library (GMP) version 4.3.2 (or later): `libgmp3-dev (2:6.1.2+dfsg-2)`
- MPFR Library version 2.4.2 (or later): `libmpfr-dev:amd64 (4.0.1-1)`
- MPC Library version 0.8.1 (or later): `libmpc-dev:amd64 (1.1.0-1)`
- isl Library version 0.15 or later: `libisl-dev:amd64 (0.19-1)`

**[WARNING]** There is skipped deps in the GNU manual:

- bison
- flex
- Texinfo
- ClooG

**Snippets:**

```bash
sudo apt-get install build-essential \
                     libgmp3-dev \
                     libmpfr-dev \
                     libmpc-dev \
                     libisl-dev
```

#### Get Sources

- <https://gcc.gnu.org/install/download.html>
  - -> <https://gcc.gnu.org/releases.html>
  - -> <https://gcc.gnu.org/gcc-8/>
  - -> <https://gcc.gnu.org/mirrors.html>
  - -> <http://mirror.linux-ia64.org/gnu/gcc/>
- <https://www.gnu.org/software/binutils/>
  - -> <https://www.gnu.org/software/binutils/>

**Snippets:**

```bash
wget http://mirror.linux-ia64.org/gnu/gcc/releases/gcc-8.3.0/gcc-8.3.0.tar.gz{,.sig} \
     http://mirror.linux-ia64.org/gnu/gcc/releases/gcc-8.3.0/sha512.sum
wget https://mirror.tochlab.net/pub/gnu/binutils/binutils-2.32.tar.gz{,.sig}
```

```bash
gpg --recv-keys \
    B215C1633BCA0477615F1B35A5B3A004745C015A \
    B3C42148A44E6983B3E4CC0793FA9B1AB75C61B8 \
    90AA470469D3965A87A5DCB494D03953902C9419 \
    80F98B2E0DAB6C8281BDF541A7C8C3B2F71EDF1C \
    7F74F97C103468EE5D750B583AB00996FC26A641 \
    33C235A34C46AA3FFB293709A328C3A2C3C45C06 \
    13FCEF89DD9E3C4F
```

```bash
sha512sum -c gcc-8.3.0-sha512.sum
gpg --verify gcc-8.3.0.tar.gz.sig
gpg --verify binutils-2.32.tar.gz.sig
```

```bash
tar xf binutils-2.32.tar.gz
tar xf gcc-8.3.0.tar.gz
```

#### Build Binutils And GCC

- <https://wiki.osdev.org/Building_GCC>

Variables:

```bash
export CONFIG_SHELL=/bin/bash
export PREFIX="$HOME/bin/gcc-8.3.0-first"
```

*Note:* I thought I have to do GCC bootstrapping, but it is done automatically.
You can use `--disable-bootstrap` in GCC configure to do it.

Binutils:

```bash
mkdir -p $PREFIX
mkdir -p build-binutils && cd build-binutils
../binutils-2.32/configure --prefix="$PREFIX" --disable-nls
make -j5
make install
```

GCC itself:

```bash
mkdir -p build-gcc && cd build-gcc
../gcc-8.3.0/configure --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --disable-multilib
make -j5
make install
```

Usage (add to `~./bashrc`):

```bash
PATH="$HOME/bin/gcc-8.3.0-first/bin:$PATH"
```

Testing:

```bash
sudo apt-get install dejagnu expect tcl
make -k check
```

#### Built Cross-Compiler GCC

- <https://wiki.osdev.org/GCC_Cross-Compiler>

**Target Triplet:** `i686-suhoy-elf`

Variables:

```bash
export CONFIG_SHELL=/bin/bash
export TARGET=i686-elf
export PREFIX="$HOME/bin/gcc-8.3.0-$TARGET"

# ensure that we use the last compiled compiler
export PATH="$HOME/bin/gcc-8.3.0-first/bin:$PATH"
```

Binutils:

```bash
mkdir -p $PREFIX
mkdir -p "build-binutils-$TARGET" && cd "build-binutils-$TARGET"
../binutils-2.32/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --program-prefix="${TARGET}-"
make -j5
make install
```

GCC itself:

```bash
# switch to built cross binutils
export PATH="$PREFIX/bin:$PATH"
which -- ${TARGET}-as || echo ${TARGET}-as is not in the PATH
mkdir -p "build-gcc-$TARGET" && cd "build-gcc-$TARGET"
../gcc-8.3.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --program-prefix="${TARGET}-"
make -j5 all-gcc && make -j5 all-target-libgcc
make install-gcc
make install-target-libgcc
```

Usage (add to `~./bashrc`):

```bash
export PATH="$HOME/bin/gcc-8.3.0-i686-elf/bin:$PATH"
```

Testing:

```bash
make -k check-gcc check-c check-c++
```

## Self Boot Loader

1. <https://wiki.osdev.org/Boot_Sequence>
2. <https://wiki.osdev.org/Rolling_Your_Own_Bootloader>

## Appendix A. GCC Flags CheatSheet

1. `gcc -dumpmachine` -- show target triplet
2. `-ffreestanding`, `-mno-red-zone (x86_64 only)`, `-fno-exceptions, -fno-rtti (C++)` -- GCC compiler flags

## Appendix B. Machine Grammar Notes

### Target Triplet

- <https://wiki.osdev.org/Target_Triplet>

```text
machine-vendor-operatingsystem
```

**Related command:** `gcc -dumpmachine`
