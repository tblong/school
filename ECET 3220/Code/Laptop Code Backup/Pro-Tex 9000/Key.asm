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
;Keypad Subroutines
;
;
;=====================================================================

;=====================================================================
;   Variable declarations
;=====================================================================

;Keypad Commands
KEY_READ              EQU 4000h     ;Keypad read cmd addr. for DPTR





;=====================================================================
;   Sub routine - Keypad ISR
;
;Data is left in ACC after this ISR
;
;Registers
; - R1: Determines BS/non_Func key presses allowed
;
;=====================================================================

Key_ISR:

    push    PSW
    push    DPH
    push    DPL
    push    ACC
    push    B
    
   ; jnb     19h,test   ;Timer0 status
    ;setb    TF0   ;Fake out program on return to TF0 in ADC.asm

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


    lcall   Key_State_Chk    ;Program reaches this point if no 
                             ;function keys pressed

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
    lcall   Key_Func_BS
    jmp     Key_KeyRelease

Key_Enter:
    pop     ACC               ;Restore ACC
    lcall   Key_Func_Ent      ;go to check state
    jmp     Key_KeyRelease
		

Key_KeyRelease:
    jnb     P0.2,$    ;Wait for release of key /INT0

    pop     B
    pop     ACC
    pop     DPL
    pop     DPH
    pop     PSW

    reti

;=====================================================================
;   Sub routine - Enter Function Key valid state check
;
;This routine determines if the current state allows for 
;the enter key to be pressed.
;
;Addresses:
; - 21h: Checks for state when Enter key ok to press
;
;Registers:
; - R1: Points to current state (21h)
;=====================================================================

Key_Func_Ent:
    cjne    @R1,#02h,Key_Func_Ent_01      ;Check for State_02h
    lcall   RAM_Read_PW                   ;Get current PW from RAM
    lcall   Key_PW_Check_02h              ;compare PW
    jmp     Key_Func_Ent_Finish
    
Key_Func_Ent_01:
    cjne    @R1,#03h,Key_Func_Ent_02      ;Check for State_03h
    lcall   RAM_Read_PW                   ;Get current PW from RAM
    lcall   Key_PW_Check_03h              ;compare PW
    jmp     Key_Func_Ent_Finish

Key_Func_Ent_02:
    cjne    @R1,#04h,Key_Func_Ent_03      ;Check for State_04h
    lcall   RAM_Read_PW                   ;Get current PW from RAM
    lcall   Key_PW_Check_04h              ;compare PW
    jmp     Key_Func_Ent_Finish

Key_Func_Ent_03:
    cjne    @R1,#06h,Key_Func_Ent_04      ;Check for State_06h
    mov     A,#07h                        ;Go to State_07h
    lcall   State_Lookup                  ;Initiate State_07h
    jmp     Key_Func_Ent_Finish

Key_Func_Ent_04:
    cjne    @R1,#07h,Key_Func_Ent_05      ;Check for State_07h
    mov     A,#06h                        ;Go to State_06h
    lcall   State_Lookup                  ;Initiate State_06h
    jmp     Key_Func_Ent_Finish

Key_Func_Ent_05:
    cjne    @R1,#0Ah,Key_Func_Ent_06      ;Check for State_0Ah
    lcall   RAM_Read_PW                   ;Get current PW from RAM
    lcall   Key_PW_Check_0Ah              ;compare PW
    jmp     Key_Func_Ent_Finish

Key_Func_Ent_06:
    cjne    @R1,#0Ch,Key_Func_Ent_07      ;Check for State_0Ch
    lcall   RAM_Read_PW                   ;Get current PW from RAM
    lcall   Key_PW_Check_0Ch              ;compare PW
    jmp     Key_Func_Ent_Finish

Key_Func_Ent_07:
    cjne    @R1,#0Dh,Key_Func_Ent_08      ;Check for State_0Dh
    lcall   RAM_Read_PW                   ;Get current PW from RAM
    lcall   Key_PW_Check_0Dh              ;compare PW
    jmp     Key_Func_Ent_Finish

Key_Func_Ent_08:
    cjne    @R1,#08h,Key_Func_Ent_09      ;Check for State_08h
    mov     A,#07h                        ;Go to State_07h
    lcall   State_Lookup                  ;Initiate State_07h
    jmp     Key_Func_Ent_Finish

