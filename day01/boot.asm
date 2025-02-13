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

message db 'Hello, World!!!!!', 0

times 510-($-$$) db 0  ; 填充剩余空间，使引导扇区大小为 512 字节
dw 0xAA55              ; 引导扇区结束标志