*    -----------------------------------------------------------

*    Title      :

*    Written by :

*    Date       :

*    Description:

*    -----------------------------------------------------------

op0100      *MOVEM, JSR,LEA,RTS,NOP
*    -CLR and MOVEM CHECK if its CLR or moveM
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
*    

*    

*    CMP.B   #hex_2,D3

*    BEQ     moveM_W ;MOVEM.W

*    

*    CMP.B   #hex_3,D3

*    BEQ     moveM_L ;MOVEM.L


*    ---------------------------------------------------------

*    Check NOP - $4E71 constant value

*    ---------------------------------------------------------  

    CMP.W   #$4E71,D6
    BEQ     _NOP
*    ---------------------------------------------------------

*    Check RTS - $4E75 constant value

*    ---------------------------------------------------------

    CMP.W   #$4E75,D6   ;see if it's a RTS
    BEQ     _RTS        branch to RTS
*    ---------------------------------------------------------

*    Check LEA - 6to8 bit %111

*    ---------------------------------------------------------

    CLR     D2
    MOVE.W  D6,D2       MOVE the original machine code to D2 to play with
    LSL.W   #7,D2       BIT* **** **** 0000
    LSR.W   #8,D2       0000 0000 BIT* ****
    LSR.W   #5,D2       0000 0000 0000 0BIT
    CMP.B   #7,D2
    BEQ     _LEA        branch to LEA
    
*    JSR check_clr_or_moveM

*    CMP.B   #hex_8,D3

*    BEQ     clr_B   ;clr.B

*    CMP.B   #hex_9,D3

*    BEQ     clr_W   ;clr.W

*    CMP.B   #hex_A,D3

*    BEQ     clr_L   ;clr.L

    
    
    CMP.B   #hex_2,D3    ;see if it's a MOVEM.W

    BEQ     _movemW     ;branch   

    CMP.B   #$4,D3    ;see if it's a MOVEM.L

    BEQ     _movemL

*    ---------------------------------------------------------

*    Check JSR  

*    ---------------------------------------------------------

*    1. $4EB8 constant value => (XXX).W

    CMP.W   #$4EB8,D6   ;see if it's a JSR
    BEQ     _JSR
*    2. $4EB9 constant value => (XXX).L

    CMP.W   #$4EB9,D6   ;see if it's a JSR
    BEQ     _JSR
*    3. $4EA0 ~ $4EA7        => (An)

    CMP.W   #$4EA7,D6   ;see if it's a JSR
    BLS     _JSR
    ;branch
*    determine if contents in D3 are a word or long ---------- 

    ;JSR     WorL
*    ---------------------------------------------------------

    ;CMP.B   #hex7,D3    ;see if it's a LEA
    ;BEQ     _lea        ;branch
    
*    determine if contents in D3 are either CLR or MOVEM ----- 

    ;JSR     clrORmm
*    ---------------------------------------------------------

    ;CMP.B   #hex2,D3    ;see if it's a MOVEM.W
    ;BEQ     _movemW     ;branch
    ;CMP.B   #hex3,D3    ;see if it's a MOVEM.L
    ;BEQ     _movemL     ;branch
    
    ;BRA     opError     ;bad opcode branch to error
    
    
*    ---------------------------------------------------------    
_movemW

    MOVE.B  #' ',(A2)+
    MOVE.B  #'M',(A2)+      ;print spaces
    MOVE.B  #'O',(A2)+      ;print R
    MOVE.B  #'V',(A2)+      ;print T
    MOVE.B  #'E',(A2)+      ;print S
    MOVE.B  #'M',(A2)+      ;print spaces
    MOVE.B  #'.',(A2)+      ;print spaces
    MOVE.B  #'W',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces

    BRA DecodeDr

*    ---------------------------------------------------------
_movemL

    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #'M',(A2)+      ;print spaces
    MOVE.B  #'O',(A2)+      ;print R
    MOVE.B  #'V',(A2)+      ;print T
    MOVE.B  #'E',(A2)+      ;print S
    MOVE.B  #'M',(A2)+      ;print spaces
    MOVE.B  #'.',(A2)+      ;print spaces
    MOVE.B  #'L',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces

    BRA DecodeDr