Key_Func_Ent_09:
    cjne    @R1,#11h,Key_Func_Ent_10      ;Check for State_11h
    lcall   RAM_Read_PW                   ;Get current PW from RAM
    lcall   Key_PW_Check_11h              ;compare PW
    jmp     Key_Func_Ent_Finish

Key_Func_Ent_10:
    cjne    @R1,#12h,Key_Func_Ent_11      ;Check for State_12h
    lcall   RAM_Read_PW                   ;Get current PW from RAM
    lcall   Key_PW_Check_12h              ;compare PW
    jmp     Key_Func_Ent_Finish

Key_Func_Ent_11:
    cjne    @R1,#13h,Key_Func_Ent_12      ;Check for State_13h
    lcall   RAM_Read_PW                   ;Get current PW from RAM
    lcall   Key_PW_Check_13h              ;compare PW
    jmp     Key_Func_Ent_Finish

Key_Func_Ent_12:
    cjne    @R1,#14h,Key_Func_Ent_13      ;Check for State_13h
    lcall   RAM_Write_PW                  ;Update RAM w/ new PW
    mov     A,#15h                        ;Go to State_15h
    lcall   State_Lookup
    jmp     Key_Func_Ent_Finish

Key_Func_Ent_13:
    cjne    @R1,#0Eh,Key_Func_Ent_Finish  ;Check for State_0Eh
    lcall   Key_Accel_Valid_Check               ;
    jmp     Key_Func_Ent_Finish
    
        
Key_Func_Ent_Finish:    	
    ret

;=====================================================================
;   Sub routine - State 0E Valid Acceleration STPT Check
;
;This sub branches to either State 10h or 0Fh based on a valid
;setpoint being entered.
;
;Addresses:
; - 21h: Checks for state when Enter key ok to press
; - 27h: MSB for Accel STPT
; - 26h: Next byte for Accel STPT
; - 25h: LSB for Accel STPT
;
;Registers:
; - R1: Points to current state (21h)  
;=====================================================================

Key_Accel_Valid_Check:
    

    mov   A,27h                   ;MSB Accel STPT entered from RAM
    cjne  A,#32h,$ + 3            ;1's digit greater than 1?
    jnc	  Key_Accel_Invalid       ;Load invalid STPT state
    
    cjne  A,#31h,$ + 3            ;1's digit 0 or 1?
    jc    Key_Accel_Easy          ;Jump if 1's digit ='s 0
                                  ;else 1's digit ='s 1
    
    mov   A,26h			  ;tenth's Accel byte
    cjne  A,#33h,$ + 3            ;Tenth's digit > 2?
    jnc	  Key_Accel_Invalid	  ;Tenth's digit too high
    
    cjne  A,#32h,$ + 3		  ;Tenth's digit = 2?
    jnc   Key_Accel_Easy1         ;Tenth's digit = 2
    jmp   Key_Accel_Easy2         ;Tenth's digit < 2
    
    
Key_Accel_Easy:  ;1's digit ='s 0
    mov   A,26h
    cjne  A,#40h,$ + 3            ;
    jnc   Key_Accel_Invalid       ;Tenth's digit >=40h
    
    mov   A,25h
    cjne  A,#40h,$ + 3  
    jnc	  Key_Accel_Invalid       ;100's digit >=40h
    jmp   Key_Accel_Valid         ;else jump to valid state
    
Key_Accel_Easy1:  ;1's digit ='s 1 & 10's=2
    mov   A,25h
    cjne  A,#31h,$ + 3  
    jnc	  Key_Accel_Invalid       ;100's digit >=40h
    jmp   Key_Accel_Valid         ;else jump to valid state    

Key_Accel_Easy2:  ;1's digit ='s 1 & 10's < 2        
    mov   A,25h
    cjne  A,#40h,$ + 3  
    jnc	  Key_Accel_Invalid       ;100's digit >=40h
    jmp   Key_Accel_Valid         ;else jump to valid state

Key_Accel_Valid:
    mov   A,#0Fh                  ;State 0Fh
    lcall State_Lookup
    jmp   Key_Accel_Valid_Finish  ;Program returns here once the state
                                  ;machine is finished

Key_Accel_Invalid:
    mov   A,#10h                  ;State 10h
    lcall State_Lookup
    jmp   Key_Accel_Valid_Finish  ;Program returns here once the state
                                  ;machine is finished
    
