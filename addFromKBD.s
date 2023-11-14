//addFromKBD.s
//
//x0 has headPtr 	saved in x20
//x1 has tailPtr 	saved in x21
//x2 has newNode 	saved in x22
//x3 has kbdBuf 	saved in x23
//x4 has cons 	saved in x24 
//x5 has numNodes saved in x25
//
//


	.data
ptrString: .quad 0
	.global addFromKBD
	.text
	
addFromKBD:

	str LR, [SP, #-16]!		//Store contents of the link register onto stack

	mov	x20,x0
	mov	x21,x1 
	mov	x22,x2 
	mov	x23,x3
	mov	x24,x4
	mov	x25,x5
	
	//x0 - x5 now free to use
	
	
	bl	mallocCopy
	bl	addNode
	ldr	LR,[SP],#16	
	ret
	
	
mallocCopy:
	mov	x0,x23		//place the original string address in x0
	str	LR, [SP, #-16]!
	bl	String_length	
	mov	x3,x0		//save string length in x3
	bl	incrementBytes
	mov	x0,x3			//x0 holds bytes needed for malloc
	bl	malloc		//use malloc
	//x0 holds the address to allocated memory
	ldr	x1,=ptrString
	str	x0,[x1]		//store the address of allocated memory in ptrStr

	mov	x2,x23		//Place original string address into x2
	bl	copyLoop

//setup a node
	mov	x0,#16		//need 16 bytes for malloc
	bl	malloc		//Malloc 16 bytes (8 bytes for the &data element and 8 bytes for the &next element) for the newNode.

//	ldr	x1,=newNode	//x1 holds the address of newNode
	mov	x1,x22
	str	x0,[x1]		//store the allocated memory 16byte address in newNode

	ldr	x0,[x1]		//Load address of newNode into x0

	ldr	x1,=ptrString	//load address of previously mallocd string into x1
	ldr	x1,[x1]		//extract the address of mallocd string 1 from ptrString
		
	str	x1,[x0]		//Store the address of the string into &data of newNode
	str	xzr,[x0,#8]	//set the second 8 bytes in newNode to null (0)

	ldr	LR,[SP],#16	
	ret
	
copyLoop:	//x2 holds the address of string to be copied
		//x1 holds the address of ptrString
		//x0 holds the address of the malloc'd memory space to be copied into
	mov	x1,x22		//x0 holds string address to be copied

	ldrb	w3,[x2]		//load a character(byte) from x2 (string)
	add	x2,x2,#1	//increment to the next byte of the source address

	cbz	w3,exitCopyLoop	//if w3 is 0(null) jump to exitCopyLoop

	strb	w3,[x0]		//store the byte into the allocated memory
	add	x0,x0,#1	//increment the destination address by 1
	b	copyLoop	//loop until null (end of string) is found

exitCopyLoop:
	mov w3,#0xa
	strb	w3,[x0]		//add a null to the end of string
	
	ret

addNode:

//	ldr	x0,=newNode	//load address of newNode
	mov	x0,x22
	ldr	x0,[x0]		//load the address held in the address of newNode
				//check if list empty
//	ldr	x1,=headPtr	//load address of headPtr into x1
	mov	x1,x20
	ldr	x1,[x1]		//
	cbz	x1,emptyList	//if list is empty, set head/tailptr to newNode
				//if not empty find tail node
//	ldr	x2,=tailPtr	//if list not empty, load tailPtr
	mov	x2,x21
	ldr	x2,[x2]		//x2 holds the address value of tailPtr
	ldr	x3,[x2,#8]	//load the next node to x3
	cbz	x3,notEmpty	//if the next mode = 0, tail node is found
				//if not 0, keep checking by loop to find the null (tail)
traverse:
	ldr	x2,[x2,#8]	//load the next node
	ldr	x3,[x2,#8]	//check if node is null
	cmp	x3,#0
	bne	traverse	//loop until null is found
notEmpty:	
	str	x0,[x2,#8]	//update the next ptr of curren tail node to new node
	b	endAddNode
emptyList:
//	ldr	x1,=headPtr	//load the address of headPtr
	mov	x1,x20
	str	x0,[x1]		//store the address of newNode in headPtr

//	ldr	x1,=tailPtr	//load the address of tailPtr
	mov	x1,x21
	str	x0,[x1]		//store the address of newNode in tailPtr
	
	b	endAddNode
	
endAddNode:
	mov	x5,x25
	ldr	x5,[x5]
	add	x5,x5,#1
	str	x5,[x25]
	
	mov	x1,#16
	mov	x4,x24
	ldr	x4,[x4]
	add	x4,x4,x1
	str	x4,[x24]
	
	ret		
	
incrementBytes:
	mov	x1,x0
	add	x1,x1,#1
	mov	x4,x24
	ldr	x4,[x4]
	add	x4,x4,x1
	str	x4,[x24]
	
	ret


end:
	mov	x0,x23
	bl	putstring

	LDR LR, [SP], #16
	ret
	
	.end
	
	

	
