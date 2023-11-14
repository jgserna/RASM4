//RASM4 menu driver

//
//
.equ RW_RW___, 0660
.equ AT_FDCWD, -100
.equ MAX_BYTES, 512 // Max string size

	.data
szName:		.asciz	"Names: Austin Monroe & Jocelyne Gallardo"
szProg:		.asciz	"Program: RASM4"
szClass:	.asciz	"Class: CS3B"
szDate:		.asciz	"Date: November 9, 2023"
szConsump:	.asciz	"\nData Structure Heap Memory Consumption: "
szNodes:	.asciz	"Number of Nodes: "
szMenu:		.asciz	"<1> View all strings\n\n<2> Add String\n\t<a> from Keyboard\n\t<b> from File\n\n<3> Delete String\n\n<4> Edit String\n\n<5> String Search\n\n<6> Save File\n\n<7> Quit\n\n" 
szPrompt:	.asciz	"\nEnter your selection: "
szPrompt1:	.asciz	"Enter a string: "
szPrompt2:	.asciz	"Enter a line to delete: "
szPrompt3:	.asciz	"Enter a line to edit: "
szPrompt4:	.asciz	"Enter a file name : "
szPrompt5:	.asciz	"Enter a file name to save: "
szStringSearch: .asciz "Enter a string to search: "
szInvalidMsg:	.asciz	"INVALID ENTRY.\n"
szGoodbye:	.asciz	"Goodbye.\n"
szInput:	.skip	21
strTemp:	.skip	512
chLF:		.byte	0xa
newNode:  .quad  0
headPtr:  .quad 0
tailPtr:  .quad  0
numNodes:	.quad 0
consumption: .quad 0
index:		.quad 0


	.global _start
	.text
_start:
	ldr	x0,=szName	//x0 points to szName
	bl	putstring	//prints string
	ldr x0,=chLF	//x0 points to chLF
	bl	putch		//prints carriage return

	ldr	x0,=szProg	//x0 points to szProg
	bl	putstring	//prints string
	ldr x0,=chLF	//x0 points to chLF
	bl	putch		//prints carriage return

	ldr	x0,=szClass	//x0 points to szClass
	bl	putstring	//prints string
	ldr x0,=chLF	//x0 points to chLF
	bl	putch		//prints carriage return

	ldr	x0,=szDate	//x0 points to szDate
	bl	putstring	//prints string
	ldr x0,=chLF	//x0 points to chLF
	bl	putch		//prints carriage return
	ldr	x0,=chLF	//x0 points to chLF
	bl	putch		//prints carriage return

displayMenu:
	ldr	x0,=szConsump
	bl	putstring
	ldr	x0,=consumption
	ldr	x0,[x0]
	ldr	x1,=strTemp
	bl	int64asc
	ldr	x0,=strTemp
	bl	putstring
	ldr	x0,=chLF
	bl	putch

	ldr	x0,=szNodes
	bl	putstring
	ldr	x0,=numNodes
	ldr	x0,[x0]
	ldr	x1,=strTemp
	bl	int64asc
	ldr	x0,=strTemp
	bl	putstring
	ldr	x0,=chLF
	bl	putch

	ldr	x0,=szMenu
	bl	putstring
	
inputLoop:
	ldr	x0,=szConsump
	bl	putstring
	ldr	x0,=consumption
	ldr	x0,[x0]
	ldr	x1,=strTemp
	bl	int64asc
	ldr	x0,=strTemp
	bl	putstring
	ldr	x0,=chLF
	bl	putch

	ldr	x0,=szNodes
	bl	putstring
	ldr	x0,=numNodes
	ldr	x0,[x0]
	ldr	x1,=strTemp
	bl	int64asc
	ldr	x0,=strTemp
	bl	putstring
	ldr	x0,=chLF
	bl	putch
	
	ldr	x0,=szPrompt
	bl	putstring
	
	ldr	x0,=szInput
	mov	x1,MAX_BYTES
	bl	getstring
	
checkInput:
	ldr	x20,=szInput
	ldrb	w21,[x20]		//load first byte of x0(input)
	
	cmp	w21,#'1'			//check if input <1
	b.lt	invalidInput
	
	cmp	w21,#'7'				//check if input >7
	b.gt	invalidInput
	
	cmp	w21,#'2'				//if equal to 2, check second byte
	b.eq	checkInput2
	
	b	inputValid
	
