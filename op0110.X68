op0110      *BRA, Bcc(BCC,BLT,BGE)
*    decode 8_11 bits => condition

*    decode 0_7  bits => displacement(8-bit)

*    if displacement = $00 => 16 bit displacement

*    if displacement = $FF => 32 bit displacement

    MOVE.L  #2,D7       ;data is not error
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
*    ---------------------------------------------------------

*    Check 8_11 bits - 0000 => BRA

*    ---------------------------------------------------------      

    MOVE.W  D6,D2
    LSL.W   #4,D2
    LSR.W   #8,D2
    LSR.W   #4,D2
    MOVE.B  D2,D0
    CMP.W   #0,D0
    BEQ     _BRA
*    ---------------------------------------------------------

*    Check Bcc 

*    ---------------------------------------------------------

*    1. condition = 4 => BCC

    CMP.W   #4,D0   ;see if it's a BCC
    BEQ     _BCC
*    2. condition = D => BLT

    CMP.W   #$D,D0   ;see if it's a BLT
    BEQ     _BLT
*    3. condition = C => BGE

    CMP.W   #$C,D0   ;see if it's a BGE
    BLS     _BGE
*    ---------------------------------------------------------

*    BRA subroutine

*    ---------------------------------------------------------           

_BRA
    MOVE.B  #'B',(A2)+      ;print B
    MOVE.B  #'R',(A2)+      ;print R
    MOVE.B  #'A',(A2)+      ;print A
    BRA     displacementDecode
*    ---------------------------------------------------------

*    BCC subroutine

*    ---------------------------------------------------------

_BCC
    MOVE.B  #'B',(A2)+      ;print B
    MOVE.B  #'C',(A2)+      ;print C
    MOVE.B  #'C',(A2)+      ;print C
    BRA     displacementDecode
*    ---------------------------------------------------------

*    BLT subroutine

*    ---------------------------------------------------------

_BLT
    MOVE.B  #'B',(A2)+      ;print B
    MOVE.B  #'L',(A2)+      ;print L
    MOVE.B  #'T',(A2)+      ;print T
    BRA     displacementDecode
*    ---------------------------------------------------------

*    BGE subroutine

*    ---------------------------------------------------------

_BGE
    MOVE.B  #'B',(A2)+      ;print B
    MOVE.B  #'G',(A2)+      ;print G
    MOVE.B  #'E',(A2)+      ;print E
    BRA     displacementDecode
*    ---------------------------------------------------------

displacementDecode
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #' ',(A2)+      ;print spaces
    MOVE.B  #3,D5           ;counter for output
*    get 0 to 7 bits

    CLR     D0
    MOVE.B  D6,D0
*    1. Check $00 => 16-bit displacement

    CMP.B   #$00, D0
    BEQ     _16_bitD
*    2. Check $FF => 32-bit displacement

    CMP.B   #$FF, D0
    BEQ     _32_bitD
*    otherwise => 8 -bit displacement ( 0to7 bit decoding)

    
    MOVE.B  #'$',(A2)+
    ADDA    D0,A5
    CLR.L   D4
    MOVE.W  A5,D4
    JSR     print_Address
    BRA     printCode
    
*    D4 has 32 bit displacement value

_16_bitD
    MOVE.L  D4,D0
    LSR.L   #8,D0
    LSR.L   #8,D0
    *MULU    #8,D0
    *MOVE.B  #'$',(A2)+
    ADDA    D0,A5
    CLR.L     D4
    MOVE.W  A5,D4
    JSR     IA000
    BRA     printCode

_32_bitD
    MOVE.L  D4,D0
    JSR     IA001
    BRA     printCode
*    ---------------------------------------------------------

*    end of decoding

*    ---------------------------------------------------------

    BRA     printCode
*    ---------------------------------------------------------

print_Address
*    ---X***

    MOVE.W  D0,D3
    LSR.W   #8,D3
    LSR.W   #4,D3
    MULU.W  #8,D3
    LEA     numTable,A6
    JSR     (A6,D3)
*    ---*X**

    CLR     D3
    MOVE.W  D0,D3
    LSL.W   #4,D3
    LSR.W   #8,D3
    LSR.W   #4,D3
    MULU.W  #8,D3
    LEA     numTable,A6
    JSR     (A6,D3)
*    ---**X*

    CLR     D3
    MOVE.W  D0,D3
    LSL.W   #8,D3
    LSR.W   #8,D3
    LSR.W   #4,D3
    MULU.W  #8,D3
    LEA     numTable,A6
    JSR     (A6,D3)
*    ---***X

    CLR     D3
    MOVE.W  D0,D3
    LSL.W   #4,D3
    LSL.W   #8,D3
    LSR.W   #8,D3
    LSR.W   #4,D3
    MULU.W  #8,D3
    LEA     numTable,A6
    JSR     (A6,D3)
    RTS
*    ------------------------------------------------------------

*    end of file            

*    ------------------------------------------------------------

    











*    ~Font name~Courier New~

*    ~Font size~10~

*    ~Tab type~1~

*    ~Tab size~4~

