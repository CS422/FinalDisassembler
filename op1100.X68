op1100  ;AND MULS.W
*    ------------------------------------------------------------

    JSR WordOrLong  ;result is what the OPMODE FIELD IS STored in D3
*    ------------------------------------------------------------

    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
*    ------------------------------------------------------------

    CMP.B   #hex_0,D3    ; AND.B
    BEQ     and_B       ;branch
    CMP.B   #hex_1,D3    ; AND.W
    BEQ     and_W       ;branch
    CMP.B   #hex_2,D3    ; AND.L
    BEQ     and_L       ;branch
    CMP.B   #hex_4,D3    ; AND.B [to EA]
    BEQ     and_B_EA    ;branch
    CMP.B   #hex_5,D3    ; AND.W [to EA]
    BEQ     and_W_EA    ;branch
    CMP.B   #hex_6,D3    ; AND.L [to EA]
    BEQ     and_L_EA    ;branch
*    ------------------------------------------------------------            

    CMP.B   #hex_7,D3    ; MULS.W
    BEQ     muls_W      ;branch
*    ------------------------------------------------------------

*    AND <EA>,Dn

*    ------------------------------------------------------------

and_B
    MOVE.B  #'A',(A2)+
    MOVE.B  #'N',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'B',(A2)+
    MOVE.B  #0,D7           Byte Size
    BRA     decodeAndEADn
*    ------------------------------------------------------------

and_W   
    MOVE.B  #'A',(A2)+
    MOVE.B  #'N',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    MOVE.B  #1,D7           Word Size
    BRA     decodeAndEADn
*    ------------------------------------------------------------

and_L   
    MOVE.B  #'A',(A2)+
    MOVE.B  #'N',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'L',(A2)+
    MOVE.B  #2,D7           Long Size
    BRA     decodeAndEADn
*    ------------------------------------------------------------

decodeAndEADn
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
*    ------------------------------------------------------------

    JSR     get_3to5_bit
*    ------------------------------------------------------------

    JSR     get_0to2_bit
*    ------------------------------------------------------------

*    Check D2: mode value for immediate or Absolute addressing

    CMP.B   #7,D2
    BEQ     immAbAndEADn
*    ------------------------------------------------------------

desDecodeAndEADn   
    MOVE.B  #',',(A2)+  comma between operands
*    ------------------------------------------------------------

    CLR.L     D1
    MOVE.B  #0,D1           Always Dn format
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

immAbAndEADn
*    Check for #imm or Absolute addressing with D1: register value

    CMP     #4,D1      if immediate data
    BEQ     adjustimmAbAndEADn
immAbJumpAndEADn
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     desDecodeAndEADn
adjustimmAbAndEADn
    SUB.B   D7,D1
    BRA     immAbJumpAndEADn
*    ------------------------------------------------------------

*    end of AND <EA>,Dn          

*    ------------------------------------------------------------

*    AND Dn,<EA>

*    ------------------------------------------------------------

and_B_EA
    MOVE.B  #'A',(A2)+
    MOVE.B  #'N',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'B',(A2)+
    MOVE.B  #0,D7           Byte Size
    BRA     decodeAndDnEA
*    ------------------------------------------------------------

and_W_EA   
    MOVE.B  #'A',(A2)+
    MOVE.B  #'N',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    MOVE.B  #1,D7           Word Size
    BRA     decodeAndDnEA
*    ------------------------------------------------------------

and_L_EA   
    MOVE.B  #'A',(A2)+
    MOVE.B  #'N',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'L',(A2)+
    MOVE.B  #2,D7           Word Size
    BRA     decodeAndDnEA
*    ------------------------------------------------------------

decodeAndDnEA
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
*    ------------------------------------------------------------

    CLR.L     D1
    MOVE.B  #0,D1           Always Dn format
    LEA     modeTable,A6
    JSR     (A6,D1)
*    ------------------------------------------------------------

    JSR     get_9to11_bit
*    ------------------------------------------------------------ -

    MOVE.B  #',',(A2)+  comma between operands
*    ------------------------------------------------------------

    JSR     get_3to5_bit
*    ------------------------------------------------------------

    JSR     get_0to2_bit
*    ------------------------------------------------------------

*    Check D2: mode value for immediate or Absolute addressing

    CMP.B   #7,D2
    BEQ     immAbAndDnEA
*    -----------------------------------------------------------

*    end of decoding

*    ------------------------------------------------------------

*    printing          

    BRA     printCode
*    ------------------------------------------------------------

immAbAndDnEA
*    Check for #imm or Absolute addressing with D1: register value

    CMP     #4,D1      if immediate data
    BEQ     adjustimmAbAndDnEA
immAbJumpAndDnEA
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     printCode
adjustimmAbAndDnEA
    SUB.B   D7,D1
    BRA     immAbJumpAndDnEA
*    ------------------------------------------------------------

*    end of AND <EA>,Dn          

*    ------------------------------------------------------------

*    MULS.W

*    ------------------------------------------------------------

muls_W
    MOVE.B  #'M',(A2)+
    MOVE.B  #'U',(A2)+
    MOVE.B  #'L',(A2)+
    MOVE.B  #'S',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
*    ------------------------------------------------------------

    JSR     get_3to5_bit
*    ------------------------------------------------------------

    JSR     get_0to2_bit
*    ------------------------------------------------------------

*    Check D2: mode value for immediate or Absolute addressing

    CMP.B   #7,D2
    BEQ     immAbMULS_W
*    ------------------------------------------------------------

desDecodeMULS_W  
    MOVE.B  #',',(A2)+  comma between operands
*    ------------------------------------------------------------

    CLR     D1
    MOVE.B  #0,D1           Always Dn format
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

immAbMULS_W
*    Check for #imm or Absolute addressing with D1: register value

    CMP     #4,D1      if immediate data
    BEQ     adjustimmAbMULS_W
immAbJumpMULS_W
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     desDecodeMULS_W
adjustimmAbMULS_W
    CLR     D1
    MOVE.B  #3,D1           Always Word Size
    BRA     immAbJumpMULS_W
*    ------------------------------------------------------------

*    end of MULS.W          

*    ------------------------------------------------------------

*    end of file

*    ------------------------------------------------------------

















*    ~Font name~Courier New~

*    ~Font size~10~

*    ~Tab type~1~

*    ~Tab size~4~