*    ---------------------------------------------------------
DecodeDr
* decode bit 10 for direction
    * bit 10 : 0 => RtoM 1=>MtoR
    CLR.L   D0
    MOVE.W  D6,D0           **** *X** **** **** 
    SWAP    D0              **** **** **** *X**
    CLR.L   D1
    MOVE.B  D0,D1           *X**
    LSL.B   #1,D1           X**0
    LSR.B   #3,D1           000X
    CLR.L   D7
    MOVE.B  D1,D7           D7 holds the bit 10: dr
    CMP.B   #0,D1           
    BEQ     RtoM            
    JSR     MtoR       

    
*    ---------------------------------------------------------
RtoM
    MOVE.B  #',',(A2)+
    CMP.B   #4,D2       
    BEQ     decodeListDesc      predecrement
    BNE     decodeListAsc       both controlmode/postincrement

*    ---------------------------------------------------------
RtoMEA
    JSR     get_3to5_bit
    JSR     get_0to2_bit    
*    ---------------------------------------------------------
*    Only Absolute addressing
    CMP.B   #7,D2
    BEQ     immAbRtoM
*    ---------------------------------------------------------
*    end of decoding
*    ------------------------------------------------------------
*    printing  
    BRA printCode
*    ------------------------------------------------------------
immAbRtoM
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     printCode
*    ------------------------------------------------------------
*    End of RtoM
*    ------------------------------------------------------------


MtoR    
*    ---------------------------------------------------------
    JSR     get_3to5_bit
    JSR     get_0to2_bit    
*    ---------------------------------------------------------
*    Only Absolute addressing
    CMP.B   #7,D2
    BEQ     immAbMtoR
*    ---------------------------------------------------------
    MOVE.B  #',',(A2)+
    CMP.B   #4,D2       
    BEQ     decodeListDesc      predecrement
    BNE     decodeListAsc       both controlmode/postincrement
*    ---------------------------------------------------------
*    end of decoding
*    ------------------------------------------------------------
immAbMtoR
    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     printCode
*    ------------------------------------------------------------
*    End of MtoR
*    ------------------------------------------------------------
*   decodeList
*    ------------------------------------------------------------
decodeListAsc
* bit 0 to 7, going D0 to D7
    MOVE.L  D4,D5
    LSR.L   #8,D5
    LSR.L   #8,D5
    CLR.L   D2
FindSmallestD
    MOVE.W  D5,D3
    AND.B   #%0001,D3   check the smallest bit
    CMP.B   #1,D3
    BEQ     FoundSD
    LSR.W   #1,D5
    ADD.B   #1,D2           increment
    CMP.B   #8,D2           end of the loop compare
    BEQ     setupFindSA    end of the loop
    BNE     FindSmallestD   
FoundSD
*print
    MOVE.B  #'D',(A2)+
    LEA     numTable,A6
    CLR.L   D0
    MOVE.B  D2,D0
    MULS    #8,D0
    JSR     (A6,D0)
    MOVE.B  #'/',(A2)+
    ADD.B   #1,D2       increment
    LSR.W   #1,D5
    BRA     FindSmallestD
*    ------------------------------------------------------------    
* bit 8 to 15, going A0 to A7
setupFindSA    
    MOVE.L  D4,D5
    
    LSR.L   #8,D5
    LSR.L   #8,D5
    LSR.L   #8,D5
    CLR.L   D2
    CLR.L   D3
FindSA
    MOVE.W  D5,D3
    AND.B   #%0001,D3   check the smallest bit
    CMP.B   #1,D3
    BEQ     FoundSA
    LSR.W   #1,D5
    ADD.B   #1,D2       increment
    CMP.B   #8,D2       end of the loop compare
    BEQ     AfterList    end of the decodeListDesc
    BNE     FindSA
    
