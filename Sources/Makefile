.PHONY: run-qemu usb \
	dumplier/dumplier.bin \
	memtest86+-scraper/memtest.bin

SHELL=/bin/bash

all: scraper.iso

scraper.iso: grub.cfg dumplier/dumplier.bin
	mkdir -p isodir/boot/grub

	cp dumplier/dumplier.bin isodir/boot/
	cp grub.cfg isodir/boot/grub/

	grub-mkrescue --output $@ isodir

dumplier/dumplier.bin:
	$(MAKE) -C dumplier/

run-qemu: scraper.iso
	qemu-system-x86_64 -usb -usbdevice disk:format=raw:scraper.iso

usb: scraper.iso
	read -p "dd if=scraper.iso of=/dev/sdb; Sure?"
	sudo dd if=scraper.iso of=/dev/sdb
	sync && sync && sync # Синк за маму, синк за папу, синк за записанный бинарь

clean:
	rm -rf scraper.iso isodir