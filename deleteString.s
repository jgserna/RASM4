//deleteString.s 

//
//x0 has headPtr 	saved in x20
//x1 has tailPtr 	saved in x21
//x2 has newNode 	saved in x22
//x3 has index 		saved in x23
//x4 has cons 		saved in x24 
//x5 has numNodes 	saved in x25
//
//

	.data
ptrTemp: .skip 512
	.global deleteString

	.text
deleteString:

	str LR, [SP, #-16]!
	
	mov	x20,x0
	mov	x21,x1 
	mov	x22,x2 
	mov	x23,x3
	mov	x24,x4
	mov	x25,x5
	
	ldr x17,[x23]		//x17 = n
	ldr x16,[x23]		//x16 = n-1
	sub	x16,x16,#1
	
	mov x26, x20	
	add x26,x26,#8
	ldr x27,[x26] 	// Load the address of the first node
	mov x15,#1		//x15 = count = 1
traverseLoop: 
    mov x26,x27
    cbz x27, endDelete// If it's null, exit the loop
    cbz x26, endDelete // If it's null, exit the loop
	mov x28,x26
	cmp	x15,x16
	beq savePrevNode
	mov x26,x28
	cmp x15,x17
	bne continue
	//x2 has node to be deleted
	ldr x0,[x26]
	cbz x0, endDelete
	bl String_length
	bl adjustBytes
	

	

	bl adjustNumNodes
	
	
	b endDelete
    
continue: 
	add x15,x15,#1
	add x26,x26,#8
	ldr x27, [x26]
	b traverseLoop

endDelete:
	ldr LR, [SP], #16
	ret

savePrevNode:
	//mendList
	add x27,x27,#8
	ldr x27,[x27]
	add x27,x27,#8
	ldr x27,[x27]
	add x26, x26, #8
	str x27,[x26]
	sub x26,x26,#8
	add x16,x16,#2
	b traverseLoop
	
adjustBytes:
	mov x4,x24
	ldr x4,[x4]
	add x0,x0,#16
	sub x4,x4,x0
	str x4,[x24]
	
	ret 
	
adjustNumNodes:
	mov x4,x25
	ldr x4,[x4]
	sub x4,x4,#1
	str x4,[x25]
	
	ret 
	
	