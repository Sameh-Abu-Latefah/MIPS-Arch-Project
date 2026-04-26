##					Name			      ID	 Section 
## Std#1		Abdulrahman Sawalmeh			   1221574	 	1    
## Std#2		Sameh Abulatifeh		          1220257		2    

########## Data Segment ###########
.data
error1: .asciiz "No available bins left"
#items: .float 0.56,0.1,0.75,0.25,0.85
n: .word 20  # ssldsadasdadasdasdl;fkal;fk;lfksadfkl;safkls;kf;sdakf;kdlfksa;fkldsaf;sdakf;safkd;lkfdsfafsadfdsa
bins: .float 0.0:250 	# (float Size)*(each bin size)*(number of bins)= 4*25*10
bin_capacities: .float 1.0:10
max_number_of_bins: .byte 10
items_per_bin: .byte 0:10
number_of_used_bins: .byte 0
best_fit_space: .float 1.1
best_bin_index: .byte -1
one: .float 1.0
handle:.float 0.000009
used_bins_count: .byte 0
outputFile : .asciiz"khaled.txt"

zero_float:.float 0.0
print_Bin: .asciiz "Bin "
colon: .asciiz ":"
new_line: .asciiz "\n"
space: .asciiz " "
comma: .asciiz ", "
zero: .asciiz "0."
used_bins_statement: .asciiz "The number of used bins is: "
bin_index:.byte 2
Output: .asciiz  "0000000000"


BUFFER: .space 100
Temp : .space 100 
#items: .float 0.245 , 0.4 , 0.002
items: .float 0:250
first: .asciiz "welcome to my project"
inputFileError1 : .asciiz "the input file has a number greater than one"

filename: .space 100
newLine : .asciiz "\n"
Done : .asciiz "it is not a digit"
FileName: .asciiz "please enter the file name: " 
Final: .asciiz "khalsna"
notExist : .asciiz  "this file name does not exist" 

use_FForBF_first:.asciiz "please use BF or FF first to print output"
type: .asciiz "Type FF(for first Fit), BF (for Best Fit), Q to quit:"
typeBuffer : .space 3 

flag:.byte 0

######### Code Segment ############
.text
main:
	li $v0, 4
	la $a0, FileName
        syscall

        li $v0, 8
        la $a0, filename
        li $a1, 100
        syscall

    # Print filename for debug
        li $v0, 4
        la $a0, filename
        syscall
 
    # Start stripping newline
        la $t1 , filename
        la $t3 , Temp 
        li $t4 , 10     # ASCII for newline '\n'

LLL:
        lb $t2 , 0($t1) 
        beqz $t2, add_NULL       # if null terminator
        beq $t2 , $t4, add_NULL  # if newline
         sb $t2 , 0($t3)
         addi $t1,$t1,1
         addi $t3,$t3,1
j LLL

add_NULL:
         sb $zero, 0($t3)

finish: 

          #this system call for open file 
          
	la $s0 , items  # load address for array of float to s0
	li $v0, 13  # system call for open the input file
	la $a0 , Temp # load address for file name to a0 
	la $a1 ,0   
	la $a2 ,0 
syscall 

	beq $v0 , -1  doesNotExist
            
            # this syscall for load the input file into buffer 
            
	move $t1 , $v0  # copy from register $v0 to $t1 (if $v0 have a negative value then the file descriptor has error )
	la $v0, 14  # system call for read file 
	move $a0,$t1 # move file descriptor from t1 to a0 
	la $a1,BUFFER # load adress of buffer on $a1 
	la $a2,200 # set maximum number of characters on a2 
	syscall  # after this we will save number of character that we have read in v0 



	la $v0 ,16      # this syscall for close file
	move $a0, $t1   # save file descriptor in t1 
	syscall 

               # this syscall for read data the we stored in buffer 
               
	la $v0 , 4     # this call to load adress of string to read it 
	la $a0 , BUFFER # load adress of buffer on a0 
	syscall

 
	li $v0 ,4     # this syscall for new line
	la $a0 , newLine 
	syscall

	la $t1 , BUFFER # this system call to check if the first  number greater than 1 
	lb $t2 , 0($t1)
	addi $t1,$t1,1
	bgt $t2 , '0' ,GreaterThanOne
	syscall

