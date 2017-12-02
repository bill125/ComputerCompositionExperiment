; 0xFE00 - bird_coordinateY 
; 0xFE01 - bird_velocity 
; 0xFE02 - bird_status  
; 0xFE03 - pipe0_coordinateX
; 0xFE04 - pipe0_height
; 0xFE05 - pipe1_coordinateX
; 0xFE06 - pipe1_height
; 0xFE07 - ground_coordinateX

; 颜色格式:
; RRRGGBBB
; 地址:
; 0000~1FFF: code
; 2000~207F: bird1       (16*16)
; 2080~20FF: bird2       (16*16)
; 2100~217F: bird3       (16*16)
; 2180~227F: pipe        (32*16)
; 2280~2C7F: ground      (160*32)
; 2C80~777F: background  (160*240)

; FF02 事件
;   0x00 没事
;   0x10 时间
;   0x2X 键盘

B START

START:
	LI R0 0x00BF 
	SLL R0 R0 0x0000
	ADDIU R0 0x10   ;R0=0xBF10 
	MTSP R0
    
PRINT_LOOP:
	MFPC R7 
	ADDIU R7 0x0002
    B PRINT
    B PRINT_LOOP

PRINT:
    LI R1 0x2C   ;图片地址
    SLL R1 R1 0x00
    ADDIU R1 0x80
    LI R2 0x80   ;显存地址
    SLL R2 R2 0x00
    LI R3 0x00   ;I=0
FOR_I:   ;I=0~239
    LI R4 0x00   ;J=0
    ADDIU R3 0x01
FOR_J:   ;J=0~80
    ADDIU R1 0x01
    ADDIU R2 0x01
    ADDIU R4 0x01
    LW R1 R5 0x00  ;21
    SW R2 R5 0x00

    LI R5 0x4F   ;R5=79
    SLT R5 R4    ;79<R4
    BTEQZ FOR_J

    LI R5 0xEF   ;R5=239
    SLT R5 R3    ;239<R3
    BTEQZ FOR_I

	JR R7   ;PRINT END

LI R0 0xFF10
MTSP R0
B START

START:
	LI R0 0x00BF 
	SLL R0 R0 0x0000
	ADDIU R0 0x10   ;R0=0xBF10 
	MTSP R0
    
; 0000~1FFF: code
; 2000~207F: bird0       (16*16)
; 2080~20FF: bird1       (16*16)
; 2100~217F: bird2       (16*16)


PRINT_BIRD:
    SW_SP R0 0x00
    SW_SP R1 0x01
    SW_SP R2 0x02
    SW_SP R3 0x03
    SW_SP R4 0x04
    SW_SP R5 0x05
    SW_SP R6 0x06
    SW_SP R7 0x07
    ADDSP 0x08

    LI R6 0xFE
    SLL R6 R6 0x00
    ADDIU R6 0x20 ; R6 = 0xFE20  <- bird status
    LW R6 R3 0x00

    LI R5 0x20
    SLL R5 R5 0x00 ; R5 = 0x2000 

    BEQZ R3 BIRD_END_IF ; if bird_status >= 1
    ADDIU R3 0xFF
    ADDIU R5 0x40
    ADDIU R5 0x40

    BEQZ R3 BIRD_END_IF ; if bird_status = 2
    ADDIU R5 0x40
    ADDIU R5 0x40
BIRD_END_IF: ; R5 = bird_pic

    LI R6 0xFE
    SLL R6 R6 0x00 ; R6 = 0xFE00
    LW R6 R3 0x00 ; R3 = bird_coordinateY

    LI R0 0x00
    LI R6 0x80 
    SLL R6 R6 0x00 ; R1 = 0x8000
BIRD_ADDR_JUMP:
    ADDIU R6 0x40 ; next line
    ADDIU R0 0x01 ; ++ R0
    SLT R0 R3 ; if R0 < bird_coordinateY
    BTEQZ BIRD_ADDR_JUMP

    ; bird_pic address in R5
    ; target line head address in R6
    LI R0 0x00 ; R0 = 0
BIRD_COPY_LOOP:
    ADDIU3 R6 R4 0x10 ; R4 = target address
    LI R1 0x00 ; R1 = 0
BIRD_COPY_LINE_LOOP:
    ; Brute Force Copy
    ; LW R5 R2 0x00 ; R2 = Target Pic Color
    ; SW R4 R2 0x00 ; Store R2 to R4

    ; Selective Replace
    ; High - 8
    LW R5 R2 0x00
    SRA R2 R2 0x00
    LI R7 0xFF
    AND R2 R7 ; get high-8 bits
    ADDIU R2 0x01 ; Transparent Pixel
    BNEZ R2 0x03
    LW R4 R2 0x00 ; Use Previous
    B 0x03
    ADDIU R2 0xFF ; Use New
    SLL R2 R2 0x00

    ; Low - 8
    LW R5 R3 0x00
    LI R7 0xFF
    AND R3 R7 ; get low-8 bits
    ADDIU R3 0x01 ; Transparent Pixel
    BNEZ R3 0x06
    LW R4 R7 0x00 ; Use Previous
    LI R3 0xFF
    AND R7 R3
    ADDU R2 R7 R2;
    B 0x03
    ADDIU R3 0xFF ; Use New
    ADDU R2 R3 R2

    SW R4 R2 0x00 ; Store R2 to R4
 
    ADDIU R5 0x01 ; ++ R5
    ADDIU R1 0x01 ; ++ R1
    SLTUI R1 0x08 ; if R1 < 8
    BTEQZ 0x02 ; loop
    B BIRD_COPY_LINE_LOOP 

    ADDIU R6 0x40 ; R6 jump line
    ADDIU R0 0x01 ; ++ R0
    SLTUI R0 0x10 ; if R0 < 16
    BTEQZ 0x02 ; loop
    B BIRD_COPY_LOOP 

    ADDSP 0xF8
    LW_SP R0 0x00
    LW_SP R1 0x01
    LW_SP R2 0x02
    LW_SP R3 0x03
    LW_SP R4 0x04
    LW_SP R5 0x05
    LW_SP R6 0x06
    LW_SP R7 0x07
    JR R7
    
    