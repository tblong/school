;LCD Test
;  This program utilizes the C8051F330 microcontroller as
;  a test bench for LCD Display
;
;Author: Tyler Long
;Date:   Nov. 21 2007
;
;=====================================================================
;
;--assembler controls--------------------------------------------------
$DEBUG
$PAGEWIDTH(132)
$INCLUDE (C8051F330.INC)      	; use with SiLabs Keil A51 compiler
;$MOD330												; use with ASM51.EXE compiler
;
;--variable declarations-----------------------------------------------
;

;LCD pins
DB0 EQU P0.0
DB1 EQU P0.1
DB2 EQU P0.2
DB3 EQU P0.3
DB4 EQU P0.4
DB5 EQU P0.5
DB6 EQU P0.6
DB7 EQU P0.7

EN EQU P1.7 ;pin#9
RS EQU P1.6 ;pin#10
RW EQU P1.5 ;pin#11


PRINT EQU P0

;LCD Commands
DISP_FUNCTION_CMD EQU	00111100b	;Sets display 2line,display on
DISP_CURSOR_CMD		EQU	00001100b	;Turn on LCD and Cursor
DISP_AUTOSHIFT_CURSOR	EQU	00010100b	;Automatic move cursor right after send

;ADC SETUP
ENABLE_ADC	EQU 10000000b	;Enables ADC
ADC_CONFIG	EQU 11111100b	;Left justify ADC
ADC_VREF	  EQU 00001010b	;Defines Vdd as Vref
ADC_GND			EQU 00010001b	;Uses ground as negative
ADC_TEMP		EQU 00001011b	;Choses P1.3 for Temp 
ADC_STPT		EQU	00001100b	;Choses P1.4 for Setpoint
ADC_STARTCONVERT	EQU	10010000b	;Begins Conversion into ADC0H

;Timer 0 setup
TIMER0_16BIT	EQU	00000001b ;16-bit mode 


;
;=====================================================================
;  reset code
;=====================================================================

        ORG     00H             ; starting code memory location
        SJMP    MAIN            ; execute main code