Key_Accel_Valid_Finish:    	
    ret                           ;ret to ENT key state check


;=====================================================================
;   Sub routine - State 13h Password check
;
;This routine determines if the entered password matches that of the
;one stored in RAM.
;
;Addresses:
; - 21h: Checks for state when Enter key ok to press
;
;Registers:
; - R1: Points to current state (21h)
;=====================================================================

Key_PW_Check_13h:
    mov   A,2Fh                   ;MSB PW from RAM
    cjne  A,2Bh,Key_PW_Bad_13h
    mov   A,2Eh                   ;
    cjne  A,2Ah,Key_PW_Bad_13h
    mov   A,2Dh                   ;
    cjne  A,29h,Key_PW_Bad_13h
    mov   A,2Ch                   ;LSB PW from RAM
    cjne  A,28h,Key_PW_Bad_13h    ;Program jumps to bad PW state if PW
                                  ;entered was incorrect
    
Key_PW_Ok_13h:
    mov   A,#14h                  ;State 14h
    lcall State_Lookup
    jmp   Key_PW_Check_13h_Finish ;Program returns here once the state
                                  ;machine is finished

Key_PW_Bad_13h:
    mov   A,#05h                  ;State 05h
    lcall State_Lookup
    jmp   Key_PW_Check_13h_Finish ;Program returns here once the state
                                  ;machine is finished
    
Key_PW_Check_13h_Finish:    	
    ret                           ;ret to ENT key state check


;=====================================================================
;   Sub routine - State 12h Password check
;
;This routine determines if the entered password matches that of the
;one stored in RAM.
;
;Addresses:
; - 21h: Checks for state when Enter key ok to press
;
;Registers:
; - R1: Points to current state (21h)
;=====================================================================

Key_PW_Check_12h:
    mov   A,2Fh                   ;MSB PW from RAM
    cjne  A,2Bh,Key_PW_Bad_12h
    mov   A,2Eh                   ;
    cjne  A,2Ah,Key_PW_Bad_12h
    mov   A,2Dh                   ;
    cjne  A,29h,Key_PW_Bad_12h
    mov   A,2Ch                   ;LSB PW from RAM
    cjne  A,28h,Key_PW_Bad_12h    ;Program jumps to bad PW state if PW
                                  ;entered was incorrect
    
Key_PW_Ok_12h:
    mov   A,#14h                  ;State 14h
    lcall State_Lookup
    jmp   Key_PW_Check_12h_Finish ;Program returns here once the state
                                  ;machine is finished

Key_PW_Bad_12h:
    mov   A,#13h                  ;State 13h
    lcall State_Lookup
    jmp   Key_PW_Check_12h_Finish ;Program returns here once the state
                                  ;machine is finished
    
Key_PW_Check_12h_Finish:    	
    ret                           ;ret to ENT key state check


;=====================================================================
;   Sub routine - State 11h Password check
;
;This routine determines if the entered password matches that of the
;one stored in RAM.
;
;Addresses:
; - 21h: Checks for state when Enter key ok to press
;
;Registers:
; - R1: Points to current state (21h)
;=====================================================================

Key_PW_Check_11h:
    mov   A,2Fh                   ;MSB PW from RAM
    cjne  A,2Bh,Key_PW_Bad_11h
    mov   A,2Eh                   ;
    cjne  A,2Ah,Key_PW_Bad_11h
    mov   A,2Dh                   ;
    cjne  A,29h,Key_PW_Bad_11h
    mov   A,2Ch                   ;LSB PW from RAM
    cjne  A,28h,Key_PW_Bad_11h    ;Program jumps to bad PW state if PW
                                  ;entered was incorrect
    
Key_PW_Ok_11h:
    mov   A,#14h                  ;State 14h
    lcall State_Lookup
    jmp   Key_PW_Check_11h_Finish ;Program returns here once the state
                                  ;machine is finished

Key_PW_Bad_11h:
    mov   A,#12h                  ;State 12h
    lcall State_Lookup
    jmp   Key_PW_Check_11h_Finish ;Program returns here once the state
                                  ;machine is finished
    
Key_PW_Check_11h_Finish:    	
    ret                           ;ret to ENT key state check


