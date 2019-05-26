# Preface

\begin{flushleft}
\textbf{Q:} \textit{Know what the difference between your latest project and
putting wings on an elephant is?}\linebreak
\textbf{A:} \textit{Who knows? The elephant *might* fly, heh, heh...}\linebreak
\end{flushleft}
\begin{flushright}
\textit{\textbf{Author unknown, future's quotes}}
\end{flushright}

This paper is work-in-progress draft of two research projects: \textit{Offensive
Technology (OT)} and \textit{Cyber Crime And Forensics (CCF)} subjects from
Security and Network Engineering (SNE) master program in the Innopolis University
[[os3.su]](http://os3.su/).

The first one, CCF, appears thanks for inspiration from Halderman work
[[1, 2008]](https://www.usenix.org/legacy/event/sec08/tech/full_papers/halderman/halderman.pdf)
and its uncovering the conception that RAM is not so volatility as it has been
supposed to be by plenty of regular engineers and security researchers, which still
makes questions about current critical security methods and also gives a way
to more quality data acquisition in forensic science point of view.

The second, OT, called "USB & DMA Threats" was chosen tightly coupled with
the first topic to deeply concentrate on data acquisition. Indeed, the Witherden
work [[2, 20010]](https://freddie.witherden.org/pages/ieee-1394-forensics.pdf)
dedicated RAM acquisition via FireWire Interface mostly shows not a IEEE 1379/FireWire
flaws, but the wide theoretical and practical consideration about data extraction
from running machine.

The current draft is dedicated to manage logs of both researches, during which
we are targeting not only on performing the defined topics, but consider these
method of data acquisitions more structured, and also validation of implemented
methods at current time.

We hope that this work become good theoretical and practical basis for
understanding deeper data acquisition and/or creating new high-level forensics
products and busyness.

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

### Offensive Technology Research Project

**Goal:** Implement any attack with using USB and/or DMA technologies.
Particularly, try to apply it to RAM imaging task.

**Targets:**

- Explore possibility of using DMA and USB features in RAM imaging perspective
- Implement and Perform ANY hardware attack relating with USB and/or DMA:
    - BadUSB\footnote{<https://ru.wikipedia.org/wiki/BadUSB>}
    - Attack with PCILeech\footnote{<https://github.com/ufrisk/pcileech>}
    - Use Arduino boards as BadUSB
    - Physically combine USB-flash and keyboard controllers ot obtain BadUSB
    - Implement utility to image RAM memory via Hot-Boot attack
    - Try to repeat experiment with IEEE 1379, and consider it as RAM imaging solution

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

## IEEE 1379 or FireWire Extraction

## DMA Attacks

- <https://github.com/ufrisk/pcileech> -- main repository about the attack.
- <https://github.com/ufrisk/pcileech-fpga>
-- the same attack, but for FGPA hardware.
- <https://www.synacktiv.com/posts/pentest/practical-dma-attack-on-windows-10.html>
-- attack description with PCILeech
- <https://mirror.us.oneandone.net/projects/media.ccc.de/congress/2017/slides-pdf/34c3-9111-public_fpga_based_dma_attacking.pdf>
-- slides how it should look like
- <https://www.blackhat.com/docs/us-17/wednesday/us-17-Trikalinou-Taking-DMA-Attacks-To-The-Next-Level-How-To-Do-Arbitrary-Memory-Reads-Writes-In-A-Live-And-Unmodified-System-Using-A-Rogue-Memory-Controller.pdf>
-- DMA with technical details about RAM structure
- <https://n0where.net/direct-memory-access-attack-pcileech>
-- Author's article (?)
- <http://blog.frizk.net/2016/10/dma-attacking-over-usb-c-and.html>
-- attack on Thunderbolt3 (the same author)
- <https://www.digikey.com/en/product-highlight/f/ftdi/ft60x-series-usb>
-- details about FT601 and boards based on that
- <http://www.bplus.com.tw/PLX.html> -- supposedly board manufacturer with USB3380
- <https://security.stackexchange.com/questions/118854/attacks-via-physical-access-to-usb-dma>
-- attack vectors
- <https://en.m.wikipedia.org/wiki/DMA_attack> -- about DMA

## USB Attacks

## USB & DMA Extraction

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

<!-- 3. USB -- Undermining Security Barriers, Andy Davis, `references/BH_US_11-Davis_USB_WP.pdf`
4. Salave, P. (2017). Memory Forensics : Tools Comparison.
-- <https://pdfs.semanticscholar.org/791c/c8805bc1e02192a96e211b7daf6e8cf2799e.pdf>
-- `references/memory-forensics-tools-comparison.pdf`
5.
<https://www.semanticscholar.org/paper/Memory-forensics%3A-The-path-forward-Case-Richard/b358feb9c8f2704aa742ff69ab04d04766468146>
3. TODO: add more, request for help -->

# Appendix A. OT Research Project

## Team members

- Ilya Sukhoplyuev, <i.sukhoplyuev@innopolis.university>, master of SNE,
Innopolis University
- Andrey Serebryakov, <an.serebryakov@innopolis.ru>, master of SNE,
Innopolis University

## Goal and Targets

**Goal:** Implement any attack with using USB and/or DMA technologies.
Particularly, try to apply it to RAM imaging task.

**Common targets with CCF RP:**

- Get insights about art of writing operating systems\footnote{<https://wiki.osdev.org/Main\_Page>}
- Understand and practically face with `x86` architecture as most wide-spread
and technologies related with address spaces

**Targets:**

- Explore possibility of using DMA and USB features in RAM imaging perspective
- Implement and Perform ANY hardware attack relating with USB and/or DMA:
    - BadUSB\footnote{<https://ru.wikipedia.org/wiki/BadUSB>}
    - Attack with PCILeech\footnote{<https://github.com/ufrisk/pcileech>}
    - Use Arduino boards as BadUSB
    - Physically combine USB-flash and keyboard controllers ot obtain BadUSB
    - Implement utility to image RAM memory via Hot-Boot attack
    - Try to repeat experiment with IEEE 1379, and consider it as RAM imaging solution

## Team Collaboration & Members Contribution

According to the current situation, Ilya Sukhoplyuev are mostly performing
the theoretical and academical research in the field and writing the report
draft and/or logging the obtained knowledge.

Andrey Serebryakov are working on researching the practical resource and methods
to perform attacks with USB or DMA.

## Time Schedule

| Week № | Time deadlines / Date | Action                            |
|--------|------------------|----------------------------------------|
| 1 | 29 April - 5 May 2019 | Theoretical investigations             |
| 1 | 29 April - 5 May 2019 | Writing logs                           |
| 2 | 6 - 12 May 2019       | Resource investigations                |
| 2 | 6 - 12 May 2019       | Performing the existing attacks        |
| 3 | 13 - 19 May 2019      | Implementation of self-defined attacks |
| 4 | 20 - 26 May           | Presentation preparation               |
| 4 | 20 - 26 May           | Reviewing and finalizing the report    |

\color{red}\textbf{Deadlines}\color{black}:

- 18 May 2019 -- Minimal working attack samples, without report -- soft deadline
- 25 May 2019 -- OT Research Project presentation
- 26 May 2019 -- OT Research Project report deadline -- hard deadline

**Notes:**

- The 18-19 May will be dedicated to urban hackaton\footnote{<https://vk.com/urbathon2019>},
 the minimal research version should be done by this date
- The tasks of 1-2 weeks may be performing till report finalization depending
on situation

\clearpage

## Resource Requirements

The project requires the hardware, our budget is approximately estimated
with **10 000 rubles**.

Currently we are searching for next hardware:

- The research shows that USB 3.1 has DMA addition potentially the similar
flaw as IEEE 1379. We have found that boards with *USB3380* и *FT601* chips are required.
But we can not find them in the market to retrieve them in acceptable time span.
For examples:
    - *USB3380-EVB mini-PCIe card* (USB3380)
    - *Xilinx SP605 + UMFT601X-B* (FT601)
- For BadUSB implementation, we found guide\footnote{<https://null-byte.wonderhowto.com/how-to/make-your-own-bad-usb-0165419/>}
in which \textit{8 GB Toshiba TransMemory-MX USB 3.0} is used.
It has the *Phison 2303 (2251-03)* USB controller, we have not found it yet,
but the searching are being going
- *UMFT601X-B*
- We found that our own Arduino board may be used as programmable USB device.
We are exploring this possibility
- According to advice from Victor Osmov, the easiest way to make simple BadUSB is
to combine keyboard controller with USB controller and additionally patch them.
If current approach does not work, we will try this way also

# Appendix B. CCF Research Project

## Team members

## Goals & Targets

## Team collaboration & members contribution

## Time Schedule

## Resource requirements

# Appendix C. Report writing snippets

```markdown
[[1, 2008]](https://www.usenix.org/legacy/event/sec08/tech/full_papers/halderman/halderman.pdf)

[[2, 20010]](https://freddie.witherden.org/pages/ieee-1394-forensics.pdf)
```