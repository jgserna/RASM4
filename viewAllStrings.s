.data
openBracket: .asciz "["
closeBracket: .asciz "] "
strTemp:	.skip	512
    .global viewAllStrings
    .text
viewAllStrings:
    mov x29, #1  //INDEX
am_print_strings:
    // Load the address of the head node into x21
    mov x21, x0
    add x21,x21,#8
    ldr x22, [x21] // Load the address of the first node
    str LR, [SP, #-16]!
    
am_print_loop:
    // Check if x21 (the current node) is null (end of the list)
    mov x21,x22
    cbz x22, am_end_print // If it's null, exit the loop
    cbz x21, am_end_print // If it's null, exit the loop
    // Load the address of the string in the current node into x0

    ldr	x0,=openBracket
	bl	putstring
    mov x0,x29
	ldr	x1,=strTemp
	bl	int64asc
	ldr	x0,=strTemp
	bl	putstring
    ldr	x0,=closeBracket
	bl	putstring    

    ldr x0, [x22]
    cbz x0, am_end_print
    // Call putstring to print the string
    bl putstring

    // Load the address of the next node into x21 (x21 now points to the next node)
    add x29,x29,#1
    add x21,x21,#8
    ldr x22, [x21]

    // Repeat the loop
    b am_print_loop

am_end_print:
    ldr LR, [SP], #16
    ret
