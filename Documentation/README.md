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
\color{red} TODO: continue timeline if there is something interesting between
2010 and 2019\color{black}

Now in 2019, We, as pre-graduated masters with some work experience, may say
that this moment is still not considered during software development, or
at least not even mentioned. Because of this and the urge to repeat Halderman's
experiments, we have started this work. Initially defined as two research
projects "Trying Cold-boot attack" and "USB and DMA Threats", the work is
becoming more fundamental in the RAM data acquisition aspects during our
theoretical research.

## Subject

As it is defined in the title, we are globally considering the
\textit{Extraction Of Running Machine State}. To be more precise,
we concentrates on \textit{extraction of RAM state}, but we are not
limiting ourself to theoretically consider the extraction running state
from another extension cards, such as Video and Audio accelerators
or BIOS settings state. This broad view allows lay the foundation for deep
and professional data acquisition in forensics science.

The research on this topic is too wide, and requires from us as researchers
deep understanding in art of operating systems, computer architectures
and even hardware architectures. The studying all of them and validation
of researched methods can not be fitted even in this two research works,
so we tries to concentrate on the most interesting to us topics,
but also tries to provide good overview in this field, and describe
the starting points for tasks which will skip, because of our limitation.

## Goal and Targets

**Global goal:** Make a theoretical overview of DRAM data acquisition methods.
Try and validate the current tools and methods as well as it is possible.

*Note:* We are trying to describe targets in their complexity order, to solve
tasks gradually and sequentially.

**Common targets:**

- Get insights about art of writing operating systems\footnote{<https://wiki.osdev.org/Main\_Page>}
- Understand and practically face with `x86` architecture as most wide-spread
and technologies related with address spaces

### Cyber-Crime and Forensics Research Project

**Goal:** Perform and validate Cold-Boot and Hot-Boot attack to extract
DRAM state.

**Targets:**

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

**Optional targets:**

- Try to perform this attack to find traces of Cookies from Modern Web Browsers,
such as Google Chrome and Mozilla Firefox
- Try to perform this attack on the Full Disk Encryption (FDE) system, such as
BitLocker and TrueCrypt
- Try to perform this attack on the ssh clients to retrieve the private keys
from locked computer
- Try to build Coreboot\footnote{<https://www.coreboot.org/>},
flash it into motherboard and consider it as pure-hardware data acquisition solution

## Novelty

Citing the Witherden [[2, 20010]](https://freddie.witherden.org/pages/ieee-1394-forensics.pdf),
this work is more evolutionary than revolutionary. We are trying to validate
and actualize the described methods and their implementation. But we brings
several new ideas to the field, while we have not found the similar ideas in
another works.

First, Halderman mentioned the using of well-known predictable motherboard
to mitigate the BIOS intervention during acquisition, but it sounds
hypothetically. In optional part we would like to try build the Open Source BIOS
solution -- Coreboot -- in perspective a method of creation such predictable
motherboard. Moreover, this method hypothetically leads to creation of special
hardware for RAM data acquisition, which does not required any mini kernel solution
as it was described by Halderman.

Second, we are continuing the classification and characterization work started
by Witherden. The described properties look kind of comprehend and unclear,
we are trying to express this thoughts more clear and expand it with our
point of view.

## Ethical consideration

According to \textit{Hacker Ethics} [3], this work is fully satisfying its
spirit. The attention is paid to bowels of contemporary popular computer systems
to find out the real principle of its structure. This is used to analyze and
optimize it if it is required. By \textit{Hands-On Imperative}, we are trying
to get the working prototypes of described system and find out how they work at
current moment of time. By this way, the collected information gives methods
to create more secure critical IT solution. Probably, at this point
there appears the new technical border-line which separate really critical
and vital infrastructure, such as government, medicine, police, etc.., and
entertainment busyness solutions, which does not require so serious security
worries.

Nevertheless, we have to admit that computer systems have become widely spread
in our live, especially in the non-hackers lives. So, before exploiting this
knowledge, the person should take into account the Security, Law and Political
Considerations described below.

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
create a new production ready technical solutions, but only
validation of existing implementation and clarification this science field.
Thus, this aspect is only facilitate our tasks.

## Law Consideration

In perfect scenario, if such tools appear in current environment,
then it should be certified and controlled by responsible special service.
Observing the current physical security in the organizations, the unlimited
exploiting of this techniques may lead to attack on wealthy businesses,
particularly banking systems, and in terrorist hands
it may become a weapon against government infrastructure, such as police,
medicine, and other bureaucracy organization.

## Road map

First, we observe and recalled the described ideas and methods, which may be
found in the **Previous Works**. Next, we are trying to categorize and clarify
theoretical model of data extraction and its aspects by creating
**Theoretical Map**. After definition of theoretical ideas, we observes it
in the context of existing hardware and applying the knowledge to produce
**Technical Map** combined with previous defined theoretical frame.
The finalizing current understanding of RAM data acquisition allow to recall
and propose new **Mitigation or Anti-Acquisition Methods**.

When all theoretical and basis-practical overview are described, we can come
to the consideration of attack and extraction methods. We split them into
two logical parts: **Software**, which requires from actor only special programs
and abilities, and **Hardware**, which also requires special hardware and/or
hacks required to perform with the regular hardware. According to time, budget
and local market limitation we can not perform some attacks. In that situation
we just tend to keep short description and requirements to provide entry point
for future works and researches.

The current progress of work can be found in the **Appendix A and B**, which
corresponds to OT and CCF project.

# Previous Works

# Theoretical Map

## Extraction Scope

## Acquisition Requirements

## Machine State Consistency

## Host System Interference

## Anti-Acquisition Methods Complexity

# Technical Map

## Hardware

## Custom BIOS and Coreboot

## Basic: x86 and Contemporary PC Architecture

# Mitigation or Anti-Acquisition Methods

# Software acquisition

## Encryption Keys Acquisition

## Attack on Full Disk Encryption Systems

# Hardware acquisition

## Cold-Boot Attack Extraction

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
