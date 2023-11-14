	.data
openBracket: .asciz "["
closeBracket: .asciz "] "
strTemp:	.skip	512
	.global stringSearch
	.text
	
stringSearch:
    mov x29, #1  //INDEX
    str LR, [SP, #-16]!
    bl toLowerCase_loop
    add x22,x22,#8
    ldr x23,[x22]
    
search_traverse:
    mov x0, x21
    mov x22,x23
    cbz x23, search_endStringSearch // If it's null, exit the loop
    cbz x22, search_endStringSearch // If it's null, exit the loop
    mov x0, x21
    ldr x4, [x23]
    bl stringCompareLoop

nextNode:
    add x29,x29,#1
    add x22,x22,#8
    ldr x23,[x22]
	b	search_traverse	//loop until null is found


search_endStringSearch:
	LDR	LR,[SP],#16	//POP LR
	ret		
	
stringCompareLoop:

    //character comparison
    
    ldrb w6,[x0]
checkTargetString:
    ldrb w5,[x4]
    cmp w5, #'A'
    blt continueStringCompare
    cmp w5, #'Z'
    bgt continueStringCompare
    sub w5, w5, #'A' - 'a'  // Convert to lowercase

continueStringCompare:
    cmp w6, #0
    beq stringEndCompareTrue
    cmp w5, w6
    bne stringEndCompareFalse
    add x4,x4,#1
    add x0,x0,#1
    b stringCompareLoop

stringEndCompareFalse:
    cmp w5, #0
    beq falseEndString
    add x4,x4,#1
    mov x0, x21
    b checkTargetString

falseEndString:
    ret
    
stringEndCompareTrue:
    str LR, [SP, #-16]!
    ldr	x0,=openBracket
	bl	putstring
    mov x0,x29
	ldr	x1,=strTemp
	bl	int64asc
	ldr	x0,=strTemp
	bl	putstring
    ldr	x0,=closeBracket
	bl	putstring
    ldr x0, [x23]
    bl putstring
    mov x0,x21
	LDR	LR,[SP],#16	//POP LR
    ret

toLowerCase_loop:
    ldrb w5, [x0]  // Load a character from the string into w3
    cmp w5, #0     // Compare the character with the null terminator
    b.eq end_toLowerCase // If it's the end of the string, exit the loop

    // Check if the character is an uppercase letter (ASCII range A-Z)
    cmp w5, #'A'
    blt continue_toLowerCase
    cmp w5, #'Z'
    bgt continue_toLowerCase

    // Convert to lowercase (add the ASCII difference)
    sub w5, w5, #'A' - 'a'  // Convert to lowercase
    strb w5, [x0]  // Store the lowercase character back in the string

continue_toLowerCase:
    add x0, x0, #1  // Increment the string pointer
    b toLowerCase_loop  // Repeat the loop

end_toLowerCase:
    ret
