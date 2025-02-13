# day01 配置环境
由于deepseek太方便，所以……直接问deepseek就实现了，懒得看书了

---
以下是一个简单的 `nasm` 汇编程序，它可以在裸机 386 环境下运行并输出 "Hello, World!"。这个程序假设你是在实模式下运行，并且直接操作显存来输出文本。

```nasm
org 0x7C00  ; BIOS 将引导扇区加载到 0x7C00 处

start:
    ; 设置段寄存器
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; 设置显存地址 (0xB8000 是文本模式显存的起始地址)
    mov ax, 0xB800
    mov es, ax

    ; 输出 "Hello, World!"
    mov si, message
    mov di, 0  ; 显存偏移量 (从屏幕左上角开始)

print_char:
    lodsb       ; 从 SI 指向的内存加载一个字节到 AL，并增加 SI
    cmp al, 0   ; 检查是否到达字符串末尾
    je halt     ; 如果是，跳转到 halt
    stosw       ; 将 AX 中的内容写入 ES:DI，并增加 DI
    jmp print_char

halt:
    hlt         ; 停止 CPU
    jmp halt    ; 无限循环

message db 'Hello, World!', 0

times 510-($-$$) db 0  ; 填充剩余空间，使引导扇区大小为 512 字节
dw 0xAA55              ; 引导扇区结束标志
```

### 说明：
1. **org 0x7C00**: BIOS 会将引导扇区加载到内存地址 `0x7C00` 处，因此我们需要告诉汇编器从该地址开始。
2. **显存地址**: 在实模式下，文本模式的显存起始地址是 `0xB8000`。我们通过 `es` 寄存器来访问显存。
3. **print_char**: 这个循环从 `message` 字符串中逐个读取字符，并将其写入显存。每个字符占用两个字节：一个字节是字符本身，另一个字节是属性（颜色等）。
4. **halt**: 程序在输出完字符串后进入无限循环。
5. **times 510-($-$$) db 0**: 填充剩余的空间，使引导扇区的大小为 512 字节。
6. **dw 0xAA55**: 引导扇区的结束标志，BIOS 通过这个标志识别引导扇区。

### 编译和运行：
1. 使用 `nasm` 编译这个程序：
   ```bash
   nasm -f bin -o boot.bin boot.asm
   ```
2. 将生成的 `boot.bin` 写入软盘镜像或虚拟机的虚拟磁盘：
   ```bash
   dd if=boot.bin of=disk.img bs=512 count=1
   ```
3. 使用虚拟机（如 QEMU）运行这个镜像：
   ```bash
   qemu-system-i386 -fda disk.img
   ```

### 注意：
- 这个程序假设你是在实模式下运行，并且直接操作显存来输出文本。
- 如果你是在保护模式下运行，或者使用更复杂的操作系统环境，代码会有所不同。

希望这个示例对你有帮助！如果你有其他问题，欢迎继续提问。