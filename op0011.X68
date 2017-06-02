op0011
*    check MOVE or MOVEA by the value of Destination mode

*    B IT** ****

*    If BIT == 001 => MOVEA, otherwise => MOVE

*    ------------------------------------------------------------

    MOVE.L  #2,D7       ;data is not error
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    CLR     D2
    CLR     D1
    MOVE.W  D6,D2       MOVE the original machine code to D2 to play with
    LSL.W   #7,D2       BIT* **** **** 0000
    LSR.W   #8,D2       0000 0000 BIT* ****
    LSR.W   #5,D2       0000 0000 0000 0BIT
    CMP.B   #1,D2
    BEQ     MoveA_W
    BNE     Move_W
*    ------------------------------------------------------------

Move_W          
    MOVE.B  #'M',(A2)+      ;print M
    MOVE.B  #'O',(A2)+      ;print O
    MOVE.B  #'V',(A2)+      ;print V
    MOVE.B  #'E',(A2)+      PRINT  E
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    MOVE.B  #' ',(A2)+
    BRA     decode0011
*    ------------------------------------------------------------

MoveA_W
    MOVE.B  #'M',(A2)+      ;print M
    MOVE.B  #'O',(A2)+      ;print O
    MOVE.B  #'V',(A2)+      ;print V
    MOVE.B  #'E',(A2)+      PRINT  E
    MOVE.B  #'A',(A2)+      PRINT  E
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    BRA     decode0011
*    ------------------------------------------------------------

decode0011
    MOVE.B  #' ',(A2)+
*    ------------------------------------------------------------

    JSR     get_3to5_bit
*    ------------------------------------------------------------

    JSR     get_0to2_bit
*    ------------------------------------------------------------

*    Check D2: mode value for immediate or Absolute addressing

    CMP.B   #7,D2
    BEQ     immAb0011
*    ------------------------------------------------------------

desDecode0011   
    MOVE.B  #',',(A2)+  comma between operands
*    ------------------------------------------------------------

    JSR     get_6to8_bit
*    ------------------------------------------------------------

    JSR     get_9to11_bit
*    ------------------------------------------------------------    

*    end of decoding

*    ------------------------------------------------------------

*    printing          

    BRA     printCode
*    ------------------------------------------------------------

immAb0011
*    Check for #imm or Absolute addressing with D1: register value

    CMP     #4,D1      if immediate data
    BEQ     adjustimmAb0011
immAbJump0011            
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     printCode
adjustimmAb0011
    CLR     D1
    MOVE.B  #3,D1         immdiateData WORD always
    BRA     immAbJump0011
*    ------------------------------------------------------------

*    end of file            

*    ------------------------------------------------------------

*    ------------------------------------------------------------


*    ~Font name~Courier New~

*    ~Font size~10~

*    ~Tab type~1~

*    ~Tab size~4~

