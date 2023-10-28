//RASM4 menu driver

//

//
	.equ	MAX_BYTES,21

	.data
szName:		.asciz	"Names:Austin Monroe & Jocelyne Gallardo"
szProg:		.asciz	"Program: RASM4"
szClass:	.asciz	"Class: CS3B"
szDate:		.asciz	"Date: November 9, 2023"
szMenu:		.asciz	"<1> View all strings\n\n<2> Add String\n\t<a> from Keyboard\n\t<b> from File\n\n<3> Delete String\n\n<4> Edit String\n\n<5> String Search\n\n<6> Save File\n\n<7> Quit\n\n" 
szPrompt:	.asciz	"Enter your selection: "
szInvalidMsg:	.asciz	"Invalid entry."
szGoodbye:	.asciz	"Goodbye."
szInput:	.skip	21
chLF:		.byte	0xa


	.global _start
	.text
_start:
	ldr	x0,=szName	//x0 points to szName
	bl	putstring	//prints string
	ldr 	x0,=chLF	//x0 points to chLF
	bl	putch		//prints carriage return

	ldr	x0,=szProg	//x0 points to szProg
	bl	putstring	//prints string
	ldr 	x0,=chLF	//x0 points to chLF
	bl	putch		//prints carriage return

	ldr	x0,=szClass	//x0 points to szClass
	bl	putstring	//prints string
	ldr 	x0,=chLF	//x0 points to chLF
	bl	putch		//prints carriage return

	ldr	x0,=szDate	//x0 points to szDate
	bl	putstring	//prints string
	ldr 	x0,=chLF	//x0 points to chLF
	bl	putch		//prints carriage return
	ldr	x0,=chLF	//x0 points to chLF
	bl	putch		//prints carriage return

displayMenu:
	ldr	x0,=szMenu
	bl	putstring
	
inputLoop:
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
	
	b	inputLoop
	
inputValid:

	ldr	x20,=szInput
	ldrb	w21,[x20]		//load first byte of x0(input)
	
//compare and branch to...
	cmp	w21,#1
	b.eq	viewAll
	
	cmp	w21,#2
	b.eq	addFrom
	
	cmp	w21,#3
	b.eq	deleteStr
	
	cmp	w21,#4
	b.eq	editStr
	
	cmp	w21,#5
	b.eq	searchStr
	
	cmp	w21,#6
	b.eq	saveFile
	
	cmp	w21,#7
	b.eq	quit
	
// functions to make:
viewAll:
	//openfile
	//read from File
	//output all to screen
	//close File
	//b	inputLoop
addFrom:
	//load second byte of szInput
	//perform check on second byte
	//if 'a' perform add from KBD
	//if 'b' perform add from File
	
	
	//b inputLoop
deleteStr:
	//prompt user for index?
	//use index in function to delete String
	//b inputLoop

editStr:
	//

searchStr:

saveFile:
	
		
	
quit:
	ldr	x0,=szGoodbye
	bl	putstring
	
	mov	x0,#0
	mov x8,#93
	svc	0
	.end
