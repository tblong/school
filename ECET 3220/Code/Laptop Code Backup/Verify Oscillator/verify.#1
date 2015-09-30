;------------------------------------
;-  Generated Initialization File  --
;------------------------------------

$include (C8051F020.inc)


cseg at 0
jmp	main



main:
		mov  P0MDOUT,#02h
		mov  XBR2,#40h
		call Oscillator_Init
		call Timer_Init

		setb TR0

loop:
		jnb		TF0,loop
		cpl		P0.1
		clr		TF0
		sjmp	loop





;

;INIT SEGMENT CODE
 ;   rseg INIT

; Peripheral specific initialization functions,
; Called from the Init_Device label
Timer_Init:
    mov  CKCON,     #08h
    mov  TMOD,      #02h
    mov  TL0,       #-120
    mov  TH0,       #-120
    ret

Oscillator_Init:
    mov  OSCXCN,    #067h
    mov  R0,        #030        ; Wait 1ms for initialization
Osc_Wait1:
    clr  A
    djnz ACC,       $
    djnz R0,        Osc_Wait1
Osc_Wait2:
    mov  A,         OSCXCN
    jnb  ACC.7,     Osc_Wait2
    mov  OSCICN,    #008h
		ret

; Initialization function for device,
; Call Init_Device from your main program
END
