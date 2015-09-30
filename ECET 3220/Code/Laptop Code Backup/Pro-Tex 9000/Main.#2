;=====================================================================
;  													Pro-Tex 9000
;
;Revision: R.07031336  (R.MMDDHHMM)
;
;Project Team Members:
; - Vince Watkins
; - Will Smith
; - Tyler Long
;
;
;Main Code space
;
;
;=====================================================================



;=====================================================================
;   Assembler Controls
;=====================================================================

$DEBUG
$PRINT
	$SYMBOLS                  ;Create Symbol table for list file
	$TITLE(MILESTONE #2)	
	$DATE(June-30-2008)
	$PAGEWIDTH(132)

;=====================================================================
;   Include Files
;=====================================================================

$include  (C8051F020.inc)   ;use with SiLabs Keil A51 compiler




;=====================================================================
;   Variable declarations
;=====================================================================

;LCD Commands
;DISP_CLR              EQU 00000001b ;Clears Disp & sets DDRAM addy to zero
;DISP_FUNCTION_CMD     EQU 00111000b ;Sets disp to 8-bit & 5x10 chars.
;DISP_ON               EQU 00001100b ;Turns disp ON,
;DISP_CURSOR           EQU 00001111b ;Turns disp & cursor ON, cursor flashing
;DISP_ENTRY_MODE       EQU 00000110b ;Sets cursor move direction
;DISP_AUTOSHIFT_CURSOR EQU 00010100b ;Automatic move cursor right after send
;DISP_BACKSPACE        EQU 00010000b ;Shifts cursor left
;DISP_SHIFTRT          EQU 00011100b ;Shifts entire display Right

;LCD_WRITE             EQU 1000h     ;LCD Write address RS=1 & RW=0
;LCD_READ              EQU 1100h     ;LCD Read busy address RS=0 & RW =1
;LCD_CMD               EQU 1200h     ;LCD Command address RS=0 & RW =0

;Keypad Commands
;KEY_READ              EQU 4000h     ;Keypad read cmd addr. for DPTR


;=====================================================================
;   Reset/Interrupt Vectors
;=====================================================================

    org   0000h
    ljmp  Main

    org   0003h   ;/INT0 interrupt vector for Keypad
    ljmp  Key_ISR

    org   0013h   ;/INT1 interrupd vector for Alarms
    ljmp Alarm_Check

    org   001Bh   ;Timer1 interrupt vector for geting acceleration
    ljmp  ADC_GetAcc





;=====================================================================
;   Main Routine
;=====================================================================


    org   0030h

;=====================================================================
;   Include Files
;=====================================================================

$include  (LCD.asm)         ;LCD routines
$include  (Key.asm)         ;Keypad routines
$include  (RAM.asm)         ;RAM routines
$include  (Init.asm)        ;Initialization routines
$include  (State.asm)       ;State Machine routines
$include  (ADC.asm)         ;ADC routines
$include  (Alarm.asm)       ;Alarm routines


Main:
    mov     SP,#30h         ;Initialize stack pointer
    lcall   Init_Device
    clr     18h            ;System Armed status
    
    lcall   LCD_Init       ;Initialize LCD
		lcall   RAM_Init       ;Sets default password in RAM
    ;lcall   ADC_Init       ;Kick starts ADC to begin convert
    mov	    P1,#00h        ;Turns off all LEDs

    mov     2Bh,#00h       ;This section will clear
    mov     2Ah,#00h       ;the scratch pad RAM
    mov     29h,#00h       ;in 8051 which stores the 
    mov     28h,#00h       ;user entered PW on reset

    mov     27h,#30h       ;This sets the default setpoint
    mov     26h,#37h       ;for the Acceleration
    mov     25h,#35h       ;to +- 0.75g


;=====================================================================
;   Screen #1
;=====================================================================
    mov     A,#00h         ;State index 00
		lcall   State_Lookup
    
;=====================================================================
;   Screen #2
;=====================================================================
    mov     A,#01h         ;State index 01    
    lcall   State_Lookup
    

;=====================================================================
;  Screen #3
;=====================================================================
    mov     A,#02h         ;State index 02
    lcall   State_Lookup


    sjmp    $                ;Wait for interrupt from Keypad (/INT0)
                             ;or ADC Timer


end
