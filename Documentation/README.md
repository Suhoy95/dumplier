# Preface

**Q:** *Know what the difference between your latest project and
putting wings on an elephant is?*\
**A:** *Who knows? The elephant \*might\* fly, heh, heh...*\
*Author unknown, future's quotes*

This is a report for CCF research project. The research was dedicated to
practical reproducing the results of
[Lest We Remember (2008)](https://citp.princeton.edu/research/memory/) work.
The interest was to create own live RAM content acquisition method.
Though by the time of writing the report there is no final practical
results, we hope this work will become a good theoretical guideline to concentrate
on particular solutions.

\tableofcontents

# Introduction

In 2008, Alex Halderman showed that wide-spread assumption about RAM volatility
in the engineering projects is not so correct. He published a paper and
described methods of how to dump DRAM without any special hardware, and provided
further examples of exploiting this phenomenon in security perspectives. In 2010,
following Halderman's steps, Freddie Witherden described passive and active
attacks on RAM of running machine via IEEE 1379 (a.k.a. FireWire) and analyzed
pros and cons of different methods in RAM data acquisition.

Now in 2019, We, as pre-graduated masters with some work experience, may say
that this security moment is still not considered during software development.
Because of this and the urge to repeat Halderman's experiments, we have started
this work.

## Subject

Although the main subject of this work was the reproducing Cold-Boot attack
and \textit{extraction of RAM state}, it is worth to theoretically consider
this topic wider as \textit{Extraction Of Running Machine State}. This task
rename define more wide and precise understanding in goals of
professional data acquisition procedure in forensic science.

## Goal and Targets

**Goal:** Make a theoretical overview of DRAM data acquisition methods.
Perform and validate Cold-Boot and Hot-Boot attack to extract the DRAM state.

**Common targets:**

- Get insights about the art of writing operating systems\footnote{<https://wiki.osdev.org/Main\_Page>}
- Understand and practically face with `x86` architecture as most wide-spread
and technologies related to address spaces
- Test and explore the Halderman's tools set\footnote{<http://citp.princeton.edu/memory>},
particularly `findkey` tool for extraction of DES/AES/RSA keys from RAM image
- Implement a tiny kernel to feel bitmap picture into RAM
- Implement a tiny kernel to image DRAM and save it to the USB storage device
and/or network storage
- Try to experiment and observe RAM data degradation after power-off the PC
- Try to perform Hot-Boot attack to retrieve the state of running
regular operating system
- Try to perform Cold-Boot attack with 'canned-air' to transits the RAM boards
to the attacker hardware and take its image

## Novelty

Citing the Witherden [[2, 2010]](https://freddie.witherden.org/pages/ieee-1394-forensics.pdf),
this work is more evolutionary than revolutionary. We are trying to validate
and actualize the described methods and their implementation. But we have
a new idea for the field, while we have not found similar ideas in other works.

Halderman mentioned the using of the well-known predictable motherboard
to mitigate the BIOS intervention during acquisition, but it sounds
hypothetical. In optional part, we would like to try to build the Open Source BIOS
solution -- Coreboot -- in perspective a method of creating such predictable
motherboard. Moreover, this method hypothetically leads to the creation of special
hardware for RAM data acquisition, which does not require any mini kernel solution
as it was described by Halderman.

## Security Consideration

Mostly, the subject covers a big blind spot in physical security.
As soon as the optimal tools and programs appear, the security methods of
Full Disk Encryption technologies and approach of programming the secure
or cryptography application may become more questionable in their possibility
of providing confidentiality.

On another hand, the particle results can increase the performance
of forensics specialist in the live acquisition situation, which should bread
a new wave of obfuscation and anti-acquisition technics.

## Political Consideration

The internal Russian political situation is considered as unstable.
The reputations of some malicious users and person from special service are
approximately equaled if we take the general situation. So, we do not tend to
create a new production-ready technical solution, but only validation of
existing implementation and clarification of this scientific field. Thus, this aspect
is only to facilitate our tasks.

## Law Consideration

In the perfect scenario, if such tools appear in the current environment,
then it should be certified and controlled by responsible special service.
Observing the current physical security in the organizations, the unlimited
exploiting of these techniques may lead to  attacks on wealthy businesses,
particularly banking systems, and in terrorist hands, it may become a weapon
against government infrastructures, such as police, medicine, and other
bureaucracy organizations.

# Experiments

## Breaking BitLocker in VirtualBox

- Download image of Windows 10 from: <https://developer.microsoft.com/en-us/windows/downloads/virtual-machines>
- Shrink Disk Space, and Increase performance (RAM, CPU) of VM
- Allow Policy to run BitLocker without TPM: <https://www.howtogeek.com/howto/6229/how-to-use-bitlocker-on-drives-without-tpm/>
- Enable BitLocker encryption
- Reboot and wait for finishing BitLocker progress (PowerShell or GUI):

```powershell
watch(1) {manage-bde -status c:; sleep 2} # admin right required
```

- Ensure that BitLocker uses AES
- Dump the RAM:

```bash
VBoxManage debugvm "WinDev1903Eval" dumpvmcore --filename dump.ram
```

- find the AES key:

```bash
scripts/coldboot-attacks/bin/aeskeyfind dump.ram
4ffa2b21ca45676f321739cef00db137
bd91534fca3e27b74969b8c7dc856805
```

- Boot from `Ubuntu Mate Live ISO`
- First, try to mount BitLocker drive with known password: <https://www.ceos3c.com/open-source/open-bitlocker-drive-linux/>

```bash
sudo apt-get update
sudo apt-get install dislocker
sudo mkdir /media/bitlocker /media/mount
sudo fdisk -l # Target: /dev/sda2
sudo dislocker -r -V /dev/sda2 -uYourPassword -- /media/bitlocker
sudo mount -t ntfs -o ro /media/bitlocker/dislocker-file /media/mount
# ...
sudo umount /media/mount && sudo umount /media/bitlocker
```

- Mount the Encrypted Disk with AES keys (Reboot for clearness):

```bash
sudo apt-get update
sudo apt-get install libbde-utils
sudo fdisk -l # Target: /dev/sda2
sudo bdemount -k 4ffa2b21ca45676f321739cef00db137:bd91534fca3e27b74969b8c7dc856805\
/dev/sda2 /mnt
sudo mount -t ntfs -o ro /mnt/bde1 /media
# ...
sudo umount /media/mount && sudo umount /media/bitlocker
```

![`aeskeyfind` works!](./images/2019-05-14-12:18:35-mount-with-aes-keys.png)

## Further VM experiments

## Dumping Memory from Hardware

# Building Memory Scrapper

## Hardware-based solutions

## BIOS-based solutions

### u-boot

### coreboot

## OS-based solutions

### Mini-kernel

### Patching GRUB

### Custom Linux Kernel

# Summary

# References

1. Halderman, J. A., Schoen, S. D., Heninger, N., Clarkson, W., Paul, W.,
Calandrino, J. A., Feldman, A. J., Appelbaum, J. & Felten, E. W. (2008).
Lest We Remember: Cold Boot Attacks on Encryption Keys..
In P. C. van Oorschot (ed.), USENIX Security Symposium (p./pp. 45-60),
: USENIX Association. ISBN: 978-1-931971-60-7
 -- <https://www.usenix.org/legacy/event/sec08/tech/full_papers/halderman/halderman.pdf>
 -- `references/halderman.pdf`
2. Witherden, F.D. (2010). Memory Forensics over the IEEE 1394 Interface.
-- <https://freddie.witherden.org/pages/ieee-1394-forensics.pdf>
-- `references/ieee-1394-forensics.pdf`
3. Steven Levy. 1984. Hackers: Heroes of the Computer Revolution.
Doubleday, New York, NY, USA.

<!--
3. USB -- Undermining Security Barriers, Andy Davis, `references/BH_US_11-Davis_USB_WP.pdf`
4. Salave, P. (2017). Memory Forensics : Tools Comparison.
-- <https://pdfs.semanticscholar.org/791c/c8805bc1e02192a96e211b7daf6e8cf2799e.pdf>
-- `references/memory-forensics-tools-comparison.pdf`
5.
<https://www.semanticscholar.org/paper/Memory-forensics%3A-The-path-forward-Case-Richard/b358feb9c8f2704aa742ff69ab04d04766468146>
3. TODO: add more, request for help
-->
