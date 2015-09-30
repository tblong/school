;=====================================================================
;                             Pro-Tex 9000
;
;Revision: R.07031336  (R.MMDDHHMM)
;
;Project Team Members:
; - Vince Watkins
; - Will Smith
; - Tyler Long
;
;
;Initialization Routines
;
;
;=====================================================================


;------------------------------------
;-  Generated Initialization File  --
;------------------------------------


; Peripheral specific initialization functions,
; Called from the Init_Device label
Reset_Sources_Init:
    mov   WDTCN,#0DEh
    mov   WDTCN,#0ADh
    ret

Timer_Init:
    mov  CKCON,#040h
    mov  TMOD,#011h
    mov  T4CON,#034h
    mov  RCAP4L,#0FCh
    mov  RCAP4H,#0FFh
    ret

UART_Init:
    mov  PCON,#010h
    mov  SCON1,#040h
    ret

EMI_Init:
    mov  EMI0CF,#02Fh
    mov  EMI0TC,#0EFh  ;/WR & /RD = 12 SYSCLK cycles
    ret


Port_IO_Init:
    ; P0.0  -  TX1 (UART1), Push-Pull,  Digital
    ; P0.1  -  RX1 (UART1), Push-Pull,  Digital
    ; P0.2  -  INT0 (Tmr0), Push-Pull,  Digital, Keypad Int.
    ; P0.3  -  INT1 (Tmr1), Push-Pull,  Digital, Alm Int.
    ; P0.4  -  Unassigned,  Push-Pull,  Digital
    ; P0.5  -  Unassigned,  Push-Pull,  Digital
    ; P0.6  -  Unassigned,  Push-Pull,  Digital
    ; P0.7  -  Unassigned,  Push-Pull,  Digital

    ; P1.0  -  Unassigned,  Open-Drain, Digital
    ; P1.1  -  Unassigned,  Open-Drain, Digital
    ; P1.2  -  Unassigned,  Open-Drain, Digital
    ; P1.3  -  Unassigned,  Open-Drain, Digital
    ; P1.4  -  Unassigned,  Open-Drain, Digital
    ; P1.5  -  Unassigned,  Open-Drain, Digital
    ; P1.6  -  Unassigned,  Open-Drain, Digital
    ; P1.7  -  Unassigned,  Open-Drain, Digital

    ; P2.0  -  Unassigned,  Push-Pull,  Digital
    ; P2.1  -  Unassigned,  Push-Pull,  Digital
    ; P2.2  -  Unassigned,  Push-Pull,  Digital
    ; P2.3  -  Unassigned,  Push-Pull,  Digital
    ; P2.4  -  Unassigned,  Push-Pull,  Digital
    ; P2.5  -  Unassigned,  Push-Pull,  Digital
    ; P2.6  -  Unassigned,  Push-Pull,  Digital
    ; P2.7  -  Unassigned,  Push-Pull,  Digital

    ; P3.0  -  Unassigned,  Push-Pull,  Digital
    ; P3.1  -  Unassigned,  Push-Pull,  Digital
    ; P3.2  -  Unassigned,  Push-Pull,  Digital
    ; P3.3  -  Unassigned,  Push-Pull,  Digital
    ; P3.4  -  Unassigned,  Push-Pull,  Digital
    ; P3.5  -  Unassigned,  Push-Pull,  Digital
    ; P3.6  -  Unassigned,  Push-Pull,  Digital
    ; P3.7  -  Unassigned,  Push-Pull,  Digital

    mov  P0MDOUT,   #0FFh
    mov  P2MDOUT,   #0FFh
    mov  P3MDOUT,   #0FFh
    mov  P74OUT,    #0FFh
    mov  XBR1,      #014h
    mov  XBR2,      #044h
    ret


Oscillator_Init:
    mov   OSCXCN,#067h
    mov   R0,#030       ; Wait 1ms for initialization
Osc_Wait1:
    clr   A
    djnz  ACC,$
    djnz  R0,Osc_Wait1
Osc_Wait2:
    mov   A,OSCXCN
    jnb   ACC.7,Osc_Wait2
    mov   OSCICN,#008h
    ret

Interrupts_Init:
    mov  IE,#080h
    mov  IP,#008h
    ret


; Initialization function for device,
; Call Init_Device from your main program
Init_Device:
    lcall Reset_Sources_Init
    lcall Timer_Init
    lcall UART_Init
    lcall EMI_Init
    lcall Port_IO_Init
    lcall Oscillator_Init
    lcall Interrupts_Init
    ret


