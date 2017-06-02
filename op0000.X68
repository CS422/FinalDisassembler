op0000  ;ADDI
    **----------------------------------------
    *decode what type of opcode/size it is
    *- using decode0000 there will only be a couple static options in D3 to compare
    *-D3:
    *-#$18 -> ANDI.B
    *-#$19 ->ANDI.W
    *-#$1A -> ANDI.L
*    ----------------------------------------

    JSR decode0000
*    ---------------------------------------- 

    MOVE.B  #' ',(A2)+  ;print
    MOVE.B  #' ',(A2)+  ;print
    MOVE.B  #' ',(A2)+  ;print
    MOVE.B  #' ',(A2)+  ;print
*    ----------------------------------------

    CMP.B   #$18,D3     ;see if it's a ADDI.B
    BEQ     addi_B
*    

    CMP.B   #$19,D3     ;see if it's a ADDI.W
    BEQ     addi_W
    CMP.B   #$1A,D3     ;see if it's a ADDI.L
    BEQ     addi_L
*    ----------------------------------------

    CMP.B   #$10,D3 SUBI.B  #$66,(A2)+
    BEQ     subi_B_
    
    CMP.B   #$11,D3 SUBI.W  #$66,(A2)+
    BEQ     subi_W_
    
    CMP.B   #$12,D3 SUBI.L  #$66,(A2)+
    BEQ     subi_L_
*    ----------------------------------------    

    JSR finish
*    ----------------------------------------

*    ADDI

*    ----------------------------------------

addi_B
    MOVE.B  D6, D3 [ 0000 0000 [USES] [USES] ] D6 ->d3
    *- GET the register Value [ 0000 0XXX ]
*    LSL.B   #5,D3

*    LSR.B   #5,D3       got it here

*    

    *-immediate data not allowed here

    *-Because we know this is ADDi.B we know that out data following this opcode
    *-is of size B, so we can now grab that data, look at it and print it out
    
    *temporary store out data in memory
    
    *-MOVE machine code into temp D2
    MOVE.W  D6,D2
    ;MOVEA.W D6,A5       ; BUGGG LOOK BELOW WHWERE DO WE STORE OUR ABS IMM DATA IN ????
    *MOVE.W  (A4)+,D6 ;i forgot where we store our data in memory
    ;MOVE.W  D6,D3   Move the data back into D3 to play with
    
    *-MOVE the word/bytte data at D4 into D3
    ;MOVE.W  D4,D3
    MOVE.B  #'A',(A2)+  ;print A
    MOVE.B  #'D',(A2)+  ;print D
    MOVE.B  #'D',(A2)+  ;print
    MOVE.B  #'I',(A2)+  ;print
    MOVE.B  #'.',(A2)+  ;print
    MOVE.B  #'B',(A2)+  ;print
    CLR     D7
    MOVE.B  #0,D7       Byte size
    BRA     ADDIdecode
*    ------------------------------------------------------------

addi_W
*    ------------------------------------------------------------

    MOVE.B  D6, D3
    MOVE.W  D6,D2
    *MOVE.W  (A4)+,D6
*    ------------------------------------------------------------  

    MOVE.B  #'A',(A2)+  ;print A
    MOVE.B  #'D',(A2)+  ;print D
    MOVE.B  #'D',(A2)+  ;print
    MOVE.B  #'I',(A2)+  ;print
    MOVE.B  #'.',(A2)+  ;print
    MOVE.B  #'W',(A2)+  ;print
    CLR     D7
    MOVE.B  #1,D7       Word size
    BRA     ADDIdecode
*    ------------------------------------------------------------

addi_L
*    ------------------------------------------------------------

    MOVE.B  D6, D3 [ 0000 0000 [USES] [USES] ] D6 ->d3
    *- GET the register Value [ 0000 0XXX ]
    LSL.B   #5,D3
    LSR.B   #5,D3       got it here
    
    *-immediate data not allowed here

    *-Because we know this is ADDi.B we know that out data following this opcode
    *-is of size B, so we can now grab that data, look at it and print it out
    
    *temporary store out data in memory
    ;MOVEA.W D6,A5       ; BUGGG LOOK BELOW WHWERE DO WE STORE OUR ABS IMM DATA IN ????
    ;MOVE.W  (A4)+,D6 ;i forgot where we store our data in memory
    *MOVE.L  (A4)+,D3 ;throw away just need to increment pointer here
    ;MOVE.L  D5,D3   Move the data back into D3 to play with
*    MOVE.W  D6,D5

*    MOVE.L  D3,D6

*    ------------------------------------------------------------  

    MOVE.B  #'A',(A2)+  ;print A
    MOVE.B  #'D',(A2)+  ;print D
    MOVE.B  #'D',(A2)+  ;print
    MOVE.B  #'I',(A2)+  ;print
    MOVE.B  #'.',(A2)+  ;print
    MOVE.B  #'L',(A2)+  ;print
    CLR     D7
    MOVE.B  #2,D7       Long size
    BRA     ADDIdecode
*    ------------------------------------------------------------

ADDIdecode 
    MOVE.B  #' ',(A2)+  ;print
    MOVE.B  #' ',(A2)+  ;print
    MOVE.B  #'#',(A2)+  ;print
    *MOVE.B  #'$',(A2)+  ;print
*    ------------------------------------------------------------

    CMP.B   #2,D7
    BEQ     printLongADDI
    JSR     IA000
    BRA     EAdecodeADDI