;=====================================================================
;  main routine
;=====================================================================

        ORG     1BH             ; starting code memory location to jump
																; over INT vectors

        ;--test LED display-----------

        MAIN:   ANL   PCA0MD, #NOT(040h)  ; disable the WDT
			          MOV   XBR1, #40h  	      ; enable Crossbar

		            MOV   P0MDOUT, #01111111B        ; make LCD pin output push-pull
		            MOV   P0MDIN,  #11111111B        ; make LCD pin input mode digital

								MOV   P1MDOUT, #11100000B        ; make LCD EN,RS,RW pin output push-pull
		            MOV   P1MDIN,  #11100000B        ; make LCD EN,RS,RW pin input mode digital
								MOV		P1SKIP,  #00011000B				 ;Make digital xbar skip analog inputs
								MOV		OSCICN,  #10000000B				 ;Divide by 8 for 3.xx MHz SYSCLK
								MOV		OSCICL,  #01111111B				 ;SYSCLK Calibration (max is 7Fh) MSB is unused

								MOV		REF0CN,#ADC_VREF		;Defines Vdd as Vref
								MOV		ADC0CF,#ADC_CONFIG	;Left justify ADC
								MOV		ADC0CN,#ENABLE_ADC	;Enables ADC
								MOV		AMX0N, #ADC_GND			;Uses ground as negative

								MOV		TMOD,#TIMER0_16BIT	;16-bit mode



								LCALL INIT_LCD
								;LCALL TEMP
								;LCALL STPT

				TEMP:		
								MOV		AMX0P,#ADC_TEMP
								MOV		ADC0CN,#ADC_STARTCONVERT
								JNB		AD0INT,$
								MOV		R0,ADC0H
								CLR		AD0INT

								MOV	B,#03h	;Convert ADC value 0->255 to 0->85
								MOV	ACC,R0
								DIV	AB
								MOV	R0,ACC	;Replace register with hex temp
								MOV	B,#0Ah	;Convert to BCD
								DIV	AB
								ANL A,#0Fh
								ADD A,#30h
								MOV R2,ACC	;R2 used for ascii values for temp

								CLR RS										;Move cursor to 06H location
								CLR RW
								MOV PRINT,#80h + 06h
								SETB EN
								LCALL WAIT_ENABLE
								CLR EN
								LCALL WAIT_LCD

								LCALL WRITE_TEMP	;MSB

								MOV ACC,B
								ADD A,#30h
								MOV R2,ACC	;R2 used for ascii values for temp

								LCALL WRITE_TEMP	;LSB
	

								;R0 contains temp in hex to compare
								;R2 used for ascii values for temp
								
								;SJMP  TEMP

				STPT:		MOV		AMX0P,#ADC_STPT
								MOV		ADC0CN,#ADC_STARTCONVERT
								JNB		AD0INT,$
								MOV		R1,ADC0H
								CLR		AD0INT

								MOV	B,#03h	;Convert ADC value 0->255 to 0->85
								MOV	ACC,R1
								DIV	AB
								MOV	R1,ACC	;Replace register with hex temp
								MOV	B,#0Ah	;Convert to BCD
								DIV	AB
								ANL A,#0Fh
								ADD A,#30h
								MOV R3,ACC	;R3 used for ascii values for temp

								CLR RS										;Move cursor to 06H location
								CLR RW
								MOV PRINT,#80h + 46h
								SETB EN
								LCALL WAIT_ENABLE
								CLR EN
								LCALL WAIT_LCD

								LCALL WRITE_STPT	;MSB

								MOV ACC,B
								ADD A,#30h
								MOV R3,ACC	;R3 used for ascii values for temp

								LCALL WRITE_STPT	;LSB


								;R1 contains temp in hex to compare
								;R3 used for ascii values for temp


								SJMP  TEMP
								
								
								


				


;=====================================================================
;  Sub routine - Initialize LCD #1
;=====================================================================

				INIT_LCD:				  
								CLR RS										;Function Set
								CLR RW
								MOV PRINT,#DISP_FUNCTION_CMD
								SETB EN
								LCALL WAIT_ENABLE
								CLR EN
								LCALL WAIT_LCD


								CLR RS										;Turn on LCD and Cursor
								CLR RW
								MOV PRINT,#DISP_CURSOR_CMD
								SETB EN
								LCALL WAIT_ENABLE
								CLR EN
								LCALL WAIT_LCD

								CLR RS										;Automatic move cursor right after send
								CLR RW
								MOV PRINT,#DISP_AUTOSHIFT_CURSOR
								SETB EN
								LCALL WAIT_ENABLE
								CLR EN
								LCALL WAIT_LCD

								LCALL CLEAR_LCD
								
								;LCD test goes here - override all #FF
								MOV R4,#16
			LCDTEST1:	MOV ACC,#0FFH
								LCALL WRITE_TEXT								
								DJNZ	R4,LCDTEST1

								CLR RS										;Move cursor to 40H location
								CLR RW
								MOV PRINT,#80h + 40h
								SETB EN
								LCALL WAIT_ENABLE
								CLR EN
								LCALL WAIT_LCD

								MOV R4,#16
			LCDTEST2:	MOV ACC,#0FFH
								LCALL WRITE_TEXT								
								DJNZ	R4,LCDTEST2

								SETB	TR0		;Run Timer 0
								JNB	TF0,$		;Wait for overflow
								CLR TR0
								CLR TF0
								SETB 	TR0
								JNB	TF0,$

								LCALL CLEAR_LCD
				
								
								MOV A,#'T'
								LCALL WRITE_TEXT
								MOV A,#'E'
								LCALL WRITE_TEXT
								MOV A,#'M'
								LCALL WRITE_TEXT
								MOV A,#'P'
								LCALL WRITE_TEXT
								MOV A,#':'
								LCALL WRITE_TEXT

								CLR RS										;Move cursor to 08H location
								CLR RW
								MOV PRINT,#80h + 09h
								SETB EN
								LCALL WAIT_ENABLE
								CLR EN
								LCALL WAIT_LCD

								MOV A,#0DFH
								LCALL WRITE_TEXT
								MOV A,#'C'
								LCALL WRITE_TEXT

								CLR RS										;Move cursor to 40H location
								CLR RW
								MOV PRINT,#80h + 40h
								SETB EN
								LCALL WAIT_ENABLE
								CLR EN
								LCALL WAIT_LCD

								MOV A,#'S'
								LCALL WRITE_TEXT
								MOV A,#'T'
								LCALL WRITE_TEXT
								MOV A,#'P'
								LCALL WRITE_TEXT
								MOV A,#'T'
								LCALL WRITE_TEXT
								MOV A,#':'
								LCALL WRITE_TEXT

								CLR RS										;Move cursor to 48H location
								CLR RW
								MOV PRINT,#80h + 49h
								SETB EN
								LCALL WAIT_ENABLE
								CLR EN
								LCALL WAIT_LCD

								MOV A,#0DFH
								LCALL WRITE_TEXT
								MOV A,#'C'
								LCALL WRITE_TEXT
															
								;CLR RS										;Reset cursor to default 00H location
								;CLR RW
								;MOV PRINT,#80h+00h
								;SETB EN
								;LCALL WAIT_ENABLE
								;CLR EN
								;LCALL WAIT_LCD

								RET