Loop:              # this loop to check if the input is a digit or "," or "\n" or "0" (for end read) or .(to check the number after this)
	lb $t2 , 0($t1)    # load input from t1 (from buffer)
	beq $t2,',',Loop2    # this instruction to check if the input is a digit or "," go to loop2 t ocheck if the nember greater than 1
	beq $t2 , '.' , Loop3  #   this instruction (to check the number after ".")
	beq $t2 , 0 , sameh     #   this instruction to check the end read 
	beq $t2 , '\n' , sameh   #   this instruction to check the end read 
	addi $t1,$t1,1    #   this instruction to move t1 the next adress
j Loop  

Loop2:           # Loop2: to check if the number greater than 1 
	addi $t1,$t1,1
	lb $t2 , 0($t1)
	bgt $t2 , '0' ,GreaterThanOne
j Loop


Loop3:
	li  $t4, 0   # Initialize: $t4 = sum = 0
	li  $t5, 10   # Initialize: $t5 = 10
	li $s7 , 1
	addi $t1,$t1,1
 L1:  
 	lb $t6, 0($t1)  # load $t6 = str[i]
 	beq $t6 , ',',intToFloat
 	beq $t6, 0, intToFloat
 	beq $t6,'\n', intToFloat 
 	addi $t1,$t1,1
	blt  $t6, '0', done # exit loop if ($t1 < '0')
	bgt   $t6, '9', done # exit loop if ($t1 > '9')
 	addiu $t6, $t6, -48  # Convert character to digit
 	mul  $t4, $t4, $t5  # $t4 = sum * 10
 	mul $s7,$s7,10
 	addu  $t4, $t4, $t6  # $t4 = sum * 10 + digit
 	addiu $t7, $t7, 1     # $t7 = address of next char
 j  L1   # loop back
 
 
exit:
	la $v0 ,10
	syscall 


intToFloat:
	mtc1 $t4 , $f12
	cvt.s.w $f12,$f12 
	mtc1 $s7 , $f13
	cvt.s.w $f13,$f13 

	li $t9 , 1
	mtc1 $t9 , $f14
	cvt.s.w $f14,$f14 

again:
	div.s $f12, $f12 ,$f13
	c.le.s  $f14, $f12
bc1t again


saveInArrayOfFloat:
	swc1  $f12 , 0($s0)
	addi $s0 ,$s0, 4
j Loop



GreaterThanOne:
	li $v0 ,4
	la $a0 , inputFileError1 
	syscall

done:
	li $v0 ,4
	la $a0 , Done 
	syscall


	li $v0 ,4
	la $a0 , newLine 
	syscall


	la $s0 , items
sameh:
	la $s0 , items
	li $s1 , 0
again1:
	lwc1 $f12, 0($s0)
	li $t1 , 0 
	mtc1 $t1 , $f14 
	cvt.s.w $f14,$f14
	c.eq.s $f12 , $f14
	bc1t saveCountOfNumbers
	addi $s1 , $s1 , 1
	addi $s0,$s0,4
j again1


end:
	li $v0,10 
	syscall

doesNotExist:
	li $v0 , 4
	la $a0 , notExist
	syscall
j end 



saveCountOfNumbers:
	la $s2 , n
	sw $s1 , 0($s2)
j next 





cleanup:

    la    $t0, typeBuffer
    li    $t1, 3
clr_typeBuf:
    sb    $zero, 0($t0)
    addiu $t0, $t0, 1
    addiu $t1, $t1, -1
    bnez  $t1, clr_typeBuf
    
  li $t0, 0
	la $t1, max_number_of_bins
	lb $t1, 0($t1)
	
	la $s0, bins
	la $s1, bin_capacities
	la $s2, items_per_bin
	
I_BC:
	bge $t0, $t1, I_BC_done
	
	mul $t2, $t0, 4
	
	addu $t3, $t2, $s1
	addu $t4, $t0, $s2
	
	l.s $f5, one
	li $t5, 0
	
	swc1 $f5, 0($t3)
	sb $t5, 0($t4)
	
	addiu $t0, $t0, 1
	j I_BC
	
I_BC_done:
	
	li $t0, 0
	li $t6, 250
BBB:
	bge $t0, $t6, BBB_done
	mul $t1, $t0, 4
	addu $t2, $t1, $s0
	l.s $f4, zero_float
	swc1 $f4, 0($t2)
	addiu $t0, $t0, 1
	j BBB
	
BBB_done:	
 	jr $ra
 	






