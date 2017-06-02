*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

start		EQU	$00009000	* ORG and END address

*    ORG the program so that it straddles the address boundary $00007FFF to $00008000


		ORG	start

* Put program code here

        MOVEM.W (A2),A1-A7/D0-D2


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
