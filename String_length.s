    .global String_length
String_length:
    mov x4, #0  // Initialize the string length to 0

check_char_loop:
    ldrb w2, [x0]  // Load the byte at the current address into w2
    cmp w2, #0     // Compare the character with 0 (null terminator)
    b.eq exit       // If it's a null terminator, exit the loop

    add x4, x4, #1  // Increment the string length
    add x0, x0, #1  // Increment the address to the next character
    b check_char_loop  // Continue looping to check the next character

exit:
    mov x0, x4   // Move the length value from register x4 to x0 for return
    ret