next:
	li $t0, 0   # Load immediate 0 into $t1
        li $t1, 0   # Load immediate 0 into $t1
        li $t2, 0   # Reset $t2
        li $t3, 0   # Reset $t3
        li $t4, 0   # Reset $t4
        li $t5, 0   # Reset $t5
        li $t6, 0   # Reset $t6
        li $t7, 0   # Reset $t7
        li $t8, 0   # Reset $t8
        li $t9, 0   # Reset $t9
        li $s0, 0   # Reset $s0
        li $s1, 0   # Reset $s1
        li $s2, 0   # Reset $s2
        li $s3, 0   # Reset $s3
        li $s4, 0   # Reset $s4
        li $s5, 0   # Reset $s5
        li $s6, 0   # Reset $s6
        li $s7, 0   # Reset $s7
        li $t0, 0   # Reset $t0
        li $a0, 0   # Reset $a0
        li $a1, 0   # Reset $a1
        li $a2, 0   # Reset $a2
        li $a3, 0   # Reset $a3
        li $v0, 0   # Reset $v0
        li $v1, 0   # Reset $v1
        li $k0, 0   # Reset $k0
        li $k1, 0   # Reset $k1
        li $gp, 0   # Reset $gp
        li $sp, 0   # Reset $sp
        li $fp, 0   # Reset $fp
        li $ra, 0   # Reset $ra
     
     	 la   $a0, zero_float  # Load address of zero_value into $a0

        # Reset all floating-point registers to 0.0 using l.s
        l.s  $f0, 0($a0)     # Reset $f0 to 0.0
        l.s  $f1, 0($a0)     # Reset $f1 to 0.0
        l.s  $f2, 0($a0)     # Reset $f2 to 0.0
        l.s  $f3, 0($a0)     # Reset $f3 to 0.0
        l.s  $f4, 0($a0)     # Reset $f4 to 0.0
        l.s  $f5, 0($a0)     # Reset $f5 to 0.0
        l.s  $f6, 0($a0)     # Reset $f6 to 0.0
        l.s  $f7, 0($a0)     # Reset $f7 to 0.0
        l.s  $f8, 0($a0)     # Reset $f8 to 0.0
        l.s  $f9, 0($a0)     # Reset $f9 to 0.0
        l.s  $f10, 0($a0)    # Reset $f10 to 0.0
        l.s  $f11, 0($a0)    # Reset $f11 to 0.0
        l.s  $f12, 0($a0)    # Reset $f12 to 0.0
        l.s  $f13, 0($a0)    # Reset $f13 to 0.0
        l.s  $f14, 0($a0)    # Reset $f14 to 0.0
        l.s  $f15, 0($a0)    # Reset $f15 to 0.0
        l.s  $f16, 0($a0)    # Reset $f16 to 0.0
        l.s  $f17, 0($a0)    # Reset $f17 to 0.0
        l.s  $f18, 0($a0)    # Reset $f18 to 0.0
        l.s  $f19, 0($a0)    # Reset $f19 to 0.0
        l.s  $f20, 0($a0)    # Reset $f20 to 0.0
        l.s  $f21, 0($a0)    # Reset $f21 to 0.0
        l.s  $f22, 0($a0)    # Reset $f22 to 0.0
        l.s  $f23, 0($a0)    # Reset $f23 to 0.0
        l.s  $f24, 0($a0)    # Reset $f24 to 0.0
        l.s  $f25, 0($a0)    # Reset $f25 to 0.0
        l.s  $f26, 0($a0)    # Reset $f26 to 0.0
        l.s  $f27, 0($a0)    # Reset $f27 to 0.0
        l.s  $f28, 0($a0)    # Reset $f28 to 0.0
        l.s  $f29, 0($a0)    # Reset $f29 to 0.0
        l.s  $f30, 0($a0)    # Reset $f30 to 0.0
        l.s  $f31, 0($a0)    # Reset $f31 to 0.0
        
TYPE:
	la $a0 , type
	li $v0 ,4
	syscall
	
	la $a0 , new_line
	li $v0 ,4
	syscall
	
	la $a0 , typeBuffer
	li $a1 , 3
	li $v0 , 8
	syscall 
	
	la $a0 , new_line
	li $v0 ,4
	syscall
	
	la $v0 , 4
	la $a0 ,typeBuffer
	syscall
	la $a0 , new_line
	li $v0 ,4
	syscall
	