checkInput2:
	ldr	x20,=szInput
	add	x20,x20,#1
	ldrb	w21,[x20]
	
	cmp	w21,#'a'
	b.eq	inputValid
	
	cmp	w21,#'b'
	b.eq	inputValid
	
invalidInput:
	ldr	x0,=szInvalidMsg
	bl	putstring
	
	b	displayMenu
	
inputValid:

	ldr	x20,=szInput
	ldrb	w21,[x20]		//load first byte of x0(input)
	
//compare and branch to...
	cmp	w21,#'1'
	b.eq	viewAll
	
	cmp	w21,#'2'
	b.eq	checkAorB
	
	cmp	w21,#'3'
	b.eq	deleteStr
	
	cmp	w21,#'4'
	b.eq	editStr
	
	cmp	w21,#'5'
	b.eq	searchStr
	
	cmp	w21,#'6'
	b.eq	saveFile
	
	cmp	w21,#'7'
	b.eq	quit
	
// functions to make:
viewAll:
    ldr x0, =headPtr
    bl viewAllStrings
	b displayMenu
	
addStrFromKeyboard:
	ldr	x0,=szPrompt1
	bl	putstring
	
	ldr	x0,=strTemp
	mov	x1,#MAX_BYTES
	bl	getstring
	
	ldr x0,=headPtr
   	ldr x1,=tailPtr
   	ldr x2,=newNode
	ldr x3,=strTemp
	ldr x4,=consumption
	ldr x5,=numNodes

	bl	addFromKBD
	
	b displayMenu
	
addStringFromFile:
	ldr	x0,=szPrompt4
	bl	putstring
	
	ldr	x0,=strTemp
	mov	x1,#MAX_BYTES
	bl	getstring

    ldr x0,=headPtr
    ldr x1,=tailPtr
    ldr x2,=newNode
	ldr x3,=strTemp
	ldr x5,=consumption
	ldr x6,=numNodes

	bl	addFromFile
	
	b displayMenu
	
	
deleteStr:
	ldr	x0,=szPrompt2
	bl	putstring
	
	ldr	x0,=index
	mov	x1,#MAX_BYTES
	bl	getstring
	
	ldr x0,=index
	bl ascint64
	mov x1,x0
	ldr x0,=index
	str x1,[x0]
	
	ldr x0,=headPtr
   	ldr x1,=tailPtr
   	ldr x2,=newNode
	ldr x3,=index
	ldr x4,=consumption
	ldr x5,=numNodes

	
	bl	deleteString
	
	b displayMenu

editStr:
	ldr	x0,=szPrompt3
	bl	putstring
	
	ldr	x0,=index
	mov	x1,#MAX_BYTES
	bl	getstring
	
	ldr x0,=index
	bl ascint64
	mov x1,x0
	ldr x0,=index
	str x1,[x0] 
	
	ldr x0,=headPtr
   	ldr x1,=tailPtr
   	ldr x2,=newNode
	ldr x3,=index
	ldr x4,=consumption
	
	bl editString
	
	b displayMenu

searchStr:
	ldr x0, =szStringSearch
	bl putstring
	ldr	x0,=strTemp
	mov	x1,#MAX_BYTES
	bl	getstring
	ldr x0,=strTemp
	mov x21,x0
	ldr x22, =headPtr
	bl stringSearch
	b displayMenu
	
saveFile:
	ldr	x0,=szPrompt5
	bl	putstring
	
	ldr	x0,=strTemp
	mov	x1,#MAX_BYTES
	bl	getstring
	
	ldr x0,=headPtr
	ldr x3,=strTemp
	
	bl saveToFile
	b displayMenu
	
checkAorB:
	ldr	x20,=szInput
	add	x20,x20,#1
	ldrb	w21,[x20]
	
	cmp	w21,#'a'
	b.eq	addStrFromKeyboard
	
	cmp	w21,#'b'
	b.eq	addStringFromFile
	
	
quit:
	ldr	x0,=szGoodbye
	bl	putstring
	
	mov	x0,#0
	mov x8,#93
	svc	0
	.end
	
	