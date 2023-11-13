.equ RW_RW___, 0660
.equ AT_FDCWD, -100
.equ MAX_BYTES, 512 // Max string size

.global _start

_start:

    mov x0, #AT_FDCWD
    mov x8, #56
    ldr x1, =szFile
    mov x2, #0
    svc #0

    ldr x1, =iFD
    strb w0, [x1]

    ldr x8, =tempStr
    ldr x16, =intArr
read_loop:
    ldr x0, =iFD
    ldrb w0, [x0]
    mov x8, #63   // syscall number for read
    ldr x1, =tempStr
    mov x2, #MAX_BYTES  // Read up to MAX_BYTES bytes
    svc #0

    cmp w0, #0   // Check if end of file reached (0 bytes read)
    beq done

    ldr x0, =tempStr   // x0 contains the address of the read string
    bl putstring
    ldr x0, =tempStr   // x0 contains the address of the read string
    bl ascint64
    str x0, [x16]
    add x16,x16,#1
    b read_loop

done:
    b _exit

_exit:
    mov x8, #93   // syscall number for exit
    mov x0, #0    // exit status
    svc #0

.data
tempStr: .space MAX_BYTES   // Reserve space for MAX_BYTES bytes
szFile: .asciz "input.txt"  
iFD: .word 0
intArr: .quad 0
