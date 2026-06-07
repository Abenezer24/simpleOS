# &#x09;			roadmap



\-The boot loader has two primary stages in it 16 bit real mode



1, write the stage 1 bootloader which must be exactly 512 bytes

&#x09;- load the bootloader in the memory address "0X7C00", set the data segments and the 	stack pointer just under the 0X7C00 memory address.

2,load stage 2 of the bootloader from disk using interrupts

&#x09;- since 512 bytes is not enough we need to load more sectors from the disk and end 	with boot signature 



&#x09;times 510 - ($ - $$) db 0   ; pad with zeros up to byte 510

&#x09;dw 0xAA55                    ; boot signature (little-endian)

3, switch from the real mode to protected mode 

&#x09;- disable interrupts, set the PE bit in CR0 and generate a data structure to tell the 	CPU about the memory segments ( their base, address size and permissions). must define at least a null descriptor, a code and data segment descriptor.

4, do a far jump to REload the CS register and flush the CPU pipeline 

5, set up protected mode env and optional(switch to long mode) 

6, load and jump to the kernel



# &#x09;CPU MODES

1, 16 real mode

2, 32 protected mode

3, 64 long mode