check_BF:
	li $t0 , 'B'
	la $t1 , typeBuffer
	lb $t2 , 0($t1)
	addi $t1,$t1,1
	bne $t0 , $t2 check_FF
	li $t0 , 'F'
	lb $t2 , 0($t1)
	beq $t0 , $t2 , best_fit1
check_FF:
	li $t0 , 'F'
	la  $t1 ,typeBuffer
	lb $t2 , 0($t1)
	addi $t1,$t1,1
	bne $t0 , $t2 check_Q
	li $t0 , 'F'
	lb $t2 , 0($t1)
	beq $t0 , $t2 , first_fit1
	j TYPE
check_Q:
    li $t0 , 'Q'
    la $t1 ,typeBuffer
    lb $t2 ,0($t1)
    addi $t1,$t1,1
    la $a0 ,  FileName
    bne $t0 , $t2, TYPE
    li $t0, ' '
    lb $t2, 0($t1)
    la $t3, flag
    lb $t4 , 0($t3)
    beq $t4, 0 , use_FForBF
    beq $t0 , $t2, print_File_bins 
    beq $t0, $t2, print_File_bins 
    li , $t0, 10
    beq $t0, $t2, print_File_bins 
    beqz $t2 , print_File_bins
    j    TYPE
use_FForBF:
	la $a0 , use_FForBF_first
	li $v0 , 4 
	syscall
	
	la $a0 , new_line
	li $v0 , 4 
	syscall
j TYPE 
	
		
	
	

#==================================================================================================================
	
first_fit1:	
	la $t3, flag
	lb $t4 , 0($t3)
	bgt $t4, 0 , ttt
	ttt2:
	jal first_fit
	jal print_bins
	j TYPE
	ttt:
		jal cleanup
		j ttt2
best_fit1:
	la $t3, flag
	lb $t4 , 0($t3)
	bne $t4, 0 , ttt3
	ttt4:	
	jal best_fit
	jal print_bins
	
	j TYPE
	ttt3:
		jal cleanup
		j ttt4
#next:
#-----------------------------------------------------------------------------------------------------#
# first_fit function: Implements the first fit algorithm on the bin-packing problem.				  #					
# Inputs:																							  #
# 1- items list.																					  #
# 2- number of items in the list.																	  #
# 3- 2D float array for bins bins[10][25] (Max 10 bins with capacity for 25 items).					  #
# 4- Two parallel arrays to help track how many items in each bin and what size is left in each one	  #
# Outputs:																						      #
# 1- Sorts the items on different bins according to the First Fit algorithm.						?  #
# 2- Calculates the capacity left in each bin.														  #
# 3- Counts the number of items in each bin.														  # 
#-----------------------------------------------------------------------------------------------------#
first_fit:
	#jal cleanup
	li $t0, 0   # Load immediate 0 into $t1
        li $t1, 0   # Load immediate 0 into $t1
        li $t2, 0   # Reset $t2
        li $t3, 0   # Reset $t3
        li $t4, 0   # Reset $t4
        li $t5, 0   # Reset $t5
        li $t6, 0   # Reset $t6
        li $t7, 0   # Reset $t7
        li $t8, 0   # Reset $t8
	la $t3, flag
	lb $t4 , 0($t3)
	addi $t4 , $t4 , 1 
	sb $t4 , 0($t3)
	




	li $t0, 0 					# $t0 = coutner for items (i = 0).
	la $t2, n		
	lbu $t2, 0($t2)				# $t2 = number of total items.
	la $t3, max_number_of_bins
	lbu $t3, 0($t3)				# $t3 = max_number_of_bins.
	
	la $s0, bin_capacities		# base address of the bin_capacities parallel array.
	la $s1, items				# base address of the items array.
	la $s2, bins				# base address of the bins 2D-array.
	la $s3, items_per_bin			# base address of the items_per_bin parallel array.
			
