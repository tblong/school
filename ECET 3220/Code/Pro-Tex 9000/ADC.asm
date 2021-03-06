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
;=ADC Subroutines=
;
;'ADC_Read' & 'ADC_Kick'subroutines will be called from the Main.asm.
;The DPTR shall have the proper location to either read from 
;or kick start the ADC.  Call 'ADC_Init' routine to kick start the
;ADC.
;
;Addresses Used:
; - 22h: 8051 scratch pad RAM location used to store the ADC value on
;        exit of    
;
;Registers Used:
; 
;=====================================================================


;=====================================================================
;   Variable declarations
;=====================================================================

;ADC Commands
ADC_KICK      EQU 3800h     ;Kick start address for ADC
ADC_READ      EQU 3000h     ;Read address for ADC    




;=====================================================================
;   Sub routine - ADC gets current accleration
;
;
;This sub gets the current accleration and writes that value to the
;LCD if in State_06, else it just keeps the current value from the
;ADC stored in address 22h.  This sub will be called based upon an
;overflow of 
;
;
;Registers:
; - R1: Points to current state (21h)
;=====================================================================

ADC_GetAcc:
    push    PSW
    push    DPH
    push    DPL
    push    ACC
    push    B


    mov   DPTR,#ADC_KICK    ;
    movx  @DPTR,A           ;Kick starts ADC to convert

ADC_Delay_Init:
    mov   R3,#245          ;
ADC_Delay_Loop:    
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz    R3,ADC_Delay_Loop
           

    mov   DPTR,#ADC_READ    ;
    movx  A,@DPTR           ;Get current Acceleration
    mov   22h,A             ;Store ADC value in stratch RAM


ADC_State_Chk:
    


    lcall   ADC_Convert     ;Sub which converts 0-255 value from accel
                            ;into correct DPTR for lookup table

    
        
    lcall   RAM_Write_ADC   ;Write string to ext RAM starting
                            ;at address loc. 2004h

    lcall   ADC_Compare     ;compare here for alarm condition vs. STPT
    
    

    cjne    @R1,#06,ADC_Finished  ;If State=06 then convert and print
                                  ;ADC value to LCD

    
    push    DPH
    push    DPL

    mov     DPTR,#LCD_CMD        ;Locates Cursor
    mov     ACC,#80h + 47h
    movx    @DPTR,A
    lcall   LCD_Busy

    pop     DPL
    pop     DPH

    mov     ACC,#00h            ;First char in string
    lcall LCD_Print

ADC_Finished:

    pop     B
    pop     ACC
    pop     DPL
    pop     DPH
    pop     PSW

    reti


;=====================================================================
;   Sub routine - ADC Convert
;
;DPTR exits this routine pointing to the first letter in string
;assuming the ACC is @ zero when using the 'movc A,@A + DPTR' command.
;
;Registers:
; - ACC: The ACC on entry into sub ='s the value from the ADC: 0-255
; - B: This ='s the number of characters in each string (07h)
; - R3: Used to manipulate the value of the B register
;
;=====================================================================

ADC_Convert:

    mov   DPTR,#ADC_AccelTable    ;Acceleration lookup table 
    mov   B,#07h                  ;Num of Char. per string
    mul   AB                      ;Get num of times to increment DPTR
                                  ;for correct location in table
    mov   R3,B

ADC_Convert_CheckACC:
    jz      ADC_Convert_CheckR3   ;if ACC=00h then check B
    dec     ACC
    inc     DPTR
    jmp     ADC_Convert_CheckACC    

ADC_Convert_CheckR3:
    cjne    R3,#01h,$ + 3
    jc      ADC_Convert_Finish    ;if B=00h then exit
    dec     R3
    dec     ACC
    inc     DPTR
    jmp     ADC_Convert_CheckACC   

ADC_Convert_Finish:
    ret

;=====================================================================
;   Sub routine - ADC Compare
;
;DPTR exits this routine pointing to the first letter in string
;assuming the ACC is @ zero when using the 'movc A,@A + DPTR' command.
;
;Registers:
; - ACC: Returns with the LSB of the actual Acceleration.
; - 27h: MSB of the Setpoint in Ascii
; - 26h: Next Byte of the Setpoint in Ascii
; - 25h: LSB of the Setpoint in Ascii
;
;=====================================================================

ADC_Compare:

    push  DPH
    push  DPL

    mov		DPTR,#2005h
		movx	A,@DPTR
		cjne	A,27h,ADC_Carry1

		mov		DPTR,#2007h
		movx	A,@DPTR
		cjne	A,26h,ADC_Carry2
    
		mov		DPTR,#2008h
		movx	A,@DPTR
		cjne	A,25h,ADC_Carry3
		