printLongADDI
    JSR     IA001
    BRA     EAdecodeADDI
*    ------------------------------------------------------------

EAdecodeADDI
    MOVE.B  #',',(A2)+
*    ------------------------------------------------------------

    JSR get_3to5_bit
*    ------------------------------------------------------------

    JSR get_0to2_bit
*    ------------------------------------------------------------

*    Check D2: mode value for immediate or Absolute addressing

    CMP.B   #7,D2
    BEQ     immAbADDI
*    ------------------------------------------------------------       

*    end of decoding

*    ------------------------------------------------------------

*    printing  

    BRA printCode
*    ------------------------------------------------------------

immAbADDI
*    Check for #imm or Absolute addressing with D1: register value

    CMP     #4,D1      if immediate data
    BEQ     adjustimmAbADDI
immAbJumpADDI
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     printCode
adjustimmAbADDI
    SUB.B   D7,D1
    BRA     immAbJumpADDI
*    ------------------------------------------------------------

*    End of ADDI

*    ------------------------------------------------------------

*    SUBI

*    ------------------------------------------------------------

subi_B_
    MOVE.W  D6,D2
    ;MOVEA.W D6,A5       ; BUGGG LOOK BELOW WHWERE DO WE STORE OUR ABS IMM DATA IN ????
    MOVE.W  (A4)+,D6 ;i forgot where we store our data in memory
    MOVE.B  #'S',(A2)+  ;print
    MOVE.B  #'U',(A2)+  ;print
    MOVE.B  #'B',(A2)+  ;print
    MOVE.B  #'I',(A2)+  ;print
    MOVE.B  #'.',(A2)+  ;print
    MOVE.B  #'B',(A2)+  ;print
    MOVE.B  #0,D7       Byte size
    BRA     SUBIdecode
*    ------------------------------------------------------------

subi_W_
    MOVE.W  D6,D2
    ;MOVEA.W D6,A5       ; BUGGG LOOK BELOW WHWERE DO WE STORE OUR ABS IMM DATA IN ????
    MOVE.W  (A4)+,D6 ;i forgot where we store our data in memory
    MOVE.B  #'S',(A2)+  ;print
    MOVE.B  #'U',(A2)+  ;print
    MOVE.B  #'B',(A2)+  ;print
    MOVE.B  #'I',(A2)+  ;print
    MOVE.B  #'.',(A2)+  ;print
    MOVE.B  #'W',(A2)+  ;print
    MOVE.B  #1,D7       Word size
    BRA     SUBIdecode
*    ------------------------------------------------------------

subi_L_
    MOVE.L  (A4)+,D3 ;throw away just need to increment pointer here
    MOVE.B  #'S',(A2)+  ;print
    MOVE.B  #'U',(A2)+  ;print
    MOVE.B  #'B',(A2)+  ;print
    MOVE.B  #'I',(A2)+  ;print
    MOVE.B  #'.',(A2)+  ;print
    MOVE.B  #'L',(A2)+  ;print
    MOVE.B  #2,D7       Long size
    BRA     SUBIdecode
*    ------------------------------------------------------------

SUBIdecode 
    MOVE.B  #' ',(A2)+  ;print
    MOVE.B  #' ',(A2)+  ;print
    MOVE.B  #'#',(A2)+  ;print
    *MOVE.B  #'$',(A2)+  ;print
*    ------------------------------------------------------------ 

    CMP.B   #2,D7
    BEQ     printLongSUBI
    JSR     IA000
*    MOVE.W  D2,D6

    BRA     EAdecodeSUBI
printLongSUBI   
    JSR     IA001
*    MOVE.W  D2,D6

    BRA     EAdecodeSUBI
*    ------------------------------------------------------------

EAdecodeSUBI
*    ------------------------------------------------------------

    MOVE.B  #',',(A2)+
*    ------------------------------------------------------------

    JSR get_3to5_bit
*    ------------------------------------------------------------

    JSR get_0to2_bit
*    ------------------------------------------------------------

*    Check D2: mode value for immediate or Absolute addressing

    CMP.B   #7,D2
    BEQ     immAbSUBI
*    ------------------------------------------------------------       

*    end of decoding

*    ------------------------------------------------------------

*    printing  

    BRA printCode
*    ------------------------------------------------------------

immAbSUBI
*    Check for #imm or Absolute addressing with D1: register value

    CMP     #4,D1      if immediate data
    BEQ     adjustimmAbSUBI
immAbJumpSUBI
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     printCode
adjustimmAbSUBI
    SUB.B   D7,D1
    BRA     immAbJumpSUBI
*    ------------------------------------------------------------

*    End of SUBI

*    ------------------------------------------------------------

decode0000
    *-this will put the bits 6 - 10 however add zeros
    CLR.L   D3
    MOVE.W  D6,D3
    AND.W   #$0FF0,D3   shortcut of zeroing the edges without shiting around
    ;[ 0000 1111 1111 0000]
    ;[ ZERO KEEP KEEP ZERO ]
    ;[
    LSR.W   #6,D3   [ 0000 1111 11XX XXXX ] -> [ 0000 0000 0011 1111 ]
    AND.W   #$00FF,D3   Cancel out any trailing bits
    RTS
*    ------------------------------------------------------------

*    End of file

*    ------------------------------------------------------------


    

    









*    ~Font name~Courier New~

*    ~Font size~10~

*    ~Tab type~1~

*    ~Tab size~4~

