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

	beq $a0, 0, spaceOrEmpty		#if it is a null character check if the input is empty
	beq $a0, 10, spaceOrEmpty		#if there is an end line character then check if the input is empty or parse through the loop to check if it has valid input
	
	beq $a0, 32, First			#if there is a space in front or back of the input, we just carry on with the loop until we find a non space or non endline character.
	
	beq $t9, 1, invalidInputError		# this code is executed after the first four characters after removing the spaces have been counted, so after that all other input is invalid.
	