ADC_Compare_Finish:
    
    pop  DPL
    pop  DPH

    ret

ADC_Carry1:

		jc		ADC_Compare_Finish
		lcall	ADC_Serial_Print
		sjmp	ADC_Compare_Finish

ADC_Carry2:

		jc		ADC_Compare_Finish
		lcall	ADC_Serial_Print
		sjmp	ADC_Compare_Finish

ADC_Carry3:

		jc		ADC_Compare_Finish
		lcall	ADC_Serial_Print
		sjmp	ADC_Compare_Finish



;=====================================================================
;   Sub routine - ADC_Alarm: This routine will print an Alarm string
;   if the Acceleration Setpoint is less than the actual Acceleration
;
;
; 
;=====================================================================

ADC_Serial_Print:
    jb    19h,ADC_Serial_Finish   ;Only allows for one String to print
    mov   DPTR,#ADC_Alarm_Table
    mov   A,#00h
ADC_Ser_Loop:
    mov   A,#00h
    movc  A,@A + DPTR
    jz    ADC_Print_Accel         ;Print the Acceleration if Null ACC
    mov   SBUF1,A                 ;Moves first Character to serial port

    mov   A,SCON1
    jnb   ACC.1,$ - 2             ;Poll for Transmit flag
    mov   SCON1,#40h              ;Clear Transmit Flag
    inc   DPTR                    ;Point to next character in string
  
    sjmp  ADC_Ser_Loop

ADC_Print_Accel:

    mov   DPTR, #2004h            ;Load the location of the first Char.
ADC_Ser_Loop2:
    movx  A,@DPTR                 ;Bring in Char from RAM
    jz    ADC_Serial_Finish       ;Jump to end if Null hit in RAM
    mov   SBUF1, A                ;Start Serial Transmission
    mov   A,SCON1                 
    jnb   ACC.1,$ - 2             ;Poll for Transmit Flag
    mov   SCON1,#40h              ;Clear Transmit Flag
    inc   DPTR                    ;Point to next Location in RAM
    sjmp  ADC_Ser_Loop2    

ADC_Serial_Finish:
    setb  19h
    ret

ADC_Alarm_Table:
    db "************************",0Dh,0Ah
    db "*  Acceleration Alarm  *",0Dh,0Ah
    db "************************",0Dh,0Ah,0

