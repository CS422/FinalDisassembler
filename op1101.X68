op1101 
    ;ADD, ADDA
*    ------------------------------------------------------------

    ; we need to determine what its size is (B,W,L) putting the data in D6
    JSR   WordOrLong ; WordOrLong decodes the OPMODE field and stores the output into D3 where
    ; we use to decode and branch
    *-now D3 contains the OPMODE FIELD telling us wether this is
    *-a LONG or a WORD
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
*    ------------------------------------------------------------  

    *-now we need to decipher if its any of the adds
    CMP.B   #hex_0,D3   is this ADD.B
    BEQ add_B           ;<EA> -> Dn
*    

    CMP.B   #hex_1,D3   is it ADD.W
    BEQ add_W       ;<EA> ->Dn
*    

    CMP.B   #hex_2,D3   is it ADD.L
    BEQ add_L ;<EA> ->Dn
    
    CMP.B   #hex_3,D3
    BEQ adda_W
    
    CMP.B   #hex_4,D3
    BEQ add_B_EA Dn -> EA
    
    CMP.B   #hex_5,D3
    BEQ add_W_EA Dn ->EA
    
*    

    CMP.B   #hex_6,D3
    BEQ add_L_EA Dn - >EA
*    

    CMP.B   #hex_7,D3
    BEQ adda_L
*    ------------------------------------------------------------

*    ADD <EA>,Dn

*    ------------------------------------------------------------

add_B
    MOVE.B  #'A',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'B',(A2)+
    MOVE.B  #0,D7           Byte Size
    BRA     decodeAddEADn
*    ------------------------------------------------------------

add_W   
    MOVE.B  #'A',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    MOVE.B  #1,D7           Word Size
    BRA     decodeAddEADn
*    ------------------------------------------------------------

add_L   
    MOVE.B  #'A',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'L',(A2)+
    MOVE.B  #2,D7           Long Size
    BRA     decodeAddEADn
*    ------------------------------------------------------------

decodeAddEADn
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
    BEQ     immAb0010
*    ------------------------------------------------------------

desDecodeAddEADn   
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

immAbAddEADn
*    Check for #imm or Absolute addressing with D1: register value

    CMP     #4,D1      if immediate data
    BEQ     adjustimmAbAddEADn
immAbJumpAddEADn
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     desDecodeAddEADn
adjustimmAbAddEADn
    SUB.B   D7,D1
    BRA     immAbJumpAddEADn
*    ------------------------------------------------------------

*    end of ADD <EA>,Dn          

*    ------------------------------------------------------------

*    ADD Dn,<EA>

*    ------------------------------------------------------------

add_B_EA
    MOVE.B  #'A',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'B',(A2)+
    MOVE.B  #0,D7           Byte Size
    BRA     decodeAddDnEA
*    ------------------------------------------------------------

add_W_EA   
    MOVE.B  #'A',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    MOVE.B  #1,D7           Word Size
    BRA     decodeAddDnEA
*    ------------------------------------------------------------

add_L_EA   
    MOVE.B  #'A',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'L',(A2)+
    MOVE.B  #2,D7           Long Size
    BRA     decodeAddDnEA
*    ------------------------------------------------------------

decodeAddDnEA
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
*    ------------------------------------------------------------

    CLR     D1
    MOVE.B  #0,D1           Always Dn format
    LEA     modeTable,A6
    JSR     (A6,D1)
*    ------------------------------------------------------------

    JSR     get_9to11_bit
*    ------------------------------------------------------------ 

*    Check D2: mode value for immediate or Absolute addressing

    CMP.B   #7,D2
    BEQ     immAb0010
*    ------------------------------------------------------------

    MOVE.B  #',',(A2)+  comma between operands
*    ------------------------------------------------------------

    JSR     get_3to5_bit
*    ------------------------------------------------------------

    JSR     get_0to2_bit
*    ------------------------------------------------------------

*    end of decoding

*    ------------------------------------------------------------

*    printing          

    BRA     printCode
*    ------------------------------------------------------------

immAbAddDnEA
*    Check for #imm or Absolute addressing with D1: register value

    CMP     #4,D1      if immediate data
    BEQ     adjustimmAbAddDnEA
immAbJumpAddDnEA
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     printCode
adjustimmAbAddDnEA
    SUB.B   D7,D1
    BRA     immAbJumpAddDnEA
*    ------------------------------------------------------------

*    end of ADD <EA>,Dn          

*    ------------------------------------------------------------

*    ADDA

*    ------------------------------------------------------------    

adda_W  
    MOVE.B  #'A',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'A',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    MOVE.B  #1,D7           Word Size
    BRA     decodeAdda
*    ------------------------------------------------------------

adda_L  
    MOVE.B  #'A',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'D',(A2)+
    MOVE.B  #'A',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'L',(A2)+
    MOVE.B  #2,D7           Long Size
    BRA     decodeAdda
*    ------------------------------------------------------------

decodeAdda
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
    BEQ     immAbAdda
*    ------------------------------------------------------------

desdecodeAdda   
    MOVE.B  #',',(A2)+  comma between operands
*    ------------------------------------------------------------

    CLR     D1
    MOVE.B  #8,D1           Always An format
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

immAbAdda
*    Check for #imm or Absolute addressing with D1: register value

    CMP     #4,D1      if immediate data
    BEQ     adjustimmAbAdda
immAbJumpAdda
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     desdecodeAdda
adjustimmAbAdda
    SUB.B   D7,D1
    BRA     immAbJumpAdda
*    ------------------------------------------------------------

*    end of ADDA 

*    ------------------------------------------------------------

*    end of file

*    ------------------------------------------------------------














*    ~Font name~Courier New~

*    ~Font size~10~

*    ~Tab type~1~

*    ~Tab size~4~

