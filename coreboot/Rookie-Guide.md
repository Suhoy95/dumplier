# Rookie Guide - Coreboot

- <https://doc.coreboot.org/lessons/lesson1.html>

## Preparation - Sources & Cross-Compiler

```bash
sudo apt-get install -y bison build-essential curl flex git gnat libncurses5-dev m4 zlib1g-dev
git clone https://review.coreboot.org/coreboot && cd coreboot
make crossgcc-i386 CPUS=$(nproc)
```

## Pyload

```bash
make -C payloads/coreinfo olddefconfig
make -C payloads/coreinfo
```

## Configuration

```bash
$ make menuconfig
   select 'Mainboard' menu
   Beside 'Mainboard vendor' should be '(Emulation)'
   Beside 'Mainboard model' should be 'QEMU x86 i440fx/piix4'

   select 'Payload' menu
   select 'Add a Payload'
   choose 'An Elf executable payload'
   select 'Payload path and filename'
   enter 'payloads/coreinfo/build/coreinfo.elf'
```

Check

```bash
make savedefconfig
cat defconfig
# should be
> CONFIG_PAYLOAD_ELF=y
> CONFIG_PAYLOAD_FILE="payloads/coreinfo/build/coreinfo.elf"
```

Build

```bash
make
> ...
> Build emulation/qemu-i440fx (QEMU x86 i440fx/piix4)
```

## Test

```bash
sudo apt-get install -y qemu
qemu-system-x86_64 -bios build/coreboot.rom -serial stdio
```