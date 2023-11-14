.equ W, 0101
.equ RW_RW___, 0660
.equ AT_FDCWD, -100
.equ MAX_BYTES, 512 // Max string size

    .data
tempStr: .space MAX_BYTES   // Reserve space for MAX_BYTES bytes
szFile: .asciz "output.txt"  
szFileSaved: .asciz "File has been saved\n"
iFD: .word 0

	.global saveToFile
    .text
saveToFile:


    mov x21,x0
    mov x0, #AT_FDCWD
    mov x8, #56
//    ldr x1, =szFile
	mov x1,x3
	mov x2, #W
    mov x3, #RW_RW___
    svc 0


    ldr x1, =iFD
    strb w0, [x1]

    add x21,x21,#8
    ldr x22, [x21] // Load the address of the first node
    str LR, [SP, #-16]!

am_traverse_loop:
    mov x21,x22
    cbz x22, am_end_write // If it's null, exit the loop
    cbz x21, am_end_write // If it's null, exit the loop

am_write_loop:
    ldr x0, [x22]
    cbz x0, am_end_write
    bl String_length
    mov x12,x0
    ldr x0, =iFD
    ldrb w0, [x0]
    mov x8, #64   // syscall number for write
    ldr x1, [x22]
    mov x2, x12  // Read up to MAX_BYTES bytes
    svc #0
    add x21,x21,#8
    ldr x22,[x21]

    b am_traverse_loop

am_end_write:
    ldr x0, =szFileSaved
    bl putstring
    ldr x0, =iFD
    ldrb w0, [x0]
    mov x8, #57
    svc 0
    ldr LR, [SP], #16
    ret