;=====================================================================
;   Sub routine - State 0Dh Password check
;
;This routine determines if the entered password matches that of the
;one stored in RAM.
;
;Addresses:
; - 21h: Checks for state when Enter key ok to press
;
;Registers:
; - R1: Points to current state (21h)
;=====================================================================

Key_PW_Check_0Dh:
    mov   A,2Fh                   ;MSB PW from RAM
    cjne  A,2Bh,Key_PW_Bad_0Dh
    mov   A,2Eh                   ;
    cjne  A,2Ah,Key_PW_Bad_0Dh
    mov   A,2Dh                   ;
    cjne  A,29h,Key_PW_Bad_0Dh
    mov   A,2Ch                   ;LSB PW from RAM
    cjne  A,28h,Key_PW_Bad_0Dh    ;Program jumps to bad PW state if PW
                                  ;entered was incorrect
    
Key_PW_Ok_0Dh:
    mov   A,#0Bh                  ;State 0Bh
    lcall State_Lookup
    jmp   Key_PW_Check_0Dh_Finish ;Program returns here once the state
                                  ;machine is finished

Key_PW_Bad_0Dh:
    mov   A,#05h                  ;State 05h
    lcall State_Lookup
    jmp   Key_PW_Check_0Dh_Finish ;Program returns here once the state
                                  ;machine is finished
    
Key_PW_Check_0Dh_Finish:    	
    ret                           ;ret to ENT key state check


;=====================================================================
;   Sub routine - State 0Ch Password check
;
;This routine determines if the entered password matches that of the
;one stored in RAM.
;
;Addresses:
; - 21h: Checks for state when Enter key ok to press
;
;Registers:
; - R1: Points to current state (21h)
;=====================================================================

Key_PW_Check_0Ch:
    mov   A,2Fh                   ;MSB PW from RAM
    cjne  A,2Bh,Key_PW_Bad_0Ch
    mov   A,2Eh                   ;
    cjne  A,2Ah,Key_PW_Bad_0Ch
    mov   A,2Dh                   ;
    cjne  A,29h,Key_PW_Bad_0Ch
    mov   A,2Ch                   ;LSB PW from RAM
    cjne  A,28h,Key_PW_Bad_0Ch    ;Program jumps to bad PW state if PW
                                  ;entered was incorrect
    
Key_PW_Ok_0Ch:
    mov   A,#0Bh                  ;State 0Bh
    lcall State_Lookup
    jmp   Key_PW_Check_0Ch_Finish ;Program returns here once the state
                                  ;machine is finished

Key_PW_Bad_0Ch:
    mov   A,#0Dh                  ;State 0Dh
    lcall State_Lookup
    jmp   Key_PW_Check_0Ch_Finish ;Program returns here once the state
                                  ;machine is finished
    
Key_PW_Check_0Ch_Finish:    	
    ret                           ;ret to ENT key state check

;=====================================================================
;   Sub routine - State 0Ah Password check
;
;This routine determines if the entered password matches that of the
;one stored in RAM.
;
;Addresses:
; - 21h: Checks for state when Enter key ok to press
;
;Registers:
; - R1: Points to current state (21h)
;=====================================================================

Key_PW_Check_0Ah:
    mov   A,2Fh                   ;MSB PW from RAM
    cjne  A,2Bh,Key_PW_Bad_0Ah
    mov   A,2Eh                   ;
    cjne  A,2Ah,Key_PW_Bad_0Ah
    mov   A,2Dh                   ;
    cjne  A,29h,Key_PW_Bad_0Ah
    mov   A,2Ch                   ;LSB PW from RAM
    cjne  A,28h,Key_PW_Bad_0Ah    ;Program jumps to bad PW state if PW
                                  ;entered was incorrect
    
Key_PW_Ok_0Ah:
    mov   A,#0Bh                  ;State 0Bh
    lcall State_Lookup
    jmp   Key_PW_Check_0Ah_Finish ;Program returns here once the state
                                  ;machine is finished

Key_PW_Bad_0Ah:
    mov   A,#0Ch                  ;State 0Ch
    lcall State_Lookup
    jmp   Key_PW_Check_0Ah_Finish ;Program returns here once the state
                                  ;machine is finished
    
Key_PW_Check_0Ah_Finish:    	
    ret                           ;ret to ENT key state check

