.PHONY: run-qemu

all: scraper.iso

scraper.iso: dumplier/dumplier.bin grub.cfg
	mkdir -p isodir/boot/grub
	cp dumplier/dumplier.bin isodir/boot/dumplier.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o $@ isodir

dumplier/dumplier.bin: $(wildcard dumplier/*.{c,ld,s})
	echo $^
	$(MAKE) -C dumplier/

run-qemu: scraper.iso
	qemu-system-i386 -cdrom scraper.iso