ADC_AccelTable:
  db "-1.20g",0
  db "-1.19g",0
  db "-1.18g",0
  db "-1.17g",0
  db "-1.16g",0
  db "-1.15g",0
  db "-1.14g",0
  db "-1.13g",0
  db "-1.12g",0
  db "-1.11g",0
  db "-1.10g",0
  db "-1.09g",0
  db "-1.08g",0
  db "-1.07g",0
  db "-1.06g",0
  db "-1.05g",0
  db "-1.04g",0
  db "-1.03g",0
  db "-1.02g",0
  db "-1.01g",0
  db "-1.00g",0
  db "-0.99g",0
  db "-0.98g",0
  db "-0.97g",0
  db "-0.96g",0
  db "-0.95g",0
  db "-0.94g",0
  db "-0.93g",0
  db "-0.92g",0
  db "-0.91g",0
  db "-0.90g",0
  db "-0.89g",0
  db "-0.88g",0
  db "-0.87g",0
  db "-0.86g",0
  db "-0.85g",0
  db "-0.84g",0
  db "-0.83g",0
  db "-0.82g",0
  db "-0.81g",0
  db "-0.80g",0
  db "-0.79g",0
  db "-0.78g",0
  db "-0.77g",0
  db "-0.76g",0
  db "-0.75g",0
  db "-0.74g",0
  db "-0.73g",0
  db "-0.72g",0
  db "-0.71g",0
  db "-0.70g",0
  db "-0.69g",0
  db "-0.68g",0
  db "-0.67g",0
  db "-0.66g",0
  db "-0.65g",0
  db "-0.64g",0
  db "-0.63g",0
  db "-0.62g",0
  db "-0.61g",0
  db "-0.60g",0
  db "-0.59g",0
  db "-0.58g",0
  db "-0.57g",0
  db "-0.56g",0
  db "-0.55g",0
  db "-0.54g",0
  db "-0.53g",0
  db "-0.52g",0
  db "-0.51g",0
  db "-0.50g",0
  db "-0.49g",0
  db "-0.48g",0
  db "-0.47g",0
  db "-0.46g",0
  db "-0.45g",0
  db "-0.44g",0
  db "-0.43g",0
  db "-0.42g",0
  db "-0.41g",0
  db "-0.40g",0
  db "-0.39g",0
  db "-0.38g",0
  db "-0.37g",0
  db "-0.36g",0
  db "-0.35g",0
  db "-0.34g",0
  db "-0.33g",0
  db "-0.32g",0
  db "-0.31g",0
  db "-0.30g",0
  db "-0.29g",0
  db "-0.28g",0
  db "-0.27g",0
  db "-0.26g",0
  db "-0.25g",0
  db "-0.24g",0
  db "-0.23g",0
  db "-0.22g",0
  db "-0.21g",0
  db "-0.20g",0
  db "-0.19g",0
  db "-0.18g",0
  db "-0.17g",0
  db "-0.16g",0
  db "-0.15g",0
  db "-0.14g",0
  db "-0.13g",0
  db "-0.12g",0
  db "-0.11g",0
  db "-0.10g",0
  db "-0.09g",0
  db "-0.08g",0
  db "-0.07g",0
  db "-0.06g",0
  db "-0.05g",0
  db "-0.04g",0
  db "-0.03g",0
  db "-0.02g",0
  db "-0.01g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db " 0.00g",0
  db "+0.01g",0
  db "+0.02g",0
  db "+0.03g",0
  db "+0.04g",0
  db "+0.05g",0
  db "+0.06g",0
  db "+0.07g",0
  db "+0.08g",0
  db "+0.09g",0
  db "+0.10g",0
  db "+0.11g",0
  db "+0.12g",0
  db "+0.13g",0
  db "+0.14g",0
  db "+0.15g",0
  db "+0.16g",0
  db "+0.17g",0
  db "+0.18g",0
  db "+0.19g",0
  db "+0.20g",0
  db "+0.21g",0
  db "+0.22g",0
  db "+0.23g",0
  db "+0.24g",0
  db "+0.25g",0
  db "+0.26g",0
  db "+0.27g",0
  db "+0.28g",0
  db "+0.29g",0
  db "+0.30g",0
  db "+0.31g",0
  db "+0.32g",0
  db "+0.33g",0
  db "+0.34g",0
  db "+0.35g",0
  db "+0.36g",0
  db "+0.37g",0
  db "+0.38g",0
  db "+0.39g",0
  db "+0.40g",0
  db "+0.41g",0
  db "+0.42g",0
  db "+0.43g",0
  db "+0.44g",0
  db "+0.45g",0
  db "+0.46g",0
  db "+0.47g",0
  db "+0.48g",0
  db "+0.49g",0
  db "+0.50g",0
  db "+0.51g",0
  db "+0.52g",0
  db "+0.53g",0
  db "+0.54g",0
  db "+0.55g",0
  db "+0.56g",0
  db "+0.57g",0
  db "+0.58g",0
  db "+0.59g",0
  db "+0.60g",0
  db "+0.61g",0
  db "+0.62g",0
  db "+0.63g",0
  db "+0.64g",0
  db "+0.65g",0
  db "+0.66g",0
  db "+0.67g",0
  db "+0.68g",0
  db "+0.69g",0
  db "+0.70g",0
  db "+0.71g",0
  db "+0.72g",0
  db "+0.73g",0
  db "+0.74g",0
  db "+0.75g",0
  db "+0.76g",0
  db "+0.77g",0
  db "+0.78g",0
  db "+0.79g",0
  db "+0.80g",0
  db "+0.81g",0
  db "+0.82g",0
  db "+0.83g",0
  db "+0.84g",0
  db "+0.85g",0
  db "+0.86g",0
  db "+0.87g",0
  db "+0.88g",0
  db "+0.89g",0
  db "+0.90g",0
  db "+0.91g",0
  db "+0.92g",0
  db "+0.93g",0
  db "+0.94g",0
  db "+0.95g",0
  db "+0.96g",0
  db "+0.97g",0
  db "+0.98g",0
  db "+0.99g",0
  db "+1.00g",0
  db "+1.01g",0
  db "+1.02g",0
  db "+1.03g",0
  db "+1.04g",0
  db "+1.05g",0
  db "+1.06g",0
  db "+1.07g",0
  db "+1.08g",0
  db "+1.09g",0
  db "+1.10g",0
  db "+1.11g",0
  db "+1.12g",0
  db "+1.13g",0
  db "+1.14g",0
  db "+1.15g",0
  db "+1.16g",0
  db "+1.17g",0
  db "+1.18g",0
  db "+1.19g",0
  db "+1.20g",0