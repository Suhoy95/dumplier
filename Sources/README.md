# Dumplier - Sources

Current state of dumplier sources

## Directory map

- [**dumplier/**](./dumplier) - tiny kernel based on
[OS-dev Bare-Bones](../Sketches/bare-bones/README.md) tutorial.
- [**bios_memimage/**](./bios_memimage) - the source from Cold-Book authors
retrieved from [GitHub mirror](https://github.com/DonnchaC/coldboot-attacks)

## Task

**Main problem:** the sources from author is not work correct in current condition.

**Task:** to understand them it should be written from scratch, or until
we cannot understand how to fix original source code.

*Note:* plan is highly top-level and should be detailed more thoroughly.

- [ ] Create own simple boot-loader
- [ ] Read and print CPU capabilities
- [ ] Read and print amount of physical RAM memory
- [ ] Set up Paging

## Build

1. Build `i686-elf` [**cross-compiler**](../Sketches/cross-compiler.md).
2. Fix the [**dumplier/Makefile**](./dumplier/Makefile) if it is required.
3. Create a bootable image (`scraper.iso`):

```bash
make
```

4. Run in QEMU virtual machine:

```bash
make run-qemu
```

## Useful links

- <https://wiki.osdev.org/User:TheCool1Kevin/VSCode_Debug> - set up VSCode
- <https://wiki.osdev.org/Setting_Up_Paging> - set UP paging
- <https://wiki.osdev.org/Setting_Up_Paging_With_PAE> - set up PAE
