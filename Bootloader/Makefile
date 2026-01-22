ASM = nasm
ASMFLAGS = -f bin

all: boot.img

stage0.bin: stage0.asm
	$(ASM) $(ASMFLAGS) stage0.asm -o stage0.bin

stage1.bin: stage1.asm
	$(ASM) $(ASMFLAGS) stage1.asm -o stage1.bin

boot.img: stage0.bin stage1.bin
	dd if=/dev/zero of=boot.img bs=512 count=2880
	dd if=stage0.bin of=boot.img bs=512 count=1 conv=notrunc
	dd if=stage1.bin of=boot.img bs=512 seek=1 conv=notrunc

run: boot.img
	qemu-system-x86_64 \
		-drive file=boot.img,format=raw \
		-monitor stdio
clean:
	rm -f *.bin boot.img