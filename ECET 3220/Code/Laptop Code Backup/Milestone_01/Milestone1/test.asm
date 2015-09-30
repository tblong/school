$NOMOD51

;-----------------------------------------------------------------------------

$include (c8051f020.inc)               ; Include register definition file.

;Authors: Tyler Long, Wil Smith, and Vincent Watkins

;-----------------------------------------------------------------------------
; RESET and INTERRUPT VECTORS
;-----------------------------------------------------------------------------

               ; Reset Vector
               cseg AT 0
               ljmp Main               ; Locate a jump to the start of code at 
                                       ; the reset vector.

;-----------------------------------------------------------------------------
; CODE SEGMENT
;-----------------------------------------------------------------------------


Blink          segment  CODE

               rseg     Blink          ; Switch to this code segment.
               using    0              ; Specify register bank for the following
                                       ; program code.

Main:          ; Disable the WDT. (IRQs not enabled at this point.)
               ; If interrupts were enabled, we would need to explicitly disable
               ; them so that the 2nd move to WDTCN occurs no more than four clock 
               ; cycles after the first move to WDTCN.

               mov   WDTCN, #0DEh
               mov   WDTCN, #0ADh

               
               mov   XBR2, #40h ; Enable the Port I/O Crossbar
							 mov	 XBR1, #80h ; Place Clock on P0.0 for CPLD
               
							 ; Set all of P1 as digital output in push-pull mode.  
               orl   P1MDIN, #0FFh	 
               orl   P1MDOUT,#0FFh 

               ; Initialize LED to OFF
               clr   P1.0
							 clr   P1.1
							 clr	 P1.2
							 clr	 P1.3
               clr	 P1.4
							 clr	 P1.5
							 clr	 P1.6
							 clr	 P1.7
							 mov	 A, #80h ;Create Exit from loop
							 ; Simple delay loop.
Loop2:         mov   R7, #03h			
Loop1:         mov   R6, #00h
Loop0:         mov   R5, #00h
               djnz  R5, $
               djnz  R6, Loop0
               
							 djnz  R7, Loop1
               
							 setb  P1.0 ;Enable Flash
							 cpl   P1.1 ; Toggle LED.
							 cpl	 P1.2 ; Toggle LED.
							 cpl	 P1.3 ; Toggle LED.
							 cpl	 P1.4 ; Toggle LED.
							 cpl	 P1.5 ; Toggle LED.
							 cpl	 P1.6 ; Toggle LED.
							 cpl	 P1.7 ; Toggle LED.
               dec	 A
							 jz		 Finish ; Jump out of loop
							 jmp   Loop2
Finish:				 clr   P1.0 ;Turn off Flash
							 clr	 P1.1 ;Turn off LED
							 clr	 P1.2 ;Turn off LED
							 clr	 P1.3 ;Turn off LED
               clr	 P1.4 ;Turn off LED
							 clr	 P1.5 ;Turn off LED
							 clr	 P1.6 ;Turn off LED
							 clr	 P1.7 ;Turn off LED
							 sjmp $     ;Lock up program
;-----------------------------------------------------------------------------
; End of file.

END