//editString.s 

//
//x0 has headPtr 	saved in x20
//x1 has tailPtr 	saved in x21
//x2 has newNode 	saved in x22
//x3 has index 		saved in x23
//x4 has cons 		saved in x24 
//
//

	.data
ptrTemp: .skip 512
editPrompt: .asciz "Enter string edit: "
ptrString: .quad 0
	.global editString

	.text
editString:

	str LR, [SP, #-16]!
	
	mov	x20,x0
	mov	x21,x1 
	mov	x22,x2 
	mov	x23,x3
	mov	x24,x4
	
	ldr x17,[x23]		//x17 = n
	
	mov x26, x20	
	add x26,x26,#8
	ldr x27,[x26] 	// Load the address of the first node
	mov x15,#1		//x15 = count = 1
editTraverseLoop: 
    mov x26,x27
    cbz x27, endEdit// If it's null, exit the loop
    cbz x26, endEdit // If it's null, exit the loop

	cmp x15,x17
	bne editContinue
	//x2 has node to be deleted
    ldr x0, =editPrompt
    bl putstring
    ldr	x0,=ptrTemp
	mov	x1,#512
	bl	getstring

	ldr x0,[x26]
	cbz x0, endEdit
	bl String_length
	bl editSubtractBytes
	

	ldr x0,=ptrTemp
    bl malloc_and_edit
	
	b endEdit
    
editContinue: 
	add x15,x15,#1
	add x26,x26,#8
	ldr x27, [x26]
	b editTraverseLoop

endEdit:
	ldr LR, [SP], #16
	ret

	
editSubtractBytes:
	mov x4,x24
	ldr x4,[x4]
	sub x4,x4,x0
	str x4,[x24]
	
	ret
	

malloc_and_edit:
    mov x19, x0        // Store the original string address
    str LR, [SP, #-16]!
    bl String_length
    mov x29, x0        // Store the length of the string
	
	add x0,x0,#1
	mov x4,x24
	ldr x4,[x4]
	add x4,x4,x0
	str x4,[x24]
	
	mov x0,x29
	
    bl malloc
    // Store the address in ptrString
    ldr x1, =ptrString
    str x0, [x1]
    ldr x2, =ptrTemp        // Restore the original string address
    bl am_edit_string




    // Load the address of the previously malloc'd string into x1
    ldr x1, =ptrString
    ldr x1, [x1]
    // Set the newNode's data element to the address of the string
    str x1, [x27]



    ldr LR, [SP], #16
    ret	
	
am_edit_string:
    // Load a character from the source into x3
    ldrb w3, [x2]
    add x2, x2, #1
    // Check if the character is null (end of the string)
    cbz w3, am_end_edit // If it's null, exit the loop
    // Store the character in the allocated memory
    strb w3, [x0]
    add x0, x0, #1
    // Repeat the loop
    b am_edit_string

am_end_edit:
	mov w3,#0xa
	strb	w3,[x0]		//add a null to the end of string
    ret

	