op0111
    *- MOVE Q
    CLR     D3          ;clear D3
    MOVE.B  D6,D3       ;copy data to D3
    ;MOVE.L  #2,D7       ;size of data is long
    
*    ------------------------------------------------------------

    MOVE.B  #' ',(A2)+  ;print some spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'M',(A2)+  ;print M
    MOVE.B  #'O',(A2)+  ;print O
    MOVE.B  #'V',(A2)+  ;print V
    MOVE.B  #'E',(A2)+  ;print E
    MOVE.B  #'Q',(A2)+  ;ptint Q
    MOVE.B  #' ',(A2)+  ;
    MOVE.B  #' ',(A2)+  ;print some spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #'#',(A2)+  ;print #
    MOVE.B  #'$',(A2)+  ;print
    *-REMEMBER MOVEQ TAKES ONLY A BTYE OF DATA
*    ------------------------------------------------------------            

    ;MOVE.B  #12,D5      ;counter for output
    LSR.B   #4,D3       *-get bit 4 to 7 and jump with it DATA
    MULU.W  #8,D3       ;gotta get ready to jump
    LEA     numTable,A6 ;load table
    JSR     (A6,D3)     ;branch to grab number
*    ------------------------------------------------------------

    CLR     D3          ;clear D3
    MOVE.B  D6,D3       ;copy data to D3
    LSL.B   #4,D3       ;get the biut 0 - 3 with it DATA to print BYTE SIZE
    LSR.B   #4,D3
    MULU.W  #8,D3       ;gotta get ready to jump
    LEA     numTable,A6 ;load table
    JSR     (A6,D3)     ;branch to grab number
*    ------------------------------------------------------------            

    MOVE.B  #',',(A2)+  ;print ,
*    ------------------------------------------------------------

    CLR.L   D1
    MOVE.B  #0,D1
    LEA     modeTable,A6
    JSR     (A6,D1)
*    ------------------------------------------------------------

    JSR     get_9to11_bit
*    ------------------------------------------------------------

*    end of decoding

*    ------------------------------------------------------------

*    printing 

    BRA     printCode
*    ------------------------------------------------------------

*    end of file            

*    ------------------------------------------------------------



*    ~Font name~Courier New~

*    ~Font size~10~

*    ~Tab type~1~

*    ~Tab size~4~