FoundSA
*print
    MOVE.B  #'A',(A2)+
    LEA     numTable,A6
    CLR.L   D0
    MOVE.B  D2,D0
    MULS    #8,D0
    JSR     (A6,D0)
    MOVE.B  #'/',(A2)+
    ADD.B   #1,D2       increment
    LSR.W   #1,D5
    BRA     FindSA
*    ------------------------------------------------------------ 
decodeListDesc
* bit 7 to 0, going A0 to A7
    MOVE.L  D4,D5
    LSR.L   #8,D5
    LSR.L   #8,D5
    CLR.L   D2
FindLargestA
    MOVE.W  D5,D3
    AND.W   #$F0,D3
    LSR.W   #7,D3
    CMP.B   #1,D3
    BEQ     FoundLA
    LSL.W   #1,D5
    ADD.B   #1,D2           increment
    CMP.B   #8,D2           end of the loop compare
    BEQ     setupFindLargestD    end of the loop
    BNE     FindLargestA
    
FoundLA
*print
    MOVE.B  #'A',(A2)+
    LEA     numTable,A6
    CLR.L   D0
    MOVE.B  D2,D0
    MULS    #8,D0
    JSR     (A6,D0)
    MOVE.B  #'/',(A2)+
    ADD.B   #1,D2       increment
    LSL.W   #1,D5
    BRA     FindLargestA
*    ------------------------------------------------------------    
* bit 15 to 8, going D0 to D7
setupFindLargestD    
    MOVE.L  D4,D5
    LSR.L   #8,D5
    LSR.L   #8,D5
    LSR.L   #8,D5
    CLR.L   D2
    CLR.L   D3
FindLargestD
    MOVE.W  D5,D3
    AND.W   #$F0,D3
    LSR.W   #7,D3
    CMP.B   #1,D3
    BEQ     FoundLD
    LSL.W   #1,D5
    ADD.B   #1,D2       increment
    CMP.B   #8,D2       end of the loop compare
    BEQ     AfterList    end of the decodeListDesc
    BNE     FindLargestD   
FoundLD
*print
    MOVE.B  #'D',(A2)+
    LEA     numTable,A6
    CLR.L   D0
    MOVE.B  D2,D0
    MULS    #8,D0
    JSR     (A6,D0)
    MOVE.B  #'/',(A2)+
    ADD.B   #1,D2       increment
    LSL.W   #1,D5
    BRA     FindLargestD
*    ------------------------------------------------------------ 
AfterList    
    CMP.B   #0,D7
    BEQ     RtoMEA          RtoM
    BNE     printCode       MtoR
*    ------------------------------------------------------------ 
*       End of MOVEM
*    ------------------------------------------------------------ 

*    NOP subroutine

*    ---------------------------------------------------------           

_NOP
    MOVE.L  #2,D7       ;data is not error
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #'N',(A2)+      ;print N
    MOVE.B  #'O',(A2)+      ;print O
    MOVE.B  #'P',(A2)+      ;print P
    MOVE.B  #3,D5           ;counter for output
    BRA     printCode
*    ---------------------------------------------------------

*    RTS subroutine

*    ---------------------------------------------------------

_RTS    
    MOVE.L  #2,D7       ;data is not error
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #'R',(A2)+      ;print R
    MOVE.B  #'T',(A2)+      ;print T
    MOVE.B  #'S',(A2)+      ;print S
    MOVE.B  #3,D5           ;counter for output
    BRA     printCode
*    ---------------------------------------------------------

*    LEA subroutine

*    ---------------------------------------------------------

_LEA    
    MOVE.L  #2,D7       ;data is not error
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #'L',(A2)+      ;print R
    MOVE.B  #'E',(A2)+      ;print T
    MOVE.B  #'A',(A2)+      ;print S
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #3,D5           ;counter for output
*    ---------------------------------------------------------

    JSR     get_3to5_bit
    JSR     get_0to2_bit
*    ---------------------------------------------------------            

*    Check D2: mode value for immediate or Absolute addressing

    CMP.B   #7,D2
    BEQ     immAbLEA
*    ---------------------------------------------------------

