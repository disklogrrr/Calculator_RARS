# -------------------------------------------------------------------
# [KNU COMP411 Computer Architecture] Skeleton code for the 1st project (calculator)
# ��ǻ���к�_2017116965_���ٹ�
# -------------------------------------------------------------------
.data
	start_string : .string " > " 
	buffer : .space 20
	remainder_string : .string " , remainder : "
.text	
# main 
main:
	 jal x1, test #functionality test, Do not modify!!
	
	#----TODO-------------------------------------------------------------
	#1. read a string from the console
	#2. perform arithmetic operations
	#3. print a string to the console to show the computation result
	#----------------------------------------------------------------------
	
#ó�� '>' ��� 
	li a7 , 4
	la a0, start_string
	ecall
	
# buffer size(20)��ŭ �Է¹ް� ���� 
	li a7, 8
	la a0, buffer
	li a1, 20
	ecall
	 
# s0�� ������ �ּ�, t1 ~ t4�� ��Ģ���� ��ȣ 
	la s0, buffer
	li t0, 0
	li t1, 43	# +
	li t2, 45	# -
	li t3, 42	# *
	li t4, 47	# / 
	
# �Է� ������ �����ȣ���ö����� ã�� 
Loop:
	add t5, s0, t0			# t5 = �Է� ���� �ּ� 
	lb  t6, 0(t5)			# t6 = �Է� ������ �� 
	beq t6, t1, find_add		# t6 = '+', find_add��
	beq t6, t2, find_sub		# t6 = '-', find_sub��
	beq t6, t3, find_mul		# t6 = '*', find_mul��
	beq t6, t4, find_div		# t6 = '/', find_div��
	addi t0, t0, 1			# t0 1�� ���� 
	beq zero, zero, Loop
	
#s2�� ���� ���� ���� ( 0~3 ) s3�� �Է� ������ ��ȣ�� ��ġ�� �ּ� 
find_add:
	addi s2, zero, 0		
	addi s3, t0, 0			
	beq zero, zero, find_end
find_sub:
	addi s2, zero, 1		
	addi s3, t0, 0			
	beq zero, zero, find_end
find_mul:
	addi s2, zero, 2		
	addi s3, t0, 0			
	beq zero, zero, find_end	
find_div :
	addi s2, zero, 3		
	addi s3, t0, 0			
	beq zero, zero, find_end

find_end:
	li s8, 0				# s8 �� ù��° ������, s9�� �ι�° ������ 
	li s9, 0			
	li t0, 0				# t0 = 0  
	li t1, 10				# t1 = 10 
	lb t2, 0(s0)			        # t2 = buffer[0]
	addi a2, zero, 0			# a2 , a3 �ʱ�ȭ 
	addi a3, zero, 0		
	beq zero, zero, get_OP1	

get_OP1 :
	add t3, s0, t0			# t3 = ���� �ּ�  
	lb  t4, 0(t3)			# t4 = ���� �� 
	
# char => int�� 
	add  s4, t4, zero		
	addi s5, zero, 48			# s5 = '0'�� �ƽ�Ű�ڵ尪 48 
	addi s6, zero, 1			# s6 = ���� ���� ���� 1 
	
# calc���� ������ ���� �̿� s4 - s5
	add a1, zero, s6
	add a2, zero, s4
	add a3, zero, s5		
	jal ra, calc			
	add s7, zero, a0		# s7 = s4 - s5 
	
	add a3, zero, t1		# a3 = 10		
	mul s8, s8, a3			# s8 = s8 * 10 
	add s8, s8, s7			# s8 = s8 + s7
	
	addi t0, t0, 1			# t0 1���� 
	beq  t0, s3, get_OP2		# t0�� s3 ���Ǹ� , get_OP2�� 
	beq  zero, zero, get_OP1	# �ƴ϶�� �ٽ� loop�� 
	
get_OP2 :
	addi t0, t0, 1			
	add  t3, s0, t0			# t3 = address of buffer[i] 
	lb   t4, 0(t3)			# t4 = value of buffer[i]
	beq  t4, t1, get_end		# ���� ����(\n)�� ������ , get_end�� 
	
# char => int�� 
	add  s4, t4, zero		
	addi s5, zero, 48		# s5 = '0'�� �ƽ�Ű�ڵ尪 48 
	addi s6, zero, 1		# s6 = ���� ���� ���� 1 
	
# calc���� ������ ���� �̿� s4 - s5
	add a1, zero, s6
	add a2, zero, s4
	add a3, zero, s5
	jal ra, calc			
	add s7, zero, a0		# s7 = s4 - s5 (int)
	
# calc int value
	add a3, zero, t1		# a3 = 10
	mul s9, s9, a3			# s9 = s9 * 10
	add s9, s9, s7			# s9 = s9 + s7 
	
	beq zero, zero, get_OP2		
	
get_end:
# a1�� �����ȣ, a2,a3�� �Է¼��� , s10�� ����� s11�� �����⿡�� ������
	add a1, zero, s2		
	add a2, zero, s8		
	add a3, zero, s9		
	jal ra, calc			
	add s10, zero, a0		
	add s11, zero ,a4

# ù��° ���� ��� 	
	li a7, 1			
	add a0, zero, s8    
	ecall
	
