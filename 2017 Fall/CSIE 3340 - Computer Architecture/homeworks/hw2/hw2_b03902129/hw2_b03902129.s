.data  
    strZERO: .asciiz "0000"   
    strXXXX: .asciiz "XXXX" 
    buffer: .space 128
    buffer2: .space 32
    file_in: 
        .asciiz "input.txt"      
    file_out: 
        .asciiz "output.txt"
    
.globl main   
.text
    main:

# Open file for reading
li $v0, 13       # system call for open file
la $a0, file_in  # input file name
li $a1, 0        # flag for reading
li $a2, 0        # mode is ignored
syscall          # open a file 
move $a0, $v0    # save the file descriptor 

# Read from file just opened
li $v0, 14       # system call for reading from file
la $a1, buffer   # address of buffer from which to read
li $a2, 11       # hardcoded buffer length
syscall          # read from file

li $t7, 0               # $t7 = 0(base)       
li $s7, 48  
li $s6, 10

la   $t6, buffer($t7)   # $t6 = $t7's location
lb   $t0, ($t6)         # put the [$t1's ASCII](int) to $t0
sub  $t0, $t0, $s7  
mul  $t0, $t0, $s6      # $t0 = 40        
addi $t7, $t7, 1

la   $t6, buffer($t7)   # $t6 = $t7's location
lb   $t1, ($t6)         # put the [$t1's ASCII](int) to $t0
sub  $t1, $t1, $s7      # $t1 = 5
add  $s0, $t0, $t1      # $s0 = 45

addi $t7, $t7, 1

la   $t6, buffer($t7)
lb   $s1, ($t6)         # $s1 = '+'
addi $t7, $t7, 1

la   $t6, buffer($t7)   # $t6 = $t7's location
lb   $t0, ($t6)         # put the [$t1's ASCII](int) to $t0
sub  $t0, $t0, $s7  
mul  $t0, $t0, $s6      # $t0 = 60       
addi $t7, $t7, 1

la   $t6, buffer($t7)   # $t6 = $t7's location
lb   $t1, ($t6)         # put the [$t1's ASCII](int) to $t0
sub  $t1, $t1, $s7      # $t1 = 7
add  $s2, $t0, $t1      # $s2 = 67
addi $t7, $t7, 1

li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall            # close file

li $t0, 43 # '+'
li $t1, 45 # '-'
li $t2, 42 # '*'
li $t3, 47 # '/'

beq $s1, $t0, Add
beq $s1, $t1, Sub
beq $s1, $t2, Mul
beq $s1, $t3, Div

### Not '+', '-', '*', '/' or div by 0
printXXXX:
    li $k0, 1  
    li $k1, 1
    j OpenFile

Add: 
    add $a0, $s0, $s2
    j Do

Sub:
    sub $a0, $s0, $s2
    j Do

Mul:
    mul $a0, $s0, $s2
    j Do

Div:
    beq $s2, $zero, printXXXX
    div $a0, $s0, $s2
    j Do

Do:
    li $k1, 1
    slti $k0,$a0, 0
    slti $t5, $a0, 10
    slti $t8, $a0, 100
    slti $t9, $a0, 1000
    jal ItoA
    move $s4, $v0
    j OpenFile

ItoA:
      la   $t0, buffer2   # load buf
      add  $t0, $t0, 30   # seek the end
      sb   $0, 1($t0)     # null-terminated str
      li   $t1, '0'  
      sb   $t1, ($t0)     # init. with ascii 0
      slt  $t2, $a0, $0   # keep the sign
      li   $t3, 10        # preload 10
      beq  $a0, $0, iend  # end if 0
      neg  $a0, $a0
loop:
      div  $a0, $t3       # a /= 10
      mflo $a0
      mfhi $t4            # get remainder
      sub  $t4, $t1, $t4
      sb   $t4, ($t0)     # store it
      sub  $t0, $t0, 1    # dec. buf ptr
      bne  $a0, $0, loop  # if not zero, loop
      addi $t0, $t0, 1    # adjust buf ptr
iend:
      beq  $t2, $0, nolz  # was < 0?
      addi $t0, $t0, -1
      li   $t1, '-'
      sb   $t1, ($t0)
nolz:
      move $v0, $t0      # return the addr.
      jr   $ra           # of the string

OpenFile:
    li $v0, 13
    la $a0, file_out
    li $a1, 1
    li $a2, 0
    syscall              # File descriptor gets returned in $v0

WriteFile:
    move $a0, $v0        # Syscall 15 requieres file descriptor in $a0
    beq $k0, $k1, WRONG

    beq $t5, $zero, L1   # < 10
    li $v0, 15
    la $a1, strZERO
    li $a2, 3
    syscall
    li $v0, 15
    move $a1, $s4
    li $a2, 1
    syscall
    j CloseFile
L1:
    beq $t8, $zero, L2   # < 100
    li $v0, 15
    la $a1, strZERO
    li $a2, 2
    syscall
    li $v0, 15
    move $a1, $s4
    li $a2, 2
    syscall
    j CloseFile
L2:
    beq $t9, $zero, L3   # < 1000
    li $v0, 15
    la $a1, strZERO
    li $a2, 1
    syscall
    li $v0, 15
    move $a1, $s4
    li $a2, 3
    syscall
    j CloseFile
L3:
    li $v0, 15
    move $a1, $s4
    li $a2, 4
    syscall
    j CloseFile
WRONG:
    li $v0, 15
    la $a1, strXXXX
    li $a2, 4
    syscall
    j CloseFile
    
CloseFile:
    li $v0, 16           # $a0 already has the file descriptor
    syscall
    j Exit

Exit:
    li $v0, 10              
    syscall
