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
in the engineering projects is not so correct. He published paper and
described methods how to dump DRAM without any special hardware, and provided
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
Perform and validate Cold-Boot and Hot-Boot attack to extract DRAM state.

**Common targets:**

- Get insights about art of writing operating systems\footnote{<https://wiki.osdev.org/Main\_Page>}
- Understand and practically face with `x86` architecture as most wide-spread
and technologies related with address spaces
- Test and explore the Halderman's tools set\footnote{<http://citp.princeton.edu/memory>},
particularly `findkey` tool for extraction of DES/AES/RSA keys from RAM image
- Implement a tiny kernel to feel bitmap picture into RAM
- Implement a tiny kernel to image DRAM and save it to USB storage device
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
new idea to the field, while we have not found the similar ideas in another works.

Halderman mentioned the using of well-known predictable motherboard
to mitigate the BIOS intervention during acquisition, but it sounds
hypothetically. In optional part we would like to try build the Open Source BIOS
solution -- Coreboot -- in perspective a method of creation such predictable
motherboard. Moreover, this method hypothetically leads to creation of special
hardware for RAM data acquisition, which does not required any mini kernel solution
as it was described by Halderman.

## Security Consideration

Mostly, the subject covers a big blind spot in the physical security.
As soon as the optimal tools and programs appear, the security methods of
Full Disk Encryption technologies and approach of programming the secure
or cryptography application may become more questionable in their possibility
of providing confidentiality.

On another hand, the particle results can increase the performance
of forensics specialist in the live acquisition situation, which should bread
new wave of obfuscation and anti-acquisition technics.

## Political Consideration

The internal russian political situation is considered as unstable.
The reputations of some malicious users and person from special service are
approximately equaled if we take general situation. So, we do not tends to
create a new production ready technical solutions, but only validation of
existing implementation and clarification this science field. Thus, this aspect
is only facilitate our tasks.

## Law Consideration

In perfect scenario, if such tools appear in current environment,
then it should be certified and controlled by responsible special service.
Observing the current physical security in the organizations, the unlimited
exploiting of this techniques may lead to attack on wealthy businesses,
particularly banking systems, and in terrorist hands it may become a weapon
against government infrastructure, such as police, medicine, and other
bureaucracy organizations.

## Road map



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