;=====================================================================
;   Sub routine - State 02h Password check
;
;This routine determines if the entered password matches that of the
;one stored in RAM.
;
;Addresses:
; - 21h: Checks for state when Enter key ok to press
;
;Registers:
; - R1: Points to current state (21h)
;=====================================================================

Key_PW_Check_02h:
    mov   A,2Fh                   ;MSB PW from RAM
    cjne  A,2Bh,Key_PW_Bad_02h
    mov   A,2Eh                   ;
    cjne  A,2Ah,Key_PW_Bad_02h
    mov   A,2Dh                   ;
    cjne  A,29h,Key_PW_Bad_02h
    mov   A,2Ch                   ;LSB PW from RAM
    cjne  A,28h,Key_PW_Bad_02h    ;Program jumps to bad PW state if PW
                                  ;entered was incorrect
    
Key_PW_Ok_02h:
    mov   A,#06h                  ;State 06h
    lcall State_Lookup
    jmp   Key_PW_Check_02h_Finish ;Program returns here once the state
                                  ;machine is finished

Key_PW_Bad_02h:
    mov   A,#03h                  ;State 03h
    lcall State_Lookup
    jmp   Key_PW_Check_02h_Finish ;Program returns here once the state
                                  ;machine is finished
    
Key_PW_Check_02h_Finish:    	
    ret                           ;ret to ENT key state check


;=====================================================================
;   Sub routine - State 03h Password check
;
;This routine determines if the entered password matches that of the
;one stored in RAM.
;
;Addresses:
; - 21h: Checks for state when Enter key ok to press
;
;Registers:
; - R1: Points to current state (21h)
;=====================================================================

Key_PW_Check_03h:
    mov   A,2Fh                   ;MSB PW from RAM
    cjne  A,2Bh,Key_PW_Bad_03h
    mov   A,2Eh                   ;
    cjne  A,2Ah,Key_PW_Bad_03h
    mov   A,2Dh                   ;
    cjne  A,29h,Key_PW_Bad_03h
    mov   A,2Ch                   ;LSB PW from RAM
    cjne  A,28h,Key_PW_Bad_03h    ;Program jumps to bad PW state if PW
                                  ;entered was incorrect
    
Key_PW_Ok_03h:
    mov   A,#06h                  ;State 06h
    lcall State_Lookup
    jmp   Key_PW_Check_03h_Finish ;Program returns here once the state
                                  ;machine is finished

Key_PW_Bad_03h:
    mov   A,#04h                  ;State 04h
    lcall State_Lookup
    jmp   Key_PW_Check_03h_Finish ;Program returns here once the state
                                  ;machine is finished
    
Key_PW_Check_03h_Finish:    	
    ret                           ;ret to ENT key state check

;=====================================================================
;   Sub routine - State 04h Password check
;
;This routine determines if the entered password matches that of the
;one stored in RAM.
;
;Addresses:
; - 21h: Checks for state when Enter key ok to press
;
;Registers:
; - R1: Points to current state (21h)
;=====================================================================

Key_PW_Check_04h:
    mov   A,2Fh                   ;MSB PW from RAM
    cjne  A,2Bh,Key_PW_Bad_04h
    mov   A,2Eh                   ;
    cjne  A,2Ah,Key_PW_Bad_04h
    mov   A,2Dh                   ;
    cjne  A,29h,Key_PW_Bad_04h
    mov   A,2Ch                   ;LSB PW from RAM
    cjne  A,28h,Key_PW_Bad_04h    ;Program jumps to bad PW state if PW
                                  ;entered was incorrect
    
Key_PW_Ok_04h:
    mov   A,#06h                  ;State 06h
    lcall State_Lookup
    jmp   Key_PW_Check_04h_Finish ;Program returns here once the state
                                  ;machine is finished

Key_PW_Bad_04h:
    mov   A,#05h                  ;State 05h
    lcall State_Lookup
    jmp   Key_PW_Check_04h_Finish ;Program returns here once the state
                                  ;machine is finished
    
Key_PW_Check_04h_Finish:    	
    ret                           ;ret to ENT key state check


;=====================================================================
;   Sub routine - Backspace Function Key valid state check
;
;This routine determines if the current state allows for 
;the backspace key to be pressed.
;
;Addresses:
; - 21h: Checks for state when BS key ok to press
;
;Registers:
; - R1: Points to current state (21h)
;=====================================================================

