;$include (C8051F020.inc)
$include (C8051F330.inc)

LED		EQU		P1.3

		call	MAIN




MAIN:


		call	Init_Device
		mov		ACC,#01h	;Number of times to blink
		clr		LED
		

RELOAD:

		mov		TH0,#-128
		mov		TL0,#-128
		mov		R0,#01h			;Timer 0 repeats


START:

		setb	TR0				;Start Timer 0
		jnb		TF0,$			;Wait for overflow
		clr		TR0				;Stop Timer 0
		clr		TF0				;Clear overflow flag
		djnz	R0,START	;Restart Timer 0 if R0 !=zero
		dec		ACC				;
		cpl		LED
		jnz		RELOAD		;Blink again unless ACC=Zero


FINISH:

		setb		LED
		sjmp	$					;Lock up and Stop code
		




;------------------------------------
;-  Generated Initialization File  --
;------------------------------------

;$include (C8051F330.inc)

;public  Init_Device


; Peripheral specific initialization functions,
; Called from the Init_Device label
Timer_Init:
    mov  	TMOD,      #002h
		MOV		OSCICN,  #10000000B				 ;Divide by 8 for 3.xx MHz SYSCLK
		MOV		OSCICL,  #01111111B	
    ret

Port_IO_Init:
    ; P0.0  -  Unassigned,  Open-Drain, Digital
    ; P0.1  -  Unassigned,  Open-Drain, Digital
    ; P0.2  -  Unassigned,  Open-Drain, Digital
    ; P0.3  -  Unassigned,  Open-Drain, Digital
    ; P0.4  -  Unassigned,  Open-Drain, Digital
    ; P0.5  -  Unassigned,  Open-Drain, Digital
    ; P0.6  -  Unassigned,  Open-Drain, Digital
    ; P0.7  -  Unassigned,  Open-Drain, Digital

    ; P1.0  -  Unassigned,  Open-Drain, Digital
    ; P1.1  -  Unassigned,  Open-Drain, Digital
    ; P1.2  -  Unassigned,  Open-Drain, Digital
    ; P1.3  -  Unassigned,  Open-Drain, Digital
    ; P1.4  -  Unassigned,  Open-Drain, Digital
    ; P1.5  -  Unassigned,  Open-Drain, Digital
    ; P1.6  -  Unassigned,  Open-Drain, Digital
    ; P1.7  -  Unassigned,  Open-Drain, Digital

    mov  XBR1,      #040h
    ret

; Initialization function for device,
; Call Init_Device from your main program
Init_Device:
    lcall Timer_Init
    lcall Port_IO_Init
    ret
		end


