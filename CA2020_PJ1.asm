# -------------------------------------------------------------------
# [KNU COMP411 Computer Architecture] Skeleton code for the 1st project (calculator)
# 컴퓨터학부_2017116965_전근민
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
	
#처음 '>' 출력 
	li a7 , 4
	la a0, start_string
	ecall
	
# buffer size(20)만큼 입력받고 저장 
	li a7, 8
	la a0, buffer
	li a1, 20
	ecall
	 
# s0는 버퍼의 주소, t1 ~ t4는 사칙연산 기호 
	la s0, buffer
	li t0, 0
	li t1, 43	# +
	li t2, 45	# -
	li t3, 42	# *
	li t4, 47	# / 
	
# 입력 버퍼중 연산기호나올때까지 찾기 
Loop:
	add t5, s0, t0			# t5 = 입력 버퍼 주소 
	lb  t6, 0(t5)			# t6 = 입력 버퍼의 값 
	beq t6, t1, find_add		# t6 = '+', find_add로
	beq t6, t2, find_sub		# t6 = '-', find_sub로
	beq t6, t3, find_mul		# t6 = '*', find_mul로
	beq t6, t4, find_div		# t6 = '/', find_div로
	addi t0, t0, 1			# t0 1씩 증가 
	beq zero, zero, Loop
	
#s2는 연산 구분 숫자 ( 0~3 ) s3는 입력 버퍼중 기호가 위치한 주소 
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
	li s8, 0				# s8 은 첫번째 연산자, s9는 두번째 연산자 
	li s9, 0			
	li t0, 0				# t0 = 0  
	li t1, 10				# t1 = 10 
	lb t2, 0(s0)			        # t2 = buffer[0]
	addi a2, zero, 0			# a2 , a3 초기화 
	addi a3, zero, 0		
	beq zero, zero, get_OP1	

get_OP1 :
	add t3, s0, t0			# t3 = 버퍼 주소  
	lb  t4, 0(t3)			# t4 = 버퍼 값 
	
# char => int로 
	add  s4, t4, zero		
	addi s5, zero, 48			# s5 = '0'의 아스키코드값 48 
	addi s6, zero, 1			# s6 = 빼기 구분 숫자 1 
	
# calc에서 구현한 뺄셈 이용 s4 - s5
	add a1, zero, s6
	add a2, zero, s4
	add a3, zero, s5		
	jal ra, calc			
	add s7, zero, a0		# s7 = s4 - s5 
	
	add a3, zero, t1		# a3 = 10		
	mul s8, s8, a3			# s8 = s8 * 10 
	add s8, s8, s7			# s8 = s8 + s7
	
	addi t0, t0, 1			# t0 1증가 
	beq  t0, s3, get_OP2		# t0가 s3 가되면 , get_OP2로 
	beq  zero, zero, get_OP1	# 아니라면 다시 loop문 
	
get_OP2 :
	addi t0, t0, 1			
	add  t3, s0, t0			# t3 = address of buffer[i] 
	lb   t4, 0(t3)			# t4 = value of buffer[i]
	beq  t4, t1, get_end		# 만약 엔터(\n)가 들어오면 , get_end로 
	
# char => int로 
	add  s4, t4, zero		
	addi s5, zero, 48		# s5 = '0'의 아스키코드값 48 
	addi s6, zero, 1		# s6 = 빼기 구분 숫자 1 
	
# calc에서 구현한 뺄셈 이용 s4 - s5
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
# a1는 연산기호, a2,a3는 입력숫자 , s10은 계산결과 s11은 나누기에서 나머지
	add a1, zero, s2		
	add a2, zero, s8		
	add a3, zero, s9		
	jal ra, calc			
	add s10, zero, a0		
	add s11, zero ,a4

# 첫번째 숫자 출력 	
	li a7, 1			
	add a0, zero, s8    
	ecall
	
# 연산 기호 출력 
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
	addi a0, zero,  43		# '+' 출력 
	ecall
	beq zero, zero, print_end
	print_sub:	
	li a7, 11		
	addi a0, zero, 45		# '-' 출력 
	ecall
	beq zero, zero, print_end
	print_mul:	
	li a7, 11		
	addi a0, zero, 42		# '*' 출력 
	ecall
	beq zero, zero, print_end
	print_div:
	li a7, 11		
	addi a0, zero, 47		# '/' 출력 
	ecall
	beq zero, zero, print_end

#두번째 연산 및 계산 결과 출력 
print_end:
	li a7, 1			
	add a0, zero, s9		# 두번째 숫자 출력 
	ecall
	
	li t1, 61			
	li a7, 11			# '=' 출력 
	add a0, zero, t1		
	ecall
	
	li a7, 1			
	add a0, zero, s10		# 계산 결과 출력 
	ecall
	
	
	beq a1, t4, print_remainder	# 나눗셈이면 나머지 출력 
	
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
	addi a5, zero, 0		# a5로 사칙연산 구분
clac_add:			
	bne a1, a5, clac_sub		# a1 = 0이 아니면 뺄셈으로
	add a0, a2, a3			# a0 = a2 + a3
	beq zero,zero, clac_end		
clac_sub:
	addi a5, a5, 1		
	bne  a1, a5, clac_mul		# a1 = 1이 아니면 곱셈으로
	xori a6, a3, -1			
	addi a6, a6, 1			# a6는 a3의 2의보수 
	add  a0, a2, a6			# a0 = a2 + (-a3)
	beq  zero,zero, clac_end		
clac_mul:
	addi a5, a5, 1		
	bne  a1, a5, clac_div		# a1 = 2이 아니면 나눗셈으로
	add  a0, zero, zero		# a0 초기화 
	addi a6, a2, 0			# a6 = a2 (multiplicand)
	addi a7, a3, 0			# a7 = a3 (multiplier)
	loop_mul:
		beq  a7, zero, clac_end	
		andi t3, a7, 1		
		beq  t3, zero, shift_mul	# t3 = 0, 쉬프트 연산
		add  a0, a0, a6		# t3 = 1, multiplicand를 결과에 더한다.
		shift_mul:
		srli a7, a7, 1		# a7  >> 1 bit
		slli a6, a6, 1		# a6  << 1 bit
		beq zero, zero, loop_mul	
		
clac_div:
	add t1, a2, zero 	# A = t1
	add t2, a3 ,zero	# B = t2 
	add a0, zero, zero	# 몫 
	add a4, zero, zero 	# 나머지 
	add a4, t1, zero 	# 나머지에 A넣기 
	add t5, zero, zero 	# t5는 카운트 
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
	#add  a0, zero, zero  		# a0 초기화  (Quitient) 몫 
	#addi a6, a2, 0			# a6 = a2 (dividend) 피제수
	#addi a7, a3, 0			# a7 = a3 (divisor) 제수
	#add  a4, zero ,a6		# a4 초기화 (remainder) 나머지는 피제수로 초기화 
	#loop_div:
		#beq zero,zero, clac_end
		#beq  a7, zero, clac_end	
		#srli a4, a4, 4 		# half of remainder 
		#sub  a4, a4, a7
		#bge a4, zero, loop_div_b
		#loop_div_b:
		#으아 
		#beq zero, zero, loop_div

#clac_div:
	#add t1, a2, zero 	# 
	#add t2, a3, zero	# 
	#add t3, a2, zero
	#add a0, zero, zero	# 몫 초기화 
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
