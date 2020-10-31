.data
	invalid: .asciiz "Invalid Input"#String to print if the values are invalid
	reply: .space 1000		#reserving the 1000 bytes of memory for userInput
	four: .space 4			#new string with space for just four after the first non-space non-null character add 
.text
main:
							#asking the user for input
	li $v0, 8
	la $a0, reply
	li $a1, 1000	
	syscall
	la $a1, reply				#loading the adress of a1 in reply to increment by 1 while checking all the values
	li $t9, 0				#if it is 0, then a valid character is not found.

First:
	lb $a0,($a1)        			# read the character
	addi $a1, $a1, 1			# after reading increase the pointer by 1 