Key_Func_BS:
    ;State 02h is true? then continue else next
    cjne    @R1,#02h,Key_Func_BS_01
    lcall   Key_BS_Resolve
    jmp     Key_Func_BS_Finish

Key_Func_BS_01:
    ;State 03h is true? then continue else next
    cjne    @R1,#03h,Key_Func_BS_02
    lcall   Key_BS_Resolve
    jmp     Key_Func_BS_Finish

Key_Func_BS_02:
    ;State 04h is true? then continue else next
    cjne    @R1,#04h,Key_Func_BS_03
    lcall   Key_BS_Resolve
    jmp     Key_Func_BS_Finish

Key_Func_BS_03:
    ;State 0Ah is true? then continue else next
    cjne    @R1,#0Ah,Key_Func_BS_04
    lcall   Key_BS_Resolve
    jmp     Key_Func_BS_Finish

Key_Func_BS_04:
    ;State 0Ch is true? then continue else next
    cjne    @R1,#0Ch,Key_Func_BS_05
    lcall   Key_BS_Resolve
    jmp     Key_Func_BS_Finish

Key_Func_BS_05:
    ;State 0Dh is true? then continue else next
    cjne    @R1,#0Dh,Key_Func_BS_06
    lcall   Key_BS_Resolve
    jmp     Key_Func_BS_Finish

Key_Func_BS_06:
    ;State 11h is true? then continue else next
    cjne    @R1,#11h,Key_Func_BS_07
    lcall   Key_BS_Resolve
    jmp     Key_Func_BS_Finish

Key_Func_BS_07:
    ;State 12h is true? then continue else next
    cjne    @R1,#12h,Key_Func_BS_08
    lcall   Key_BS_Resolve
    jmp     Key_Func_BS_Finish 

Key_Func_BS_08:
    ;State 13h is true? then continue else next
    cjne    @R1,#13h,Key_Func_BS_09
    lcall   Key_BS_Resolve
    jmp     Key_Func_BS_Finish

Key_Func_BS_09:
    ;State 14h is true? then continue else finish
    cjne    @R1,#14h,Key_Func_BS_10
    lcall   Key_BS_Resolve
    jmp     Key_Func_BS_Finish

Key_Func_BS_10:
    ;State 0Eh is true? then continue else finish
    cjne    @R1,#0Eh,Key_Func_BS_Finish
    lcall   Key_BS_Resolve
    jmp     Key_Func_BS_Finish

    
Key_Func_BS_Finish:    	
    ret

;=====================================================================
;   Sub routine - Backspace Resolve
;
;This routine determines if backspace key can delete a character.
;
;
;
;Registers:
; - R0: Points to MSB of password entered (2Bh)
; - R2: Determines BS/non_Func key presses allowed
;=====================================================================
Key_BS_Resolve:
    clr     C
    cjne    R2,#01h,$ + 3
    jc      Key_BS_Resolve_Finish

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
        
    dec     R2
    inc     R0
    jmp     Key_BS_Resolve_Finish


Key_BS_Resolve_Finish:    
    ret


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
;   Sub routine - Key valid state check
;
;Addresses:
; - 20h: Evaluates this addresed to determine funct. key & caps lock
;status.  Leave this sub with correct lookup table in DPTR.  When this
;sub is initially called, the ACC has the value of the key (according 
;to the actual value as determined by the keypad schematic) pressed.
;
;Registers:
; - R0: Points to MSB of password entered (2Bh)
; - R1: Points to current state (21h)
; - R2: Determines BS/non_Func key presses allowed
;
;=====================================================================

Key_State_Chk:

    ;State 02h is true? then continue else finish
    cjne    @R1,#02h,Key_State_Chk_01
    lcall   Key_Func_PW
    jmp     Key_State_Chk_Finish

Key_State_Chk_01:
    ;State 03h is true? then continue else finish
    cjne    @R1,#03h,Key_State_Chk_02
    lcall   Key_Func_PW
    jmp     Key_State_Chk_Finish

Key_State_Chk_02:
    ;State 04h is true? then continue else finish
    cjne    @R1,#04h,Key_State_Chk_03
    lcall   Key_Func_PW
    jmp     Key_State_Chk_Finish

