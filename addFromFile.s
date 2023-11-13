.equ RW_RW___, 0660
.equ AT_FDCWD, -100
.equ MAX_BYTES, 512 // Max string size


    .data
tempStr: .space MAX_BYTES   // Reserve space for MAX_BYTES bytes
szFile: .asciz "input.txt"  
iFD: .word 0
ptrString: .quad 0
.global addFromFile
.text
addFromFile:
    mov x22, x0
    mov x23, x1
    mov x24, x2
    mov x0, #AT_FDCWD
    mov x8, #56
    ldr x1, =szFile
    mov x2, #0
    svc #0

    ldr x1, =iFD
    strb w0, [x1]

    ldr x8, =tempStr
    str LR, [SP, #-16]!
am_file_read_loop:
    ldr x0, =iFD
    ldrb w0, [x0]
    mov x8, #63   // syscall number for read
    ldr x1, =tempStr
    mov x2, #MAX_BYTES  // Read up to MAX_BYTES bytes
    svc #0

    cmp w0, #0   // Check if end of file reached (0 bytes read)
    beq am_file_read_done

    ldr x0, =tempStr
    bl putstring
    //bl am_malloc_and_copy
    //bl am_add_node_to_list
    b am_file_read_done

am_file_read_done:
    ldr LR, [SP], #16
    ret

am_malloc_and_copy:
    mov x21, x0        // Store the original string address
    str LR, [SP, #-16]!
    bl String_length
    mov x20, x0        // Store the length of the string
    bl malloc
    // Store the address in ptrString
    ldr x1, =ptrString
    str x0, [x1]
    mov x2, x21        // Restore the original string address
    bl am_copy_string

    mov x0, #16  // 16 bytes for the newNode
    bl malloc
    // Store the address in newNode
    mov x1, x24
    str x0, [x1]

    // Load the address of the newNode into x0
    ldr x0, [x1]

    // Load the address of the previously malloc'd string into x1
    ldr x1, =ptrString
    ldr x1, [x1]
    // Set the newNode's data element to the address of the string
    str x1, [x0]

    // Set the newNode's next element to null (0)
    str xzr, [x0, #8]

    ldr LR, [SP], #16
    ret
am_add_node_to_list:
    // Load the address of the new node into x0
    mov x0, x24
    ldr x0, [x0]

    // If the list is empty, set both head and tail to the new node
    mov x1, x22
    ldr x1, [x1]
    cbz x1, am_list_empty
    // If the list is not empty, find the current tail node
    mov x2, x23
    ldr x2, [x2]
    ldr x3, [x2, #8]  // Load the next node (should be null)
    cbz x3, am_list_not_empty  // If the next node is null, the current node is the tail
    // If it's not null, keep traversing the list to find the tail
am_traverse_list:
    ldr x2, [x2, #8]  // Move to the next node
    ldr x3, [x2, #8]  // Check if the next node is null
    cbnz x3, am_traverse_list
am_list_not_empty:
    // Update the next pointer of the current tail node to the new node
    str x0, [x2, #8]
    b am_end_add_node
am_list_empty:
    // If the list is empty, both head and tail should point to the new node
    mov x1, x22
    str x0, [x1]
    mov x1, x23
    str x0, [x1]  // Update tailPtr to point to the new node
am_end_add_node:
    ret

am_copy_string:
    // Load a character from the source into x3
    ldrb w3, [x2]
    add x2, x2, #1
    // Check if the character is null (end of the string)
    cbz w3, am_end_copy // If it's null, exit the loop
    strb w3, [x0]
    add x0, x0, #1
    // Repeat the loop
    b am_copy_string

am_end_copy:
    ret


.end
