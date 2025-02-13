nasm -f bin -o boot.bin boot.asm
dd if=boot.bin of=hello.img bs=512 count=1
qemu-system-i386 -fda hello.img