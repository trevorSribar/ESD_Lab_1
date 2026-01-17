; Authors :Trevor Sribar
; Course Name :- ECEN 5613 
; Date :- 1/16/26
		ORG 0000H          ; Reset vector	
START:
		MOV 0x20, A			;Copies the Accumulator(X) to 0x20
		RL A             	;Rotates Accumulator Left (multiplies by 2)
		RL A			 	;Rotates the Accumulator Left (multiplies by 2)
		MOV 0x21, A		 	;Copies the Accumulator(4*X) to 0x21
		ANL A, #0x03			;Ands the Accumulator (shifted X with 00..0011), should be 0 if non-error
		JZ NO_X_ERROR		;If the accumulator is zero, we skip error handling
;Error cuz X was too big
		MOV 0x30, #0x02		;Set the error location to 0x02
		LJMP INFINITE_LOOP	;Jumps to infinte loop
		
NO_X_ERROR:
		MOV A, B			;Moves the B register to the A register
		JNZ NO_Y_ERROR		;If Y is not 0, we skip error handling
;Error cuz Y is 0
		MOV 0x30, #0x01		;Set the error location to 0x02
		LJMP INFINITE_LOOP	;Jumps to infinte loop
		
NO_Y_ERROR:
		MOV 0x22, A			;Copies the Accumulator(Y) to 0x22
		MOV 0x23, #0x00		;Sets the quotient location (0x23) to 0, initializing for loop
		MOV A, 0x21			;Sets the accumulator to 4*X, initializing for loop
		
LOOP: ;In this loop, we set a "W" which is 4X-(*0x23)*Y
		SUBB A, B			;A now holds W-Y
		JC SAVING_REMAINDER	;If we have had overflow from subtraction (carry has been set), we are done with division
		INC 0x23			;If we didn't overflow, increment the Quotient
        LJMP LOOP			;Go to next round
 
SAVING_REMAINDER:
		ADD A, B			;We had A go to a negitive number, so we need to add Y back in order to get it to the actual remainder
		MOV 0x24, A			;Sets 0x24 to the remainder
		MOV 0x30, 0x00		;Says we did not get an error during our operation

INFINITE_LOOP:
        SJMP INFINITE_LOOP          ; Infinite loop after completion
 
        END