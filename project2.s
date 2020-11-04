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
	slti $t2, $t0, 58       	  		#checking if it is a valid digit. digit...  if t0 < 58, then t2=1 
	li $t3, 47
	slt $t3, $t3, $t0                       # if 47 < t0,  t3 = 1, it acts as a bool so as to treat the input as a number 
	and $t3, $t3, $t2  			# if t3 and t2 are same, t3  = 1 
	addi $t9, $t0, -48			# initialising t9 for the original values have been calculated by substracting the overflowing ASCII
	beq $t3, 1, convert			# passing it to label convert, if t3 is 1 because it will make sure that it is in our range of rumber 0-9, not special characters.

	slti $t2, $t0, 90			#checking if it is a valid uppercase letter. my range is A to Y, so Y=89, so using value one more so less than works
	li $t3, 64 				
	slt $t3, $t3, $t0 			#if 64<t0, t3=1, as this recognizes the input as a Uppercase letter.
	and $t3, $t3, $t2  			# if t3 and t2 are same, t3  = 1 
	addi $t9, $t0, -55     
	beq $t3, 1, convert

	slti $t2, $t0, 121			#checking valid lcase letter, my range is a to y, so y=121, so using value thats one more so that less than works			
	li $t3, 96
	slt $t3, $t3, $t0
	and $t3, $t3, $t2  			# if t3 and t2 are same, t3  = 1, this checks if it falls under <=96
	addi $t9, $t0, -87
	bne $t3, 1, invalidInputError		#when t3 is not equal to one it is invalid because less than 96 is not a valid
convert:
	mul $t5, $t4, $t9			# $t5 contains the product of the base- 35 exponent and our input number
	add $s5, $s5, $t5			# that product is added to the register that stores the sum 
	mul $t4, $t4, 35 
	j Loop
Space:						#sees if the space is in between or is at ending points, by using a3 as bool
	beq $a3, 1, invalidInputError		# once non-null, non-space, non-endline is found, a3 = 1, if it is in between the characters, then it goes to invalid input, in short, if a3 is set to 1 twice in the Loop label, it will recognize that its not valid.
	j Loop					#if it is a trailing space, go back to loop

	
	