F_items_loop:
	bgeu $t0, $t2, F_items_sorted	# if i >= n means all item are sorted and end sorting loop.
	
	mul $t4, $t0, 4				# Calculate the offset of the item depending on the loop variable.
	addu $t4, $t4, $s1			# Add the offset to the base address to get the address of the item[i].
	lwc1 $f5, 0($t4)			# $f5 = item[i].
	
	li $t1, 0					# %t1 = 0 counter for bins (j = 0).
	
	F_bins_loop:							
		bgeu $t1, $t3, F_max_bins_error	# if j > max number of bins (Raise an error).
		
		mul $t5, $t1, 4				# Calculate the offset of the bin[j].
		addu $t6, $s0, $t5			# Calculate its bin[j] address.
		lwc1 $f4, 0($t6)			# $f4 = bin_capacities[j].
		
		c.lt.s  $f4, $f5			# if bin_capacities[j] < items[i].
		bc1t  F_next_bin				# go to the next bin.

		sub.s $f4, $f4, $f5			# bin_capacities[j] -= item[i].
		swc1 $f4, 0($t6)		
		
		addu $t7, $s3, $t1
		lbu $t8, 0($t7)
		
		# Calculate address of bins[j][k].
		li $t4, 25				
		mul $t4, $t4, $t1			# t4 = (j*25).
		addu $t4, $t4, $t8			# t4 = (j*25) + k.
		mul $t4, $t4, 4				# t4 = ((j*25) + k) * 4.
		addu $t4, $t4, $s2      	# address in bins.
		swc1 $f5, 0($t4)			# store item in bin.
		
		# Increment items_per_bin[j].
	    addi $t8, $t8, 1
       	    sb $t8, 0($t7)
		
		# Go to the next item.
		addi $t0, $t0, 1
		j F_items_loop
		
	F_next_bin:
		addiu $t1, $t1, 1
		j F_bins_loop
	
	
F_max_bins_error:
	la $a0, error1
	li $v0, 4
	syscall
	
F_items_sorted:
	jr $ra 
	

#-----------------------------------------------------------------------------------------------------#
# best_fit function: Implements the best fit algorithm on the bin-packing problem.				      #					
# Inputs:																							  #
# 1- items list.																					  #
# 2- number of items in the list.																	  #
# 3- 2D float array for bins bins[10][25] (Max 10 bins with capacity for 25 items).					  #
# 4- Two parallel arrays to help track how many items in each bin and what size is left in each one	  #
# Outputs:																						      #
# 1- Sorts the items on different bins according to the Best Fit algorithm.						      #
# 2- Calculates the capacity left in each bin.														  #
# 3- Counts the number of items in each bin.														  # 
#-----------------------------------------------------------------------------------------------------#
best_fit:



    #jal cleanup
    
    	li $t0, 0   # Load immediate 0 into $t1
        li $t1, 0   # Load immediate 0 into $t1
        li $t2, 0   # Reset $t2
        li $t3, 0   # Reset $t3
        li $t4, 0   # Reset $t4
        li $t5, 0   # Reset $t5
        li $t6, 0   # Reset $t6
        li $t7, 0   # Reset $t7
        li $t8, 0   # Reset $t8
	la $t3, flag
	lb $t4 , 0($t3)
	addi $t4 , $t4 , 1 
	sb $t4 , 0($t3)
	
	
    li $t0, 0                   # $t0 = 0 (i counter for items).
    la $t1, n
    lbu $t1, 0($t1)             # $t1 = number of items.
    la $t2, max_number_of_bins
    lbu $t2, 0($t2)             # $t2 = max number of bins available.
    
    la $s0, bin_capacities     
    la $s1, items               
    la $s2, bins                
    la $s3, items_per_bin       
    
B_items_loop:
    bgeu $t0, $t1, B_items_sorted  
    
    mul $t3, $t0, 4             
    add $t3, $s1, $t3           
    lwc1 $f4, 0($t3)            # $f4 = items[i].
    
    li $t4, -1                  
    l.s $f6, one                
    add.s $f6, $f6, $f6         # $f6 = 2.0 to make sure we find smaller number.
    
    li $t5, 0                   # $t5 = bin counter (j)
    
B_bins_loop:
    bgeu $t5, $t2, B_check_best_bin  # All bins are checked.
    
    mul $t6, $t5, 4             
    add $t6, $s0, $t6           
    lwc1 $f5, 0($t6)            # $f5 = bin_capacities[j].
    
    # Check if item fits in this bin.
    c.lt.s $f5, $f4
    bc1t B_next_bin             # Skip if no capacity left in the bin.
    
    # Calculate remaining space if item added
    sub.s $f7, $f5, $f4         # $f7 = remaining space
    
    # Check if this better than current best.
    c.lt.s $f7, $f6
    bc1f B_next_bin             # Skip if it's not better.
    
    # if new best bin found.
    mov.s $f6, $f7              # Update best space.
    move $t4, $t5               # Update best bin index.
    
