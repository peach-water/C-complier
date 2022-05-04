ASM = nasm
objects = build


obuild: $(objects).asm lbuild
	@$(ASM) -f elf32 -o $(objects).o $(objects).asm

lbuild: $(objects).o
	@ld -m elf_i386 -o $(objects).bin $(objects).o


clean:
	@-rm ./*.o ./*.bin
clear:
	@-rm ./*.o ./*.bin