---
title: MBR vs GPT Partition Tables
draft: true
date: 2023-06-22
---

Master Boot Record (MBR) is the old traditional method of partitioning a harddrive, invented by IBM for DOS 2.0 back in 1983. GUID Partition Table (GPT) is the modern way of doing things introduced by Intel about 2017, just after running with EFI for a few years.

## Master Boot Record (MBR)

MBR has serious limitions including:
1. Can only support 4 primary partition
2. Partition are limited to 2TB
3. To over come the limited number of partitions you have to create an _extended partition_ and create _logical partitions_ within the extended partition.
4. MBR has a single record, if it gets trashed you must restore it or the data on your disk is worthless.
5. MBR has no way to know if the data on your disk is trashed.

## GUID Partition Table (GPT)

1. GPT limits are constrained by the Operating System and Filesystems the GPT partitions contain.
2. GPT is associated with UEFI replaces old BIOS with ing the MBR
3. GPT stores multiple copies of the boot record across the disk making it more robust and easier to recover from.  It also includes CRC checks to make sure the data contained within is clean and not corrupted.
4. GPT provides a protective MBR that acts like there is a single partition covering the entire drive. This helps keep old tools from thinking the drive is available and mistakenly over writing good partitions.
5. GPT requires computers (more modern) to have UEFI, where as old computers running BIOS will require MBR partitioning.

## References

* [UEFI](https://www.happyassassin.net/posts/2014/01/25/uefi-boot-how-does-that-actually-work-then/)
