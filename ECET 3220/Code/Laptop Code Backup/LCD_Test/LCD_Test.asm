;=====================================================================
;  													Milestone #2
;
;Revision: R.07031336  (R.MMDDHHMM)
;
;Project Team Members:
; - Vince Watkins
; - Will Smith
; - Tyler Long
;
;
;
;
;
;=====================================================================

;=====================================================================
;   Assembler Controls
;=====================================================================

$DEBUG
;$OBJECT
$PRINT
	$SYMBOLS             ;Create Symbol table for list file
	$TITLE(MILESTONE #2)	
	$DATE(June-30-2008)
	$PAGEWIDTH(132)

;=====================================================================
;   Include Files
;=====================================================================

$include (C8051F020.inc)  ; use with SiLabs Keil A51 compiler

;=====================================================================
;   Variable declarations
;=====================================================================

;LCD Commands
DISP_CLR              EQU 00000001b ;Clears Disp & sets DDRAM addy to zero
DISP_FUNCTION_CMD     EQU 00111000b ;Sets disp to 8-bit & 5x10 chars.
DISP_ON               EQU 00001100b ;Turns disp ON,
DISP_CURSOR           EQU 00001111b ;Turns disp & cursor ON, cursor flashing
DISP_ENTRY_MODE       EQU 00000110b ;Sets cursor move direction
DISP_AUTOSHIFT_CURSOR EQU 00010100b ;Automatic move cursor right after send
DISP_BACKSPACE        EQU 00010000b ;Shifts cursor left
DISP_SHIFTRT          EQU 00011100b ;Shifts entire display Right

LCD_WRITE             EQU 1000h     ;LCD Write address RS=1 & RW=0
LCD_READ              EQU 1100h     ;LCD Read busy address RS=0 & RW =1
LCD_CMD               EQU 1200h     ;LCD Command address RS=0 & RW =0

;Keypad Commands
KEY_READ              EQU 4000h     ;Keypad read cmd addr. for DPTR


;=====================================================================
;   Reset code
;=====================================================================

    org  0000h
    ljmp Main

;=====================================================================
;   Interrupt Vectors
;=====================================================================

    org   0003h   ;/INT0 interrupt vector for Keypad
    ljmp  Key_ISR



;=====================================================================
;   Main Routine
;=====================================================================


    org   0030h

Main:
    lcall   Init_Device
    mov	    P1,#00h        ;Turns off all LEDs
    lcall   LCD_Init       ;Initialize LCD
		

;=====================================================================
;   Screen #1
;=====================================================================
		
    mov     DPTR,#LCD_CMD       ;Locates Cursor
    mov     ACC,#80h + 02h
    movx    @DPTR,A
    lcall   LCD_Busy

    mov     DPTR,#LCD_Initializing  ;1st Screen pointer
    mov     ACC,#00h            ;Points to first char. in string
    lcall   LCD_Print           ;Display 1st Screen

    lcall   LCD_Wait_3sec
    lcall   LCD_Clear

;=====================================================================
;   Screen #2
;=====================================================================

    mov	    DPTR,#LCD_CMD       ;Locates Cursor
    mov     ACC,#80h + 04h
    movx    @DPTR,A
    lcall   LCD_Busy

    mov     DPTR,#LCD_Pro_Tex   ;2st Screen pointer
    mov     ACC,#00h            ;Points to first char. in string
    lcall   LCD_Print           ;Display 2st Screen

    lcall   LCD_Wait_3sec
    lcall   LCD_Clear

;=====================================================================
;  Screen #3
;=====================================================================

    mov     DPTR,#LCD_CMD       ;Locates Cursor
    mov     ACC,#80h + 00h
    movx    @DPTR,A
    lcall   LCD_Busy

    mov     DPTR,#LCD_Password_Entry;3rd Screen pointer
    mov     ACC,#00h                ;Points to first char. in string
    lcall   LCD_Print               ;Display 3rd Screen

    lcall   LCD_Wait_3sec
    lcall   LCD_Clear

;=====================================================================
;   Screen #4
;=====================================================================


    ;4th Screen - 1st line


    mov     DPTR,#LCD_CMD     ;Locates Cursor
    mov     ACC,#80h + 00h
    movx    @DPTR,A
    lcall   LCD_Busy

    mov     DPTR,#LCD_Home    ;4th Screen pointer
    mov     ACC,#00h          ;Points to first char. in string
    lcall   LCD_Print         ;Display 4th Screen; 1st line

    ;4th Screen - 2nd line

    push    DPH
    push    DPL               ;Saves DPTR for next line in screen

    mov     DPTR,#LCD_CMD     ;Locates Cursor
    mov     ACC,#80h + 40h
    movx    @DPTR,A
    lcall   LCD_Busy

    pop     DPL
    pop     DPH               ;Restore next line for screen

    mov     ACC,#00h          ;offset for char in string 
                              ;00h=>1st char in string
    lcall   LCD_Print         ;Display 4th Screen; 2nd line

    ;4th Screen - 3rd line
		
    push    DPH
    push    DPL               ;Saves DPTR for next line in screen

    mov     DPTR,#LCD_CMD     ;Locates Cursor
    mov     ACC,#80h + 14h
    movx    @DPTR,A
    lcall   LCD_Busy

    pop     DPL
    pop     DPH               ;Restore next line for screen

    mov     ACC,#00h          ;offset for char in string 
                              ;00h=>1st char in string
    lcall   LCD_Print         ;Display 4th Screen; 3rd line

    ;4th Screen - 4th line
		
    push    DPH
    push    DPL               ;Saves DPTR for next line in screen

    mov     DPTR,#LCD_CMD     ;Locates Cursor
    mov     ACC,#80h + 54h
    movx    @DPTR,A
    lcall   LCD_Busy

    pop     DPL
    pop     DPH               ;Restore next line for screen

    mov     ACC,#00h          ;offset for char in string 
                              ;00h=>1st char in string
    lcall   LCD_Print         ;Display 4th Screen; 4th line

    lcall   LCD_Wait_3sec
    lcall   LCD_Clear

;=====================================================================
;   Screen #5
;=====================================================================


;5th Screen - 1st line

    mov     DPTR,#LCD_CMD     ;Locates Cursor
    mov     ACC,#80h + 00h
    movx    @DPTR,A
    lcall   LCD_Busy

    mov     DPTR,#LCD_Main_Menu ;5th Screen pointer
    mov     ACC,#00h            ;Points to first char. in string
    lcall   LCD_Print           ;Display 5th Screen; 1st line

    ;5th Screen - 2nd line

    push    DPH
    push    DPL              ;Saves DPTR for next line in screen

    mov     DPTR,#LCD_CMD    ;Locates Cursor
    mov     ACC,#80h + 40h
    movx    @DPTR,A
    lcall   LCD_Busy

    pop     DPL
    pop     DPH              ;Restore next line for screen
 
    mov     ACC,#00h         ;offset for char in string
                             ;00h=>1st char in string
    lcall   LCD_Print        ;Display 5th Screen; 2nd line

    ;5th Screen - 3rd line

    push    DPH
    push    DPL             ;Saves DPTR for next line in screen

    mov     DPTR,#LCD_CMD   ;Locates Cursor
    mov     ACC,#80h + 14h
    movx    @DPTR,A
    lcall   LCD_Busy

    pop     DPL
    pop     DPH             ;Restore next line for screen

    mov     ACC,#00h        ;offset for char in string 
                            ;00h=>1st char in string
    lcall   LCD_Print       ;Display 5th Screen; 3rd line

    ;5th Screen - 4th line
		
    push    DPH
    push    DPL             ;Saves DPTR for next line in screen

    mov     DPTR,#LCD_CMD   ;Locates Cursor
    mov     ACC,#80h + 54h
    movx    @DPTR,A
    lcall   LCD_Busy

    pop     DPL
    pop     DPH             ;Restore next line for screen

    mov     ACC,#00h        ;offset for char in string 
                            ;00h=>1st char in string
    lcall   LCD_Print       ;Display 5th Screen; 4th line

    lcall   LCD_Wait_3sec
    lcall   LCD_Clear
		
;=====================================================================
;   Screen #6
;=====================================================================

    mov     DPTR,#LCD_CMD     ;Locates Cursor
    mov     ACC,#80h + 00h
    movx    @DPTR,A
    lcall   LCD_Busy

    mov     DPTR,#LCD_Current_PW ;6th Screen pointer
    mov     ACC,#00h             ;Points to first char. in string
    lcall   LCD_Print            ;Display 3rd Screen


;=====================================================================
;   End of Screen displays
;=====================================================================
		
    mov   20h,#00h          ;Address 20h used for determining
                            ;Caps and function keys pressed
    lcall Key_Func_Blue         ;Starts with numbers as default, Blue LED
    mov   R0,#2             ;Enter key presses

    mov   DPTR,#LCD_CMD     ;LCD Command
    mov   ACC,#DISP_CURSOR  ;Shows & blinks cursor on 6th screen
    movx  @DPTR,A
    lcall LCD_Busy

    setb  EA                ;Global interrupts enabled on 6th screen
		

    sjmp   $

;=====================================================================
;   Sub routine - Keypad ISR
;
;Data is left in ACC after this ISR
;
;Registers
; - R0 - Decremented on each press of ENT key
;	-	R1 - Holds value to shift line1-->line2
;=====================================================================

Key_ISR:

    push    PSW
    push    DPH
    push    DPL
    push    ACC
    push    B

    mov	    DPTR,#KEY_READ
    movx    A,@DPTR
    anl     A,#0Fh          ;Bit mask
		
;Function key check
    jz      Key_Backspace   ;BS key pressed

;Enter key check
    push    ACC             ;save ACC with bit masked value
    clr     C
    subb    A,#08h          ;08h=Enter key
    jz      Key_Enter       ;ENT key pressed
    pop     ACC             ;Restore ACC from Bit masked value

;Caps Lock key check
    push    ACC             ;save ACC with bit masked value
    clr     C
    subb    A,#04h          ;04h=Caps lock key
    jz      Key_Caps        ;Caps lock key pressed
    pop     ACC             ;Restore ACC from Bit masked value

;Blue Function key check
    push    ACC             ;save ACC with bit masked value
    clr     C
    subb    A,#0Ch          ;0Ch=Blue key
    jz      Key_Blue        ;Blue key pressed
    pop     ACC             ;Restore ACC from Bit masked value

;Pink Function key check
    push    ACC             ;save ACC with bit masked value
    clr     C
    subb    A,#0Dh          ;0Dh=Pink key
    jz      Key_Pink        ;Pink key pressed
    pop     ACC             ;Restore ACC from Bit masked value

;Green Function key check
    push    ACC             ;save ACC with bit masked value
    clr     C
    subb    A,#0Eh          ;0Eh=Green key
    jz      Key_Green       ;Green key pressed
    pop     ACC             ;Restore ACC from Bit masked value

;Red Function key check
    push    ACC             ;save ACC with bit masked value
    clr     C
    subb    A,#0Fh          ;0Fh=Red key
    jz      Key_Red         ;Red key pressed
    pop     ACC             ;Restore ACC from Bit masked value


    lcall   Key_Func_Resolve ;Program reaches this point if no 
                             ;function keys pressed

                        ;Program returns with correct 
                        ;DPTR for functikon keys

    movc    A,@A + DPTR     ;Updates ACC w/ corresponding 
                        ;char. in lookup table


    mov     DPTR,#LCD_WRITE
    movx    @DPTR,A
    lcall   LCD_Busy
    jmp     Key_KeyRelease

Key_Caps:
    pop     ACC
    lcall   Key_Func_Caps
    jmp     Key_KeyRelease

Key_Blue:
    pop     ACC
    lcall   Key_Func_Blue
    jmp     Key_KeyRelease

Key_Pink:
    pop     ACC
    lcall   Key_Func_Pink
    jmp     Key_KeyRelease

Key_Green:
    pop     ACC
    lcall   Key_Func_Green
    jmp     Key_KeyRelease

Key_Red:
    pop     ACC
    lcall   Key_Func_Red
    jmp     Key_KeyRelease


Key_Backspace:
    mov     DPTR,#LCD_CMD
    mov     ACC,#DISP_BACKSPACE
    movx    @DPTR,A
    lcall   LCD_Busy

    mov     DPTR,#LCD_WRITE
    mov     ACC,#20h          ;space character
    movx    @DPTR,A
    lcall   LCD_Busy

    mov     DPTR,#LCD_CMD
    mov     ACC,#DISP_BACKSPACE
    movx    @DPTR,A
    lcall   LCD_Busy
    jmp     Key_KeyRelease

Key_Enter:
    pop     ACC               ;Restore ACC
    djnz    R0,Key_LCDline2
    lcall   LCD_Clear
    mov     R0,#02h           ;Reload again for ENT key presses
    jmp     Key_KeyRelease

Key_LCDline2:
    mov     R1,#20
    mov     DPTR,#LCD_CMD     ;Locates Cursor
    mov     ACC,#80h + 00h
    movx    @DPTR,A
    lcall   LCD_Busy

Key_Repeat:
    mov     DPTR,#LCD_CMD
    mov     ACC,#DISP_SHIFTRT
    movx    @DPTR,A
    push    ACC
    lcall   LCD_Busy
    pop     ACC
    djnz    R1,Key_Repeat
    jmp     Key_KeyRelease
		

Key_KeyRelease:
    jnb     P0.0,$    ;Wait for release of key

    pop     B
    pop     ACC
    pop     DPL
    pop     DPH
    pop     PSW

    reti

;=====================================================================
;   Sub routine - Caps lock Function Key
;
;Addresses:
; - 07h: Bit Used to determine caps lock function key pressed
; - 20h: General address location for function keys: caps lock & colors
;
;Registers:
; - ACC enters as 00h
;=====================================================================

Key_Func_Caps:
    cpl   07h
    cpl   P1.3	
    ret


;=====================================================================
;   Sub routine - Blue Function Key
;
;Addresses:
; - 00h: Bit Used to determine blue function key pressed
; - 20h: General address location for function keys: caps lock & colors
;=====================================================================

Key_Func_Blue:
    anl     20h,#0F0h   ;Bit mask to erase lower nibble for other 
                        ;function keys previously pressed
                        ;This also keeps the value of caps lock in tact.

    setb    00h         ;Sets LSB in addy 20h for blue func. key
    clr     P1.4        ;Turns off Red LED
    clr     P1.5        ;Turns off Green LED
    clr     P1.6        ;Turns off Pink LED
    setb    P1.7        ;Turns on Blue LED
    ret



;=====================================================================
;   Sub routine - Pink Function Key
;
;Addresses:
; - 01h: Bit Used to determine pink function key pressed
; - 20h: General address location for function keys: caps lock & colors
;=====================================================================

Key_Func_Pink:
    anl     20h,#0F0h   ;Bit mask to erase lower nibble for other
                        ;function keys previously pressed
                        ;This also keeps the value of caps lock in tact.

    setb    01h         ;Sets bit 1 in addy 20h for pink func. key
    clr     P1.4        ;Turns off Red LED
    clr     P1.5        ;Turns off Green LED
    setb    P1.6        ;Turns on Pink LED
    clr     P1.7        ;Turns off Blue LED
    ret

;=====================================================================
;   Sub routine - Green Function Key
;
;Addresses:
; - 02h: Bit Used to determine pink function key pressed
; - 20h: General address location for function keys: caps lock & colors
;=====================================================================

Key_Func_Green:
    anl     20h,#0F0h   ;Bit mask to erase lower nibble for other
                        ;function keys previously pressed
                        ;This also keeps the value of caps lock in tact.

    setb    02h         ;Sets bit 2 in addy 20h for green func. key
    clr     P1.4        ;Turns off Red LED
    setb    P1.5        ;Turns on Green LED
    clr     P1.6        ;Turns off Pink LED
    clr     P1.7        ;Turns off Blue LED
    ret

;=====================================================================
;  Sub routine - Red Function Key
;
;Addresses:
; - 03h: Bit Used to determine pink function key pressed
; - 20h: General address location for function keys: caps lock & colors
;=====================================================================

Key_Func_Red:
    anl     20h,#0F0h   ;Bit mask to erase lower nibble for other 
                        ;function keys previously pressed
                        ;This also keeps the value of caps lock in tact.

    setb    03h         ;Sets bit 3 in addy 20h for red func. key
    setb    P1.4        ;Turns on Red LED
    clr     P1.5        ;Turns off Green LED
    clr     P1.6        ;Turns off Pink LED
    clr     P1.7        ;Turns off Blue LED
    ret


;=====================================================================
;   Sub routine - Key input resolution
;
;Addresses:
; - 20h: Evaluates this addresed to determine funct. key & caps lock
;status.  Leave this sub with correct lookup table in DPTR.  When this
;sub is initially called, the ACC has the value of the key (according 
;to the actual value as determined by the keypad schematic) pressed.
;
;=====================================================================

Key_Func_Resolve:
    push    PSW
    push    ACC
    push    B
		
    ;Check Bit 00h for Blue function key, Numbers only
    jb      00h,Key_Func_Bluekey
    ;Check Bit 01h for Pink function key
    jb      01h,Key_Func_Pinkkey
    ;Check Bit 02h for Green function key
    jb      02h,Key_Func_Greenkey
    ;Check Bit 03h for Red function key
    jb      03h,Key_Func_Redkey

    jmp     Key_Func_Finish

Key_Func_Redkey:
    jnb     07h,$ + 8           ;07h=caps lock, jump to 
                                ;'Red_LC' if not caps lock
    mov     DPTR,#Key_Red_UpC   ;Red uppercase lookup table
    sjmp    Key_Func_Finish

    mov     DPTR,#Key_Red_LC    ;Red lowercase lookup table		
    jmp     Key_Func_Finish

Key_Func_Greenkey:
    jnb     07h,$ + 8           ;07h=caps lock, jump to 
                                ;'Green_LC' if not caps lock
    mov     DPTR,#Key_Green_UpC ;Green uppercase lookup table
    sjmp    Key_Func_Finish

    mov     DPTR,#Key_Green_LC  ;Green lowercase lookup table		
    jmp     Key_Func_Finish
		

Key_Func_Pinkkey:
    jnb     07h,$ + 8          ;07h=caps lock, jump to 
                               ;'Pink_LC' if not caps lock
    mov     DPTR,#Key_Pink_UpC ;Pink uppercase lookup table
    sjmp    Key_Func_Finish

    mov     DPTR,#Key_Pink_LC  ;Pink lowercase lookup table		
    jmp     Key_Func_Finish

Key_Func_Bluekey:
    mov     DPTR,#Key_Blue_Num
    jmp     Key_Func_Finish

Key_Func_Finish:
    pop     B
    pop     ACC
    pop     PSW

    ret


;=====================================================================
;   Sub routine - Initialize LCD
;=====================================================================

LCD_Init:
    mov   DPTR,#LCD_CMD
    mov   ACC,#DISP_FUNCTION_CMD
    movx  @DPTR,A
    lcall LCD_Busy

    mov   DPTR,#LCD_CMD
    mov   ACC,#DISP_ON
    movx  @DPTR,A
    lcall LCD_Busy

    mov   DPTR,#LCD_CMD
    mov   ACC,#DISP_ENTRY_MODE
    movx  @DPTR,A
    lcall LCD_Busy	

    lcall LCD_Clear

    ret

		
;=====================================================================
;   Sub routine - Prints string to LCD
;
;Enter subroutine with cursor in correct location, DPTR pointing at
;string to print, and ACC pointing to first location of string.
;
;=====================================================================

		
LCD_Print:
    push  PSW
    push  DPH
    push  DPL
    push  ACC
    push  B
    movc  A,@A + DPTR
    jz    LCD_Return      ;Null Character Reached
    mov   DPTR,#LCD_WRITE
    movx  @DPTR,A
    lcall LCD_Busy

LCD_Restore:
    pop   B
    pop   ACC
    pop   DPL
    pop   DPH
    pop   PSW
    inc   DPTR

    jmp   LCD_Print

LCD_Return:
    pop   B
    pop   ACC
    pop   DPL
    pop   DPH
    pop   PSW
    inc   DPTR       ;Leave sub with DPTR at next string in db

    ret

;=====================================================================
;   Sub routine - 3.0 second wait delay for screen transitions
;
;Registers used:
; - R0
;
;Timers used:
; - Timer0
;
;=====================================================================

LCD_Wait_3sec:
    mov     R0,#60    ;15=1sec.
    mov     TH0,#00h
    mov     TL0,#00h
    setb    TR0

LCD_Timer0_OV:
    jnb     TF0,LCD_Timer0_OV
    clr     TF0
    djnz    R0,LCD_Timer0_OV
    clr     TR0
    ret



;=====================================================================
;  Sub routine - Clear LCD
;=====================================================================

LCD_Clear:
    mov   DPTR,#LCD_CMD
    mov   ACC,#DISP_CLR
    movx  @DPTR,A
    lcall LCD_Busy
    ret

;=====================================================================
;  Sub routine - Wait for LCD
;=====================================================================

LCD_Busy:
    mov   DPTR,#LCD_READ
    movx  A,@DPTR
    JB    ACC.7,LCD_Busy  ;If bit 7 high, LCD still busy
    ret

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
    mov   TMOD,#001h
    ret

EMI_Init:
    mov   EMI0CF,#02Fh
    ret

Port_IO_Init:
    ; P0.0  -  INT0 (Tmr0), Push-Pull,  Digital
    ; P0.1  -  Unassigned,  Open-Drain, Digital
    ; P0.2  -  Unassigned,  Open-Drain, Digital
    ; P0.3  -  Unassigned,  Open-Drain, Digital
    ; P0.4  -  Unassigned,  Open-Drain, Digital
    ; P0.5  -  Unassigned,  Push-Pull,  Digital
    ; P0.6  -  Skipped,     Push-Pull,  Digital
    ; P0.7  -  Skipped,     Push-Pull,  Digital

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
    
    mov  P74OUT,    #0FFh
    mov  P0MDOUT,   #0E1h
    mov  P2MDOUT,   #0FFh
    mov  P3MDOUT,   #0FFh
    mov  XBR1,      #004h
    mov  XBR2,      #040h
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
    mov   IE,#001h
    ret


; Initialization function for device,
; Call Init_Device from your main program
Init_Device:
    lcall Reset_Sources_Init
    lcall Timer_Init
    lcall EMI_Init
    lcall Port_IO_Init
    lcall Oscillator_Init
    lcall Interrupts_Init
    ret

;------------------------------------
;-  LCD Screen Strings  --
;------------------------------------

LCD_Initializing:
    db "Initializing....",0

LCD_Pro_Tex:
    db "Pro-Tex 9000",0

LCD_Password_Entry:
    db "Enter PW:****",0

LCD_Home:
    db "Home",0
    db "Accel: X.Xg",0
    db "Accel STPT: X.Xg",0
    db "Press ",22h,"ENT",22h," for Menu",0

LCD_Main_Menu:
    db "Menu",0
    db "1. Arm/Dis",0
    db "2. Change Acc STPT",0
    db "3. Change PW",0

LCD_Current_PW:
    db "Enter Curr PW:****",0

;------------------------------------
;-  Keypad Lookup Tables  --
;------------------------------------

Key_Blue_Num:
    db 0,"3","2","1"
    db 0,"6","5","4"
    db 0,"9","8","7"

Key_Pink_LC:        ;Lower Case
    db 0,"u","t","s"
    db 0,"x","w","v"
    db 0,"0","z","y"

Key_Pink_UpC:       ;Upper Case
    db 0,"U","T","S"
    db 0,"X","W","V"
    db 0,"0","Z","Y"

Key_Green_LC:       ;Lower Case
    db 0,"l","k","j"
    db 0,"o","n","m"
    db 0,"r","q","p"

Key_Green_UpC:      ;Upper Case
    db 0,"L","K","J"
    db 0,"O","N","M"
    db 0,"R","Q","P"

Key_Red_LC:         ;Lower Case
    db 0,"c","b","a"
    db 0,"f","e","d"
    db 0,"i","h","g"

Key_Red_UpC:        ;Upper Case
    db 0,"C","B","A"
    db 0,"F","E","D"
    db 0,"I","H","G"


end
