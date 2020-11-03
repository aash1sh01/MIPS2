.data
	invalid: .asciiz "Invalid Input"	#String to print if the values are invalid
	reply: .space 1000			#reserving the 1000 bytes of memory for userInput
	four: .space 4				#new string with space for just four after the first non-space non-null character add 
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
	li $t9, 1				# $t9 = 1 means that a non-space character is discovered
						# in these lines I am storing 4 characters after a non-space character is found in  another string named Four.
	la $s6, four				#loading the adress of Four to s6 
	lb $a0, -1($a1)                         #storing the first non-space character to the starting address of Four
	sb $a0, 0($s6)                 

	lb $a0, 0($a1) 				#storing the second non-space character to 1+ starting address of Four
	sb $a0, 1($s6)
	lb $a0, 1($a1)	 			#storing the third non-space character to 2+ starting address of Four
	sb $a0, 2($s6)
	lb $a0, 2($a1)	 			#storing the fourth non-space character to 3+ starting address of Four
	sb $a0, 3($s6)
	addi $a1, $a1, 1			# added 1 to $a1 because to read the characters from input string
	j First
spaceOrEmpty:
	beq $t9, 0, invalidInputError		# if $t9 = 0 then, it means no non-space character is found.
	li $s5, 0				# this register holds the final sum of the Base-35 number
	li $t4, 1				# this register holds the exponent of 35. At first, it is 1, then 35, then 35*35
	li $t7, 0				# this is my loop counter. when it equals 3 the loop exits. 
	la $s6, four+4				#to start at the end of the string, adding 4 to come backwards
Loop:
	beq $t7, 4, print			#if the value of the counter = 4, then the loop exits
	addi $t7, $t7, 1 			# incrementing the value of the counter
	addi $s6, $s6, -1			#decreasing the value of the address to load 
	lb $t0, ($s6)				# $s6 has the address of the fourth or the last byte of the input in first iteration.
	beq $t0, 10, Loop  			# if there is an end line character within the first values then continue the loop
	beq $t0, 32, Space			# if there is a space in front or back of the input, we just carry on with the loop
	beq $t0, 0, Loop			# if it is a null character, then it will just skip and continue the loop

	li $a3, 1				# the program counter reaches this point when the character is not null, space or endline.
	
	