B_next_bin:
    addiu $t5, $t5, 1
    j B_bins_loop

B_check_best_bin:
    bltz $t4, B_max_bins_error  # if all bins are full.
    
    # Update bin capacity
    mul $t6, $t4, 4             
    add $t6, $s0, $t6           
    lwc1 $f5, 0($t6)            
    sub.s $f5, $f5, $f4         # Subtract item size.
    swc1 $f5, 0($t6)            # Store new capacity.
    
    # Get current items in bin
    add $t7, $s3, $t4           # items_per_bin address
    lbu $t8, 0($t7)             # Current count
    
    li $t9, 100                 
    mul $t9, $t4, $t9           
    mul $t3, $t8, 4             
    add $t9, $t9, $t3           
    add $t9, $s2, $t9           
    swc1 $f4, 0($t9)            # Store item.
    
    # Update items_per_bin count.
    addiu $t8, $t8, 1
    sb $t8, 0($t7)
    
    # Update used_bins_count if first item.
    bne $t8, 1, B_next_item
    la $t3, used_bins_count
    lbu $t6, 0($t3)
    addiu $t6, $t6, 1
    sb $t6, 0($t3)
    
B_next_item:
    addiu $t0, $t0, 1
    j B_items_loop

B_max_bins_error:
    la $a0, error1
    li $v0, 4
    syscall

    addiu $t0, $t0, 1
    j B_items_loop
    
B_items_sorted:
    jr $ra

	
#-----------------------------------------------------------------------------------------------------#
# print_bins function:  																			  #
# Input: 																							  #
# Bins 2-D array that contains all items sorted in each bin.										  #
# Output:																							  #
# minimum number of required bins, and which items are packed in each bin.  						  #
#-----------------------------------------------------------------------------------------------------#
print_bins:

	li $t0, 0
	la $t1, max_number_of_bins
	lb $t1, 0($t1)
	la $s0, bin_capacities
	la $s1, items_per_bin
	la $s2, bins
	l.s $f5, one
	
used_bins_counter:
	mul $t2, $t0, 4
	addu $t2, $t2, $s0
	lwc1 $f4, 0($t2)
	c.eq.s $f4, $f5
	bc1t count_done
	addiu $t0, $t0, 1
	j used_bins_counter
	
count_done:
	la $t2, used_bins_count
	sb $t0, 0($t2)
	li $t0, 0
	lb $t2, 0($t2)
	
	la $a0, used_bins_statement
	li $v0, 4
	syscall
	
	move $a0, $t2
	li $v0, 1
	syscall
	
	la $a0, new_line
	li $v0, 4
	syscall
	
	
LL1:
	bgeu $t0, $t2, printing_done
	la $a0, print_Bin
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, colon
	li $v0, 4
	syscall
	
	la $a0, space
	li $v0, 4
	syscall

	
	addu $t4, $t0, $s1
	lbu $t4, 0($t4)
	
	li $t3, 0
	
	L2:
		bgeu $t3, $t4, next_bin
		
		mul $t6, $t0, 25
		addu $t6, $t6, $t3
		mul $t6, $t6, 4
		addu $t6, $t6, $s2 
		
		
		lwc1 $f6, 0($t6)
		mov.s $f12, $f6
		li $v0, 2
		syscall
		
		la $a0, comma
		li $v0, 4
		syscall
		addiu $t3, $t3, 1
		j L2
		
		next_bin:
		addiu $t0, $t0, 1
		la $a0, new_line
		li $v0, 4
		syscall
		j LL1
	
printing_done:
	jr $ra
	
	
print_File_bins:

	li $t0, 0
	la $t1, max_number_of_bins
	lb $t1, 0($t1)
	la $s0, bin_capacities
	la $s1, items_per_bin
	la $s2, bins
	l.s $f5, one
	
used_bins_counter2:
	mul $t2, $t0, 4
	addu $t2, $t2, $s0
	lwc1 $f4, 0($t2)
	c.eq.s $f4, $f5
	bc1t count_done2
	addiu $t0, $t0, 1
	j used_bins_counter2
	
