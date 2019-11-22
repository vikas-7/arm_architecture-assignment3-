;Below program implements neural network that take value as input in register R6,Based on the value of R6 it performs logical operations	
;Using the given Dataset value of X is computed which is used to calculate SIGMOID function, X value is stored in register S0.
;Now SIGMOID function is calculated and register S12 contains the value.

	area     Neural_network, CODE, READONLY
    IMPORT printMsg
	EXPORT __main
    ENTRY 
__main  FUNCTION
        
		MOV R6, #4				;REGISTER THAT STORES WHAT LOGIC IS TO BE IMPLEMENTED
		B Neural_Ntwrk
       
Neural_Ntwrk	
		CMP R6, #0
		BEQ LOGIC_AND
		CMP R6, #1
		BEQ LOGIC_OR
		CMP R6, #2
		BEQ LOGIC_NOT
		CMP R6, #3
		BEQ LOGIC_NAND
		CMP R6, #4
		BEQ LOGIC_NOR
		CMP R6, #5
		BEQ LOGIC_XOR
		CMP R6, #6
		BEQ LOGIC_XNOR
		BL DATASET
		BL COMPUTE


;LOGIC GATES
LOGIC_AND	VLDR.F32 S1, =-0.1			;S1=W1
			VLDR.F32 S2, =0.2			;S2=W2
			VLDR.F32 S3, =0.2			;S3=W3
			VLDR.F32 S4, =-0.2			;S4=BIAS
			B DATASET

LOGIC_OR	VLDR.F32 S1, =-0.1
			VLDR.F32 S2, =0.7
			VLDR.F32 S3, =0.7
			VLDR.F32 S4, =-0.1
			B DATASET
			
LOGIC_NOT	VLDR.F32 S1, =0.5
			VLDR.F32 S2, =-0.7
			VLDR.F32 S3, =0
			VLDR.F32 S4, =0.1
			B DATASET
			
LOGIC_NAND	VLDR.F32 S1, =0.6
			VLDR.F32 S2, =-0.8
			VLDR.F32 S3, =-0.8
			VLDR.F32 S4, =0.3
			B DATASET
			
LOGIC_NOR	VLDR.F32 S1, =0.5
			VLDR.F32 S2, =-0.7
			VLDR.F32 S3, =-0.7
			VLDR.F32 S4, =0.1
			B DATASET
			
LOGIC_XOR	VLDR.F32 S1, =-5
			VLDR.F32 S2, =20
			VLDR.F32 S3, =10
			VLDR.F32 S4, =1
			B DATASET
			
LOGIC_XNOR	VLDR.F32 S1, =-5
			VLDR.F32 S2, =20
			VLDR.F32 S3, =10
			VLDR.F32 S4, =1
			B DATASET
			
DATASET		VLDR.F32 S5, =1
			VLDR.F32 S6, =0
			VLDR.F32 S7, =0
			B COMPUTE
			
COMPUTE		VLDR.F32 S8, =0
			VMUL.F32 S1, S1, S5
			VMUL.F32 S2, S2, S6
			VMUL.F32 S3, S3, S7
			VADD.F32 S8, S1, S2
			VADD.F32 S8, S8, S3
			VADD.F32 S8, S8, S4
			VMOV.F32 S0, S8
			B CALC_SIG

CALC_SIG	MOV R0,#25;Holding the Number of Terms in Series 'n'
        MOV R1,#1;Counting Variable 'i'
        VLDR.F32 S9,=1;Holding the sum of series elements 's'
        VLDR.F32 S10,=1;Temp Variable to hold the intermediate series elements 't'
		VLDR.F32 S11,=1
		
LOOP1   CMP R1,R0;Compare 'i' and 'n' 
        BLE LOOP;if i < n goto LOOP
        B sigmoid;else goto stop
		
LOOP    VMUL.F32 S10,S10,S0; t = t*x
        VMOV.F32 S5,R1;Moving the bit stream in R1('i') to S5(floating point register)
        VCVT.F32.U32 S5, S5;Converting the bitstream into unsigned fp Number 32 bit
        VDIV.F32 S10,S10,S5;Divide t by 'i' and store it back in 't'
        VADD.F32 S9,S9,S10;Finally add 's' to 't' and store it in 's'
		ADD R1,R1,#1;Increment the counter variable 'i'
        B LOOP1;Again goto comparision
		
sigmoid  VADD.F32 S12,S9,S11 
		VDIV.F32 S12,S9,S12
		BL result
		
result	VLDR.F32 S13, =0.5
		VCMP.F32 S12, S13
		VMRS APSR_NZCV, FPSCR
		MOVGT R2, #1
		MOVLT R2, #0
		mov R0, R2
		BL printMsg
		B stop	


stop	B stop
        ENDFUNC
        END

