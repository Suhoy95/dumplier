# Dumplier

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

1. Preliminary reading -- WIP
2. <https://wiki.osdev.org/Bare_Bones>
3. x86/Paging/DMA Reading
4. <https://wiki.osdev.org/Rolling_Your_Own_Bootloader>

**Soft deadline:** 17 May 2019

**Hard deadline:** 23 May 2019

## Bare Bones

1. <https://wiki.osdev.org/Bare_Bones>

### Cross-Compiler

1. <https://wiki.osdev.org/Target_Triplet>
2. <https://wiki.osdev.org/Why_do_I_need_a_Cross_Compiler%3F>
3. <https://wiki.osdev.org/GCC_Cross-Compiler> (or <https://wiki.osdev.org/Building_GCC>)

## Self Boot Loader

1. <https://wiki.osdev.org/Boot_Sequence>
2. <https://wiki.osdev.org/Rolling_Your_Own_Bootloader>

## Appendix A. Code CheatSheet

1. `gcc -dumpmachine` -- show target triplet
2. `-ffreestanding`, `-mno-red-zone (x86_64 only)`, `-fno-exceptions, -fno-rtti (C++)` -- GCC compiler flags