desDecodeLEA
    MOVE.B  #',',(A2)+  comma between operands
*    ---------------------------------------------------------

    LEA     modeTable,A6
    MOVE.B  #1,D0
    MULU    #8,D0       value adjusted for jumping
    LEA     modeTable,A6 Load the table into A6
    JSR     (A6,D0)     Jump to subroutine of value at D0
    
    JSR     get_9to11_bit
*    ---------------------------------------------------------

    BRA     printCode
*    ---------------------------------------------------------

*    JSR subroutine

*    ---------------------------------------------------------

_JSR
    MOVE.L  #2,D7       ;data is not error
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #'J',(A2)+      ;print J
    MOVE.B  #'S',(A2)+      ;print S
    MOVE.B  #'R',(A2)+      ;print R
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #3,D5           ;counter for output
    JSR     get_3to5_bit
    JSR     get_0to2_bit
*    ------------------------------------------------------------

*    Check D2: mode value for immediate or Absolute addressing

    CMP.B   #7,D2
    BEQ     immAbJSR
    BRA     printCode
    
    
*    ---------------------------CLR.B


*    ----------------------------------------------------------- 

*    CLR.B -----------------------------------------------------           

clr_B       ;CLR.B
    MOVE.B  D6,D3       ;copy data to D3
    LSL.B   #5,D3       ;shift d3 to clear
    LSR.B   #5,D3       ;shift back to bit 0-2
    CMP.B   #%100,D3    ;compare to immediate data

    ;Print/store CLR.B here
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'C',(A2)+  ;print C
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'B',(A2)+  ;print B
    MOVE.B  #' ',(A2)+  ;print some spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+

    
    *-get bit 3 to 5
    JSR get_3to5_bit
    JSR get_0to2_bit


    BRA     printCode
    
    
clr_W       ;CLR.W
    MOVE.B  D6,D3       ;copy data to D3
    LSL.B   #5,D3       ;shift d3 to clear
    LSR.B   #5,D3       ;shift back to bit 0-2
    CMP.B   #%100,D3    ;compare to immediate data

    ;Print/store CLR.B here
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'C',(A2)+  ;print C
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'W',(A2)+  ;print W
    MOVE.B  #' ',(A2)+  ;print some spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+

    
    *-get bit 3 to 5
    JSR get_3to5_bit
    JSR get_0to2_bit

    BRA     printCode
    
clr_L       ;CLR.L
    MOVE.B  D6,D3       ;copy data to D3
    LSL.B   #5,D3       ;shift d3 to clear
    LSR.B   #5,D3       ;shift back to bit 0-2
    CMP.B   #%100,D3    ;compare to immediate data

    ;Print/store CLR.B here
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+
    MOVE.B  #'C',(A2)+  ;print C
    MOVE.B  #'L',(A2)+  ;print L
    MOVE.B  #'R',(A2)+  ;print R
    MOVE.B  #'.',(A2)+  ;print .
    MOVE.B  #'L',(A2)+  ;print B
    MOVE.B  #' ',(A2)+  ;print some spaces
    MOVE.B  #' ',(A2)+
    MOVE.B  #' ',(A2)+

    
    *-get bit 3 to 5
    JSR get_3to5_bit
    JSR get_0to2_bit
    BRA     printCode
*    ------------------------------------------------------------

immAbJSR
*    Absolute addressing only

    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     printCode
immAbLEA
*    Absolute addressing only

    LEA     immAbTable, A6
    MULU    #8,D1
    JSR     (A6,D1)
    BRA     desDecodeLEA
*    ------------------------------------------------------------
check_clr_or_moveM:
    CLR.L   D3
    MOVE.W  D6,D3
    AND.W   #$0FF0,D3
    LSR.W   #6,D3
    AND.W   #$000F,D3
    RTS
*    -----------------------------------------------------------




*    ------------------------------------------------------------
*       End of file
*    ------------------------------------------------------------







*    ~Font name~Courier New~

*    ~Font size~10~

*    ~Tab type~1~

*    ~Tab size~4~




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
