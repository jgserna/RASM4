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
	
	mov x27,x3	//file name
	mov x25,x5 // consumption
	mov x26,x6 //nodes

    mov x22, x0
    mov x23, x1
    mov x24, x2
    mov x0, #AT_FDCWD
    mov x8, #56			//OPENAT
//  ldr x1, =szFile
	mov x1,x27
    mov x2, #0
    mov x3, #RW_RW___
    svc #0

    ldr x1, =iFD
    strb w0, [x1]

	
//readFromFile
	
    str LR, [SP, #-16]!
jg_readLoop:
	//x0 = iFD
    ldr	x0,=iFD		//load the file descriptor
	ldrb	w0,[x0]		//x0 = iFD
	ldr	x1,=tempStr
    
	bl	jg_getline
    
	//getline returns ---- in x0
    cmp	x0,#0		//compare x0 to 0
	beq	jg_closeFile		//while keep getting data
    ldr x0, =tempStr
    bl am_malloc_and_copy
    ldr x0, =ptrString
    ldr x0, [x0]
    bl am_add_node_to_list

    b jg_readLoop

	ldr	x0,=iFD		//load the file descriptor
	ldrb	w0,[x0]		//x0 = iFD

jg_closeFile:
	//x0 needs to be file handle
	ldr	x0,=iFD
	ldrb	w0,[x0]
	
	mov	x8, #57			//CLOSE file
	svc	0
	LDR	LR,[SP],#16	//POP LR
    ret


//returns x0 with number of bytes that was read. once 0 is returned, end of file.

jg_getchar:
	STR	LR,[SP,#-16]!		//PUSH LR
	
	//x0 contains iFD
	//x1 contains tempStr
	mov	x2,#1	//x2 holds how many bytes to read
	mov	x8,#63		//READ
	svc	0		//service call
	
	mov x5,x25
	ldr x5,[x5]
	add x5,x5,#1
	str x5,[x25]		//incrmentbyte each char is read
	
	LDR	LR,[SP],#16	//POP LR
	ret
	

// X0 contains iFD
// X1 contains tempStr

jg_getline:
	STR	LR,[SP,#-16]!		//PUSH LR
	
jg_top:
	// X0 contains iFD
	// X1 contains tempStr
    
	bl	jg_getchar
		//x1 = tempStr
	ldrb	w2,[x1]		//load a byte from x1 (tempStr)
	cmp	w2,#0xa		//is w2 LF(0xa)?
	beq	jg_endOfLine	//jump to end of line if equal

	cmp	w0,#0x0		//if w0 = 0
	beq	jg_closeFile	//jump to endOfFile if equal
	//if neither null or 0 are found, a valid char was read

	add	x1,x1,#1	//increment ptrBuff by 1
	ldr	x0,=iFD		//reload file descriptor
	ldrb	w0,[x0]
	b	jg_top		//loop until endOfFile is found

jg_endOfLine:
	add	x1,x1,#1	//increment the file tempStr by one
	mov	w2,#0		//Make tempStr into a c-string by storing a null at the end
	strb	w2,[x1]		//(i.e. "text\0")
	b	jg_exitGetline

jg_endOfFile:
	b jg_exitGetline

jg_exitGetline:

	LDR	LR,[SP],#16	//POP LR

	ret



am_malloc_and_copy:
    mov x21, x0        // Store the original string address
    str LR, [SP, #-16]!
    bl String_length
    mov x20, x0        // Store the length of the string
    add x0,x0,#1
    bl malloc
	
	
    // Store the address in ptrString
    ldr x1, =ptrString
    str x0, [x1]
    mov x2, x21        // Restore the original string address
    bl am_copy_string

    mov x0, #16  // 16 bytes for the newNode
    bl malloc
	
	mov x5,x25
	ldr x5,[x5]
	add x5,x5,#16
	str x5,[x25]		//increment byte count by 16 after malloc for a node
	
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

	mov x6,x26
	ldr x6,[x6]
	add x6,x6,#1
	str x6,[x26]	//increment node count by 1
	
    ret

am_copy_string:
    // Load a character from the source into x3
    ldrb w3, [x2]
    add x2, x2, #1
    // Check if the character is null (end of the string)
    cbz w3, am_end_copy // If it's null, exit the loop
    // Store the character in the allocated memory
    strb w3, [x0]
    add x0, x0, #1
    // Repeat the loop
    b am_copy_string

am_end_copy:
    ret

endAddFromFile:
	ret

	.end