# ���� ��ȣ ��� 
	li t1, 0			
	li t2, 1			
	li t3, 2			
	li t4, 3			
	beq a1, t1, print_add
	beq a1, t2, print_sub
	beq a1, t3, print_mul
	beq a1, t4, print_div
	
	print_add:	
	li a7, 11		
	addi a0, zero,  43		# '+' ��� 
	ecall
	beq zero, zero, print_end
	print_sub:	
	li a7, 11		
	addi a0, zero, 45		# '-' ��� 
	ecall
	beq zero, zero, print_end
	print_mul:	
	li a7, 11		
	addi a0, zero, 42		# '*' ��� 
	ecall
	beq zero, zero, print_end
	print_div:
	li a7, 11		
	addi a0, zero, 47		# '/' ��� 
	ecall
	beq zero, zero, print_end

#�ι�° ���� �� ��� ��� ��� 
print_end:
	li a7, 1			
	add a0, zero, s9		# �ι�° ���� ��� 
	ecall
	
	li t1, 61			
	li a7, 11			# '=' ��� 
	add a0, zero, t1		
	ecall
	
	li a7, 1			
	add a0, zero, s10		# ��� ��� ��� 
	ecall
	
	
	beq a1, t4, print_remainder	# �������̸� ������ ��� 
	
# Exit (93) with code 0
        li a0, 0
        li a7, 93
        ecall
        ebreak
print_remainder:
	li a7 , 4
	la a0, remainder_string
	ecall
	
	li a7, 1
	add a0, zero, s11
	ecall	
	
# Exit (93) with code 0
        li a0, 0
        li a7, 93
        ecall
        ebreak

#----------------------------------
#name: calc
#func: performs arithmetic operation
#x11(a1): arithmetic operation (0: addition, 1:  subtraction, 2:  multiplication, 3: division)
#x12(a2): the first operand
#x13(a3): the second operand
#x10(a0): return value
#x14(a4): return value (remainder for division operation)
#----------------------------------
calc:
	#TODO
	addi a5, zero, 0		# a5�� ��Ģ���� ����
clac_add:			
	bne a1, a5, clac_sub		# a1 = 0�� �ƴϸ� ��������
	add a0, a2, a3			# a0 = a2 + a3
	beq zero,zero, clac_end		
clac_sub:
	addi a5, a5, 1		
	bne  a1, a5, clac_mul		# a1 = 1�� �ƴϸ� ��������
	xori a6, a3, -1			
	addi a6, a6, 1			# a6�� a3�� 2�Ǻ��� 
	add  a0, a2, a6			# a0 = a2 + (-a3)
	beq  zero,zero, clac_end		
clac_mul:
	addi a5, a5, 1		
	bne  a1, a5, clac_div		# a1 = 2�� �ƴϸ� ����������
	add  a0, zero, zero		# a0 �ʱ�ȭ 
	addi a6, a2, 0			# a6 = a2 (multiplicand)
	addi a7, a3, 0			# a7 = a3 (multiplier)
	loop_mul:
		beq  a7, zero, clac_end	
		andi t3, a7, 1		
		beq  t3, zero, shift_mul	# t3 = 0, ����Ʈ ����
		add  a0, a0, a6		# t3 = 1, multiplicand�� ����� ���Ѵ�.
		shift_mul:
		srli a7, a7, 1		# a7  >> 1 bit
		slli a6, a6, 1		# a6  << 1 bit
		beq zero, zero, loop_mul	
		
clac_div:
	add t1, a2, zero 	# A = t1
	add t2, a3 ,zero	# B = t2 
	add a0, zero, zero	# �� 
	add a4, zero, zero 	# ������ 
	add a4, t1, zero 	# �������� A�ֱ� 
	add t5, zero, zero 	# t5�� ī��Ʈ 
	addi s6, zero, 32
	loop_div:
		sub a4, a4, t2 
		blt a4, zero, loop_div_b
	loop_div_a:
		slli a0, a0 ,1
		addi a0, a0, 1 
		beq zero, zero, loop_div_c
	loop_div_b:
		add a4, a4 , t2
		slli a0, a0 ,1
		addi a4, a4 , -1
		beq zero, zero, loop_div_c
	loop_div_c:
		srli t2, t2, 1
		addi t5, t5, 1 
		blt t5, s6, loop_div
#clac_div:
	#add  a0, zero, zero  		# a0 �ʱ�ȭ  (Quitient) �� 
	#addi a6, a2, 0			# a6 = a2 (dividend) ������
	#addi a7, a3, 0			# a7 = a3 (divisor) ����
	#add  a4, zero ,a6		# a4 �ʱ�ȭ (remainder) �������� �������� �ʱ�ȭ 
	#loop_div:
		#beq zero,zero, clac_end
		#beq  a7, zero, clac_end	
		#srli a4, a4, 4 		# half of remainder 
		#sub  a4, a4, a7
		#bge a4, zero, loop_div_b
		#loop_div_b:
		#���� 
		#beq zero, zero, loop_div

#clac_div:
	#add t1, a2, zero 	# 
	#add t2, a3, zero	# 
	#add t3, a2, zero
	#add a0, zero, zero	# �� �ʱ�ȭ 
	#loop_div:
		#blt  t3, zero, clac_end
		#xori t6, a3, -1
		#addi t6, t6, 1		# t6 = 
		#add  t3, t6, zero 	# t3 - a3 
		#bgt  t3, zero loop_div2
		#blt  t3, zero, loop_div
		#loop_div2 :
		 	#addi a0, a0, 1
			#beq zero,zero , loop_div 

clac_end:
	jalr x0, 0(x1)
	
.include "common.asm"