Key_State_Chk_03:
    ;State 07h is true? then continue else finish
    cjne    @R1,#07h,Key_State_Chk_04
    lcall   Key_State07h_Menu
    jmp     Key_State_Chk_Finish

Key_State_Chk_04:
    ;State 08h is true? then continue else finish
    cjne    @R1,#08h,Key_State_Chk_05
    lcall   Key_State08h_Menu
    jmp     Key_State_Chk_Finish

Key_State_Chk_05:
    ;State 0Ah is true? then continue else finish
    cjne    @R1,#0Ah,Key_State_Chk_06
    lcall   Key_Func_PW
    jmp     Key_State_Chk_Finish

Key_State_Chk_06:
    ;State 0Ch is true? then continue else finish
    cjne    @R1,#0Ch,Key_State_Chk_07
    lcall   Key_Func_PW
    jmp     Key_State_Chk_Finish

Key_State_Chk_07:
    ;State 0Dh is true? then continue else finish
    cjne    @R1,#0Dh,Key_State_Chk_08
    lcall   Key_Func_PW
    jmp     Key_State_Chk_Finish

Key_State_Chk_08:
    ;State 11h is true? then continue else finish
    cjne    @R1,#11h,Key_State_Chk_09
    lcall   Key_Func_PW
    jmp     Key_State_Chk_Finish

Key_State_Chk_09:
    ;State 12h is true? then continue else finish
    cjne    @R1,#12h,Key_State_Chk_10
    lcall   Key_Func_PW
    jmp     Key_State_Chk_Finish

Key_State_Chk_10:
    ;State 13h is true? then continue else finish
    cjne    @R1,#13h,Key_State_Chk_11
    lcall   Key_Func_PW
    jmp     Key_State_Chk_Finish

Key_State_Chk_11:
    ;State 14h is true? then continue else finish
    cjne    @R1,#14h,Key_State_Chk_12
    lcall   Key_Func_PW
    jmp     Key_State_Chk_Finish

Key_State_Chk_12:
    ;State 0Eh is true? then continue else finish
    cjne    @R1,#0Eh,Key_State_Chk_Finish
    lcall   Key_Func_Accel
    jmp     Key_State_Chk_Finish

Key_State_Chk_Finish:
    ret

;=====================================================================
;   Sub routine - State_08h non-function key menu selection
;
;Registers:
;
;=====================================================================

Key_State08h_Menu:

    ;Option 1? then continue else finish
    cjne    A,#03h,Key_State08h_Menu_01
    mov     A,#09h                      ;State_09h
    lcall   State_Lookup                ;Go to state
    jmp     Key_State08h_Menu_Finish

Key_State08h_Menu_01:
    ;Option 2? then continue else finish
    cjne    A,#02h,Key_State08h_Menu_Finish
    mov     A,#0Ah                      ;State_0Ah
    lcall   State_Lookup                ;Go to state
    jmp     Key_State08h_Menu_Finish


Key_State08h_Menu_Finish:

    ret

;=====================================================================
;   Sub routine - State_07h non-function key menu selection
;
;Registers:
;
;=====================================================================

Key_State07h_Menu:

    ;Option 1? then continue else finish
    cjne    A,#03h,Key_State07h_Menu_01
    mov     A,#08h                      ;State_08h
    lcall   State_Lookup                ;Go to state
    jmp     Key_State07h_Menu_Finish

Key_State07h_Menu_01:
    ;Option 2? then continue else finish
    cjne    A,#02h,Key_State07h_Menu_02
    mov     A,#0Eh                      ;State_0Eh
    lcall   State_Lookup                ;Go to state
    jmp     Key_State07h_Menu_Finish

Key_State07h_Menu_02:
    ;Option 3? then continue else finish
    cjne    A,#01h,Key_State07h_Menu_Finish
    mov     A,#11h                      ;State_11h
    lcall   State_Lookup                ;Go to state
    jmp     Key_State07h_Menu_Finish


Key_State07h_Menu_Finish:

    ret


;=====================================================================
;   Sub routine - Key input resolution for Acceleration Setpoint
;
;This sub is to be used for entering in the new acceleration
;setpoint into State_0Eh.  It will also write the ascii to 
;scratch pad RAM for setpoint analysis.
;
;Addresses:
; - 20h: Evaluates this address to determine funct. key & caps lock
;status.  Leave this sub with correct lookup table in DPTR.  When this
;sub is initially called, the ACC has the value of the key (according 
;to the actual value as determined by the keypad schematic) pressed.
;
; - 27h,26h,& 25h: Location of stored Acceleration STPT
;
;Registers:
; - R0: Points to MSB of Accel STPT (27h)
; - R1: Points to current state (21h)
; - R2: Determines BS/non_Func key presses allowed
;
;=====================================================================

