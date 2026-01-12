ASM = nasm
ASMFLAGS = -f bin

all: boot.bin

boot.bin: boot.asm
	$(ASM) $(ASMFLAGS) boot.asm -o boot.bin

run: boot.bin
	qemu-system-x86_64 \
		-drive format=raw, file=boot.bin \
		-nographic

clean:
	rm -f boot.bin