;=====================================================================
;  Sub routine - Clear LCD
;=====================================================================

				CLEAR_LCD:
      					CLR RS
								CLR RW
					      MOV PRINT,#01h
					      SETB EN
								LCALL WAIT_ENABLE
					      CLR EN
					      LCALL WAIT_LCD
					      RET

;=====================================================================
;  Sub routine - Write text to LCD
;=====================================================================

				WRITE_TEXT:
					      SETB RS
								CLR RW
					      MOV PRINT,ACC
					      SETB EN
								LCALL WAIT_ENABLE
					      CLR EN
					      LCALL WAIT_LCD
					      RET

;=====================================================================
;  Sub routine - Write TEMP
;=====================================================================

				WRITE_TEMP:
					      SETB RS
								CLR RW
					      MOV PRINT,R2	;ASCII value
					      SETB EN
								LCALL WAIT_ENABLE
					      CLR EN
					      LCALL WAIT_LCD
					      RET

;=====================================================================
;  Sub routine - Write STPT
;=====================================================================

				WRITE_STPT:
					      SETB RS
								CLR RW
					      MOV PRINT,R3	;ASCII value
					      SETB EN
								LCALL WAIT_ENABLE
					      CLR EN
					      LCALL WAIT_LCD
					      RET

;=====================================================================
;  Sub routine - Wait for LCD
;=====================================================================

WAIT_LCD:
			MOV R7,#00H
			MOV PRINT,#0FFh ;Set all pins to FF initially

WAIT_BUSY:
			DEC	R7
			CJNE	R7,#01H,$+3
			JC	LCD_DONE

      CLR EN ;Start LCD command
      CLR RS ;It's a command
      SETB RW ;It's a read command
      SETB EN ;Clock out command to LCD
			MOV ACC,PRINT ;Read the return value
			JB ACC.7,WAIT_BUSY ;If bit 7 high, LCD still busy
			
LCD_DONE:
			CLR EN ;Finish the command
      CLR RW ;Turn off RW for future commands
      RET

;=====================================================================
;  Sub routine - Delay for LCD EN command
;=====================================================================

WAIT_ENABLE:
			MOV	ACC,#0FFh
COUNTDELAY:
			DJNZ ACC,COUNTDELAY

RET

END

