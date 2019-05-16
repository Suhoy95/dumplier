.PHONY: run-qemu usb \
	dumplier/dumplier.bin \
	memtest86+-scraper/memtest.bin

SHELL=/bin/bash

all: scraper.iso

scraper.iso: grub.cfg dumplier/dumplier.bin memtest86+-scraper/memtest.bin
	mkdir -p isodir/boot/grub
	cp dumplier/dumplier.bin isodir/boot/dumplier.bin
	cp memtest86+-scraper/memtest.bin isodir/boot/memtest.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o $@ isodir

dumplier/dumplier.bin:
	$(MAKE) -C dumplier/

memtest86+-scraper/memtest.bin:
	$(MAKE) -C memtest86+-scraper/

run-qemu: scraper.iso
	qemu-system-i386 -cdrom scraper.iso

usb: scraper.iso
	read -p "dd if=scraper.iso of=/dev/sdb; Sure?"
	sudo dd if=scraper.iso of=/dev/sdb
	sync && sync && sync