# Assembly_XOR

/*
This is an Assembly language program written for a system based on ARM64 architecture and it was built on a linux based Raspbery Pi 400. It takes user input, a string, and a single numerical character key to perform a XOR operation. After applying XOR, it writes the result to a file called output.txt in the directory from which the program is run. Finally, it outputs the XOR result to the command line interface (CLI).

How to Use:
This program requires an ARM64 system to run. You will need an assembly language compiler like GNU Assembler (GAS) to compile and run this program. 

Following are the steps:

Compile the assembly file using GNU Assembler (as): as -o xor.o xor.s


Link the object file to create the final executable: ld -o xor xor.o


Run the executable: ./xor


Code Breakdown:
The program is divided into several sections, such as the data section, bss section (uninitialized data), and the text section (where the actual code resides).

Here is a summary of each system call (svc) in the text section:

Display the first prompt "Enter the string to XOR with the key: " and reads the string input.
Display the second prompt "Enter a one character key: " and reads the key.
Perform XOR operation on each character of the input string with the key and store the result in the xor_buffer.
Open a file named output.txt, if it doesn't exist it will create one.
Write the XORed output to the file and then write a newline.
Close the file.
Re-open the file for reading.
Read the file content into a buffer and close the file.
Print the content of the file to the console.
Print a newline to the console.
Exit the program.
The output.txt file created by the program will have the XORed string, which you can use for further processing or analysis.

Note: This program does not handle any kind of errors, e.g., if the entered key is not a single character, or if there's an issue with file I/O operations. It's a simple illustrative example of performing XOR operation using assembly language and should be used as a starting point to build more robust applications. This program was created for an end of semester project for CS12 (Assembly Language) @ Santa Rosa Junior College in 2023.

*/
