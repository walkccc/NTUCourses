.data
	input1:		.word	0	
	input2:		.word	0
	operater:	.word	0
	output:		.word	0

# NOTE : Before you submit the code, make sure these two fields are "input.txt" and "output.txt"
	file_in:	.asciiz	"input.txt"
	file_out:	.asciiz	"output.txt"
	ans:		.byte	'0', '0', '0', '0'

.text
	main:    #start of your program

# STEP1: open input file 
# ($s0: fd_in)
	li		$v0, 13			# 13 = open file
	la		$a0, file_in	# $a2 <= filepath
	li		$a1, 0x0000		# $a1 <= flags = 0x4000 for Windows, 0x0000 for Linux
	li		$a2, 0			# $a2 <= mode = 0
	syscall					# $v0 <= $s0 = fd
	move	$s0, $v0		# store fd_in in $s0, fd_in is the file descriptor just returned by syscall

# STEP2: read inputs (chars) from file to registers 
# ($s1: input1, $s2: input2, $s3: ',')

# 2 bytes for the first operand
	li		$v0, 14			# 14 = read from file
	move	$a0, $s0		# $a0 <= fd_in
	la		$a1, input1		# $a1 <= input1
	li		$a2, 2			# read 2 bytes to the address given by input1
	syscall
	
# 1 byte for the operator
	li		$v0, 14			# 14 = read from file
	move	$a0, $s0		# $a0 <= fd_in
	la		$a1, operater	# $a1 <= operater
	li		$a2, 1			# read 1 bytes to the address given by operater
	syscall
	
# 2 bytes for the second operand
	li		$v0, 14			# 14 = read from file
	move	$a0, $s0		# $a0 <= fd_in
	la		$a1, input2		# $a1 <= input2
	li		$a2, 2			# read 2 bytes to the address given by input2
	syscall

# STEP3: turn the chars into integers
	la		$a0, input1		
	jal		atoi			 
	move	$s1, $v0		# $s1 <= atoi(input1) = n

	la		$a0, input2		
	jal		atoi			 
	move	$s2, $v0		# $s2 <= atoi(input2) = c

	lw		$s3, operater	# $s3 <= operater

# Inputs are ($s1: input1, $s2: input2, $s3: ',')
# Output is $s4 (in integer)
# STEP4 recurrence
	move	$a0, $s1
	jal		T				# call T(n)
	j		result
T:
	addi	$sp, $sp, -8	# allocate stack
	sw		$ra, 4($sp)
	sw		$a0, 0($sp)

	slti	$t0, $a0, 2		# test for n < 2
	beq		$t0, $zero, L1	# if n >= 2, go to L1
	add		$v0, $zero, $s2	# return c
	move	$s4, $v0
	addi 	$sp, $sp, 8		# pop 2 items off stack
	jr		$ra
L1:
	srl		$a0, $a0, 1		# n >= 2: argument gets (n / 2)
	jal		T				# call T with (n / 2)

	lw		$a0, 0($sp)		
	lw		$ra, 4($sp)
	addi	$sp, $sp, 8
	
	sll		$t1, $v0, 1		# $t1 = $v0 * 2
	mul		$t2, $s2, $a0	# $t2 = c * n
	add		$v0, $t1, $t2	# return $t1 + $t2
	move	$s4, $v0
	jr		$ra

# STEP5: turn the integer into pritable char
    # transferred ASCII should be put into "ans"(see definition in the beginning of the file)
result:
	sw		$s4, output		# output <= $s4	
	move	$a0, $s4
	jal		itoa			# itoa($s4)
	
	# TODO: store return array to ans
	move	$s4, $v0
	j		ret

itoa:
	# Input: ($a0 = input integer)
	# Output: (ans)
	la		$t0, ans		# load the address of ans to $t0
	add		$t0, $t0, 3		# seek the end
	sb		$0, 1($t0)		# null-terminated str
	li		$t1, '0'		# '0' = 48  
	sb		$t1, ($t0)		# init. with ascii 0
	slt		$t2, $a0, $0	# keep the sign
	li		$t3, 10			# preload 10
	beq		$a0, $0, iend	# end if 0
	neg		$a0, $a0
loop:
	div		$a0, $t3		# a /= 10
	mflo	$a0
	mfhi	$t4				# get remainder
	sub		$t4, $t1, $t4
	sb		$t4, ($t0)		# store it
	sub		$t0, $t0, 1		# dec. buf ptr
	bne		$a0, $0, loop	# if not zero, loop
	addi	$t0, $t0, 1		# adjust buf ptr
iend:
	beq		$t2, $0, nolz	# was < 0?
	addi	$t0, $t0, -1
	li		$t1, '-'
	sb		$t1, ($t0)
nolz:
	move	$v0, $t0      	# return the addr.
	jr		$ra				# return

ret:
# STEP6: write result (ans) to file_out
# ($s4 = fd_out)
	li		$v0, 13			# 13 = open file
	la		$a0, file_out	# $a2 <= filepath
	li		$a1, 0x41		# $a1 <= flags = 0x4301 for Windows, 0x41 for Linux
	li		$a2, 0x1a4		# $a2 <= mode = 0
	syscall					# $v0 <= $s0 = fd_out
	move	$s4, $v0		# store fd_out in $s4
	
	move	$a0, $v0		# $a0 <= $v0 = fd_out
	li		$v0, 15			# 15 = write file
	la		$a1, ans
	li		$a2, 4		
	syscall					# $v0 <= $s0 = fd
	
# STEP7: this is for you to debug your calculation on console
	li		$v0, 1			# 1 = print int
	lw		$a0, output		# $a0 <= $s1
	syscall					# print output

# STEP8: close file_in and file_out
	li		$v0, 16			# 16 = close file
	move	$a0, $s0		# $a0 <= $s0 = fd_in
	syscall					# close file

	li		$v0, 16			# 16 = close file
	move	$a0, $s4		# $a0 <= $s4 = fd_out
	syscall					# close file

	jal reset_ans			# reset ans to '0000'

# exit
	li		$v0, 10
	syscall

reset_ans:
	la		$t0, ans
	li		$t1, '0'
	sb		$t1, 0($t0)
	sb		$t1, 1($t0)
	sb 		$t1, 2($t0)
	sb		$t1, 3($t0)
	jr		$ra

atoi:
    or      $v0, $zero, $zero   	# num = 0
   	or      $t1, $zero, $zero   	# isNegative = false
    lb      $t0, 0($a0)
    bne     $t0, '+', .isp      	# consume a positive symbol
    addi    $a0, $a0, 1
.isp:
    lb      $t0, 0($a0)
    bne     $t0, '-', .num
    addi    $t1, $zero, 1       	# isNegative = true
    addi    $a0, $a0, 1
.num:
    lb      $t0, 0($a0)
    slti    $t2, $t0, 58        	# *str <= '9'
    slti    $t3, $t0, '0'       	# *str < '0'
    beq     $t2, $zero, .done
    bne     $t3, $zero, .done
    sll     $t2, $v0, 1
    sll     $v0, $v0, 3
    add     $v0, $v0, $t2       	# num *= 10, using: num = (num << 3) + (num << 1)
	addi    $t0, $t0, -48
    add     $v0, $v0, $t0       	# num += (*str - '0')
    addi    $a0, $a0, 1         	# ++num
    j   .num
.done:
    beq     $t1, $zero, .out    	# if (isNegative) num = -num
    sub     $v0, $zero, $v0		
.out:
    jr      $ra         			# return