Key_Func_Accel:
    push    PSW
    push    ACC
    push    B
		
    clr     C
    cjne    R2,#03h,$ + 3        ;jmp to end if 3 char's entered
    jnc     Key_Func_Accel_Restore     ;
    
  
    ;Check Bit 00h for Blue function key, Numbers only
    jb      00h,Key_Func_Accel_Bluekey
    ;Check Bit 01h for Pink function key
    jb      01h,Key_Func_Accel_Pinkkey

    jmp	    Key_Func_Accel_Restore



Key_Func_Accel_Pinkkey:
    inc     R2                   ;Prog reaches this point if R2<3  
    mov     DPTR,#Key_Pink_LC   ;Pink lowercase lookup table		
    jmp     Key_Func_Accel_Finish
    
Key_Func_Accel_Bluekey:
    inc     R2                   ;Prog reaches this point if R2<3  
    mov     DPTR,#Key_Blue_Num

Key_Func_Accel_Finish:
    movc    A,@A + DPTR         ;Updates ACC w/ corresponding
                                ;char. in lookup table
    mov     @R0,A               ;ascii in ACC to R0 pointer
    dec     R0                  ;Next PW location

Key_Func_Accel_Char:

    mov     DPTR,#LCD_WRITE    ;Writes the actual character to LCD
    movx    @DPTR,A            ;
    lcall   LCD_Busy
    
Key_Func_Accel_Restore:
    pop     B
    pop     ACC
    pop     PSW
    
    ret



;=====================================================================
;   Sub routine - Key input resolution for Password states
;
;This sub is to be used for states that require password entry before
;the next state can be achieved.  This sub will write the password
;entered into on chip RAM and allow for a maximum of a 4 char.
;password.
;
;Addresses:
; - 20h: Evaluates this address to determine funct. key & caps lock
;status.  Leave this sub with correct lookup table in DPTR.  When this
;sub is initially called, the ACC has the value of the key (according 
;to the actual value as determined by the keypad schematic) pressed.
;
;Registers:
; - R0: Points to MSB of password entered (2Bh)
; - R1: Points to current state (21h)
; - R2: Determines BS/non_Func key presses allowed
;
;=====================================================================

Key_Func_PW:
    push    PSW
    push    ACC
    push    B
		
    clr     C
    cjne    R2,#04h,$ + 3        ;jmp to end if 4 char's entered
    jnc     Key_Func_Restore     ;
    inc     R2                   ;Prog reaches this point if R2<4  
  

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
    jnb     07h,$ + 8           ;07h=caps lock, jump to 
                                ;'Pink_LC' if not caps lock
    mov     DPTR,#Key_Pink_UpC  ;Pink uppercase lookup table
    sjmp    Key_Func_Finish

    mov     DPTR,#Key_Pink_LC   ;Pink lowercase lookup table		
    jmp     Key_Func_Finish

Key_Func_Bluekey:
    mov     DPTR,#Key_Blue_Num


Key_Func_Finish:
    movc    A,@A + DPTR         ;Updates ACC w/ corresponding
                                ;char. in lookup table
    mov     @R0,A               ;ascii in ACC to R0 pointer
    dec     R0                  ;Next PW location
    

Key_Func_PW_StateCk:
    cjne    @R1,#14h,Key_Func_Star  ;Checks state to either print '*'
                                    ;or the char. during a PW change
                                    ;state

Key_Func_Char:

    mov     DPTR,#LCD_WRITE    ;Writes the actual character instead
    movx    @DPTR,A            ;of '*' when PW change state=true
    lcall   LCD_Busy
    jmp     Key_Func_Restore

Key_Func_Star:
    mov     DPTR,#LCD_WRITE     ;write '*' on each char. entry
    mov     A,#'*'              ;ascii value for '*'
    movx    @DPTR,A
    lcall   LCD_Busy
    
Key_Func_Restore:
    pop     B
    pop     ACC
    pop     PSW
    
    ret


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

