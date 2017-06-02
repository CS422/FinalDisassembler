op1000 *-DIVU.W OR
    MOVE.B  #' ',(A2)+  ;print some spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
*    ------------------------------------------------------------

    JSR WordOrLong
*    ------------------------------------------------------------        

    CMP.B   #$01,D3
    BEQ     or_W    EA,Dn
    
    CMP.B   #$02,D3
    BEQ     or_L    EA,Dn
    
    CMP.B   #$00,D3
    BEQ     or_B    EA,Dn
    
    CMP.B   #$04,D3
    BEQ     or_B_EA Dn,EA
    
    CMP.B   #$05,D3
    BEQ     or_W_EA Dn,EA
    
    CMP.B   #$06,D3
    BEQ     or_L_EA Dn,EA
    
*    ------------------------------------------------------------                

    CMP.B   #$03,D3
    BEQ     divu_W
*    ------------------------------------------------------------        

divu_W
    ;do something effective
    CLR     D3          ;clear D3
    MOVE.W  D6,D3       ;copy data to D3
    ;MOVE.L  #1,D7       ;size of data is word
*    ------------------------------------------------------------        

    ;Print/store DIVU.W here
    MOVE.B  #'D',(A2)+  ;print D
    MOVE.B  #'I',(A2)+  ;print I
    MOVE.B  #'V',(A2)+  ;print V
    MOVE.B  #'U',(A2)+  ;print U
    MOVE.B  #'.',(A2)+  ;ptint .
    MOVE.B  #'W',(A2)+  ;print W
    MOVE.B  #' ',(A2)+  ;print some spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #10,D5      ;counter for output
*    ------------------------------------------------------------

    JSR     get_3to5_bit
*    ------------------------------------------------------------

    JSR     get_0to2_bit
*    ------------------------------------------------------------

*    Check D2: mode value for immediate or Absolute addressing

    CMP.B   #7,D2
    BEQ     immAbDIVU_W
*    ------------------------------------------------------------

desDecodeDIVU_W   
    MOVE.B  #',',(A2)+  comma between operands
*    ------------------------------------------------------------

    CLR     D1
    LEA     modeTable,A6
    MOVE.B  #0,D1       Always Dn format
    JSR     (A6,D1)
*    ------------------------------------------------------------

    JSR     get_9to11_bit
*    ------------------------------------------------------------       

*    end of decoding

*    ------------------------------------------------------------

*    printing          

    BRA     printCode
*    ------------------------------------------------------------

immAbDIVU_W
*    Check for #imm or Absolute addressing with D1: register value

    CMP     #4,D1      if immediate data
    BEQ     adjustimmAbDIVU_W
immAbJumpDIVU_W            
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     desDecodeDIVU_W
adjustimmAbDIVU_W
    CLR     D1
    MOVE.B  #3,D1         immdiateData WORD always
    BRA     immAbJumpDIVU_W
*    ------------------------------------------------------------

*    end of DIVU.W            

*    ------------------------------------------------------------

*    OR <EA>,Dn

*    ------------------------------------------------------------

or_B
    MOVE.B  #'O',(A2)+
    MOVE.B  #'R',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'B',(A2)+
    MOVE.B  #0,D7       byte size
    BRA     decodeOReaDn
*    ------------------------------------------------------------

or_W
    MOVE.B  #'O',(A2)+
    MOVE.B  #'R',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    MOVE.B  #1,D7       Word Size
    BRA     decodeOReaDn
*    ------------------------------------------------------------

or_L
    MOVE.B  #'O',(A2)+
    MOVE.B  #'R',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'L',(A2)+
    MOVE.B  #2,D7       Long Size
    BRA     decodeOReaDn
*    ------------------------------------------------------------

decodeOReaDn
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

desDecodeOReaDn   
    MOVE.B  #',',(A2)+  comma between operands
*    ------------------------------------------------------------

    CLR     D1
    LEA     modeTable,A6
    MOVE.B  #0,D1       Always Dn format
    JSR     (A6,D1)
*    ------------------------------------------------------------

    JSR     get_9to11_bit
*    ------------------------------------------------------------       

*    end of decoding

*    ------------------------------------------------------------

*    printing          

    BRA     printCode
*    ------------------------------------------------------------

immAbOReaDn
*    Check for #imm or Absolute addressing with D1: register value

    CMP     #4,D1      if immediate data
    BEQ     adjustimmAbOReaDn
immAbJumpOReaDn            
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     desDecodeOReaDn
adjustimmAbOReaDn
    SUB     D7,D1
    BRA     immAbJump0010
*    ------------------------------------------------------------

*    end of OR <EA>,Dn            

*    ------------------------------------------------------------

*    OR Dn,<EA>

*    ------------------------------------------------------------ 

or_B_EA
    MOVE.B  #'O',(A2)+
    MOVE.B  #'R',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'B',(A2)+
    MOVE.B  #0,D7       byte size
    BRA     decodeORDnea
*    ------------------------------------------------------------

or_W_EA
    MOVE.B  #'O',(A2)+
    MOVE.B  #'R',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'W',(A2)+
    MOVE.B  #1,D7       Word Size
    BRA     decodeORDnea
*    ------------------------------------------------------------

or_L_EA
    MOVE.B  #'O',(A2)+
    MOVE.B  #'R',(A2)+
    MOVE.B  #'.',(A2)+
    MOVE.B  #'L',(A2)+
    MOVE.B  #2,D7       Long Size
    BRA     decodeORDnea
*    ------------------------------------------------------------

decodeORDnea
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
*    ------------------------------------------------------------

    CLR     D1
    LEA     modeTable,A6
    MOVE.B  #0,D1       Always Dn format
    JSR     (A6,D1)
*    ------------------------------------------------------------

    JSR     get_9to11_bit
*    ------------------------------------------------------------  

    MOVE.B  #',',(A2)+  comma between operands
*    ------------------------------------------------------------

    JSR     get_3to5_bit
*    ------------------------------------------------------------

    JSR     get_0to2_bit
*    ------------------------------------------------------------

*    Check D2: mode value for immediate or Absolute addressing

    CMP.B   #7,D2
    BEQ     immAb0010
*    ------------------------------------------------------------   

*    end of decoding

*    ------------------------------------------------------------

*    printing          

    BRA     printCode
*    ------------------------------------------------------------

immAbORDnea
*    Check for #imm or Absolute addressing with D1: register value

    CMP     #4,D1      if immediate data
    BEQ     adjustimmAbORDnea
immAbJumpORDnea            
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     printCode
adjustimmAbORDnea
    SUB     D7,D1
    BRA     immAbJump0010
*    ------------------------------------------------------------

*    end of OR Dn,<EA>            

*    ------------------------------------------------------------

*    end of file

*    ------------------------------------------------------------ 

    
    
    
    
    






*    ~Font name~Courier New~

*    ~Font size~10~

*    ~Tab type~1~

*    ~Tab size~4~