count_done2:
	la $t2, used_bins_count
	sb $t0, 0($t2)
	li $t0, 0
	lb $t2, 0($t2)
	
	



	la $a0 , outputFile
	li $a1 , 1
	li $a2 , 0 
	li $v0 ,13
	syscall

	move $a0 , $v0
	move $s5 , $a0
	la $a1 , used_bins_statement
	li $a2 , 28
	li $v0 , 15
	syscall
	
	
	addi $t2 ,$t2, 48
	la $t3 , number_of_used_bins
	sb $t2 , 0($t3)
	
	
	

	#move $a0 , $v0
	la $a1 , number_of_used_bins
	li $a2 , 1
	li $v0 , 15
	syscall


	 
	la $a0, new_line

	
	
	la $t2, used_bins_count
	lb $t2, 0($t2)
	
LL2:
	bgeu $t0, $t2, printing_done2
	la $a0, print_Bin
	
	
	
	move $a0 , $s5
	la $a1 , new_line
	li $a2 , 1
	li $v0 , 15
	syscall
	
	
	move $a0 , $s5
	la $a1 , print_Bin
	li $a2 , 3
	li $v0 , 15
	syscall
	
	
	move $a0, $t0
	
	
	addi $a0 , $a0 ,48
	la $v0, bin_index
	sb $a0 , 0($v0)
	
	
	move $a0 , $s5
	la $a1 , space
	li $a2 , 1
	li $v0 , 15
	syscall 
	
	move $a0 , $s5
	la $a1 , bin_index
	li $a2 , 1
	li $v0 , 15
	syscall 
	
	move $a0 , $s5
	la $a1 , colon
	li $a2 , 1
	li $v0 , 15
	syscall 
	
	
	

	addu $t4, $t0, $s1
	lbu $t4, 0($t4)
	
	li $t3, 0
	
	LL3:
		bgeu $t3, $t4, next_bin2
		
		mul $t6, $t0, 25
		addu $t6, $t6, $t3
		mul $t6, $t6, 4
		addu $t6, $t6, $s2 
		
		
		lwc1 $f6, 0($t6)
	        j floatToString
	        continue:
		mov.s $f12, $f6
		
		
		la $a0, comma
		
		addiu $t3, $t3, 1
		j LL3
		
		next_bin2:
		addiu $t0, $t0, 1
		la $a0, new_line
	
		j LL2
	
printing_done2:
	li $v0 , 10
	syscall
	

floatToString:
	li $a3 , 0
	li $a2 , 10  # load 10 to multiply with it 
	mov.s $f22 , $f6 # save float value in $f22
	mtc1 $a2 ,$f23   # move 10 to $f23
	cvt.s.w $f23 , $f23
	l.s $f26 , handle
	gg:
	addi $a3 ,$a3,1
	mul.s $f22 , $f22 , $f23 
	mov.s $f24 , $f22
	cvt.w.s $f22 , $f22
	mfc1 $k1 , $f22
	mov.s $f22 , $f24 
	mtc1 $k1 , $f25 
	cvt.s.w $f25 , $f25 
	add.s $f25 ,$f25 , $f26 
	c.lt.s $f25 , $f24 
	bc1t gg 
	cvt.w.s $f25 , $f25 
	mfc1 $v1 , $f25
	
int2str:
 li $k0, 10    # $t0 = divisor = 10
 li $t9 , 0
 la $v0 , Output
 add $v0 ,$v0, $a3
 #addiu $v0, $a1, 11     # start at end of buffer
# sb $zero, 0($v0) # store a NULL character


 LLL2:
 divu $v1, $k0   # LO  = value/10, HI = value%10
 mflo $v1        # $a0 = value/10
 mfhi $t9          # $t1 = value%10
 addiu $t9, $t9, 48   # convert digit into ASCII
 
 addiu $v0, $v0, -1    # point to previous byte
 sb $t9, 0($v0)         # store character in memory

 bnez $v1, LLL2           # loop if value is not 0
 
 


storeFile:


move $a0 , $s5
la $a1 , space
li $a2 , 1
li $v0 , 15
syscall


move $a0 , $s5
la $a1 , zero
li $a2 , 2
li $v0 , 15
syscall

move $a0 , $s5
la $a1 , Output
move $a2 , $a3
li $v0 , 15
syscall

move $a0 , $s5
la $a1 , comma
li $a2 , 1
li $v0 , 15
syscall


 



    la $v0, Output     
    li $a1, 48          
    li $a2, 12        

clear_loop:
    sb $a1, 0($v0)    
    addi $v0, $v0, 1   
    addi $a2, $a2, -1  
    bnez $a2, clear_loop
j continue


	


