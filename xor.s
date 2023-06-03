//Will Young

/*
------------------------------------------------------------------------------------------
This program prompts the user for a string and then prompts them for a single character key.
It then performs the XOR operation character by charater of the string to the key, and 
writes that to a file. It displays the resulting XOR output. You will then find that text 
file names "output.txt" in the directory you run the program from. It will have the same
output you see on the CLI.
------------------------------------------------------------------------------------------
*/


.global _start

.section .data

    prompt1: .asciz "Enter the string to XOR with the key: "

    prompt2: .asciz "Enter a one character key: "

    fileName: .asciz "output.txt"		

    newline: .asciz "\n"

.section .bss
    input_buffer: .skip 256			// Buffer for the string input
    xor_buffer: .skip 256			// Buffer for the XORed result
    fileBuffer: .skip 256			// Buffer for the file



.section .text

_start:

//----------------------------------------------------------------------------------------
    // Print the first prompt
    mov x0, 1					// File descriptor 1 is stdout		
    ldr x1, =prompt1				// Address of the first prompt string
    ldr x2, =37					// Length of the first prompt string
    mov x8, 64					// System call number for write is 64
    svc 0					// Make the system call (write)

//----------------------------------------------------------------------------------------
    // Read the input string
    mov x0, 0					// File descriptor 0 is stdin
    ldr x1, =input_buffer			// Address of the input buffer
    ldr x2, =256				// Size of the input buffer
    mov x8, 63					// System call number for read is 63
    svc 0					// Make the system call (read)
    mov x19, x0					// Save the number of characters read


//----------------------------------------------------------------------------------------
    // Print the second prompt
    mov x0, 1					// File descriptor 1 is stdout
    ldr x1, =prompt2				// Address of the second prompt string
    ldr x2, =26					// Length of the second prompt string
    mov x8, 64					// System call number for write is 64
    svc 0					// Make the system call (write)

//----------------------------------------------------------------------------------------
    // Read the key
    mov x0, 0					// File descriptor 0 is stdin
    mov x1, sp					// Use the stack pointer for the buffer
    ldr x2, =2					// Only need to read 1 character and a newline
    mov x8, 63					// System call number for read is 63
    svc 0					// Make the system call (read)
    ldrb w20, [sp]				// Load the key from the buffer

//----------------------------------------------------------------------------------------
    // XOR the input string with the key
    ldr x21, =input_buffer			// Address of the input string
    ldr x22, =xor_buffer			// Address of the XOR buffer

//----------------------------------------------------------------------------------------
xor_loop:
    ldrb w1, [x21]				// Load a byte from the input string
    
    cmp w1, 10	
    beq xor_done				// If it's zero, we're done
    eor w1, w1, w20				// XOR the byte with the key
    strb w1, [x22]				// Store the XORed byte in the XOR buffer
    add x21, x21, 1				// Increment the input string pointer
    add x22, x22, 1				// Increment the XOR buffer pointer
    b xor_loop					// Jump back to the start of the loop
xor_done:
//----------------------------------------------------------------------------------------
    // Open the file
    mov x0, -100				// -100 is an arbitrary number used to indicate that a new file descriptor should be allocated
    ldr x1, =fileName				// Load the address of the file name
    mov x2, 578 				// O_RDWR | O_CREAT | O_TRUNC
    mov x3, 0666 				// File permissions, readable & writable for everyone
    mov x8, 56					// System call number for open
    svc 0					// Execute system call
    mov x23, x0					// Save the file descriptor


//----------------------------------------------------------------------------------------
    // Write to the file
    mov x0, x23					// File descriptor
    ldr x1, =xor_buffer				// Buffer to write from
    mov x2, x19					// Number of bytes to write
    sub x2, x2, 1				// Subtract 1 because we don't want to write the null terminator
    mov x8, 64					// System call number for write
    svc 0					// Execute system call

//----------------------------------------------------------------------------------------
    // Write newline to the file new
    mov x0, x23					// File descriptor
    ldr x1, =newline				// Newline character to write
    ldr x2, =2					// Number of bytes to write
    mov x8, 64					// System call number for write
    svc 0					// Execute system call

//----------------------------------------------------------------------------------------
    // Close the file
    mov x0, x23					// File descriptor
    mov x8, 57					// System call number for close
    svc 0					// Execute system call

//----------------------------------------------------------------------------------------
    // Re-open the file for reading
    mov x0, -100				// -100 is an arbitrary number used to indicate that a new file descriptor should be allocated
    ldr x1, =fileName				// Load the address of the file name
    mov x2, 0  					// Set the flags for the open system call: Read only
    mov x8, 56					// System call number for open
    svc 0					// Execute system call
    mov x23, x0					// Save the file descriptor

//----------------------------------------------------------------------------------------
    // Read the file
    mov x0, x23					// File descriptor
    ldr x1, =fileBuffer				// Buffer to read into
    mov x2, 256					// Number of bytes to read
    mov x8, 63					// System call number for read
    svc 0					// Execute system call
    mov x19, x0					// Save the number of bytes read

//----------------------------------------------------------------------------------------
    // Close the file
    mov x0, x23					// File descriptor
    mov x8, 57					// System call number for close
    svc 0					// Execute system call

//----------------------------------------------------------------------------------------
    // Print the content to console
    mov x0, 1					// File descriptor 1 is stdout (standard output)			
    ldr x1, =fileBuffer				// Load the address of the buffer that contains the data we want to print
    mov x2, x19					// The number of bytes to write is the number of bytes we read from the file
    mov x8, 64					// System call number for write operation
    svc 0					// Execute the system call

//----------------------------------------------------------------------------------------
    // Print newline
    mov x0, 1					// File descriptor 1 is stdout (standard output), hence we're writing to the console
    ldr x1, =newline				// Load the address of the newline character
    ldr x2, =2					// The newline character is 2 bytes long (includes null character)
    mov x8, 64					// System call number for write operation
    svc 0					// Execute the system call

//----------------------------------------------------------------------------------------

// Exit to the OS, essentially this code does this in c
// return 0;
mov x0, #0          // return value
mov x8, #93         // Service call code
svc 0               // Linux service call






