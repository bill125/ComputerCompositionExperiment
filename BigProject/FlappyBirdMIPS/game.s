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

LI R0 0xFF10
MTSP R0
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
    LI R1 0x0C   ;图片地址
    SLL R1 R1 0x00
    ADDIU R1 0x80
    LI R2 0x80   ;显存地址
    SLL R2 R2 0x00
    LI R3 0x00   ;I=0
FOR_I:   ;I=0~239
    LI R4 0x00   ;J=0
FOR_J:   ;J=0~160
    ADDIU R1 0x01
    ADDIU R2 0x01
    LW R1 R5 0x00
    SW R2 R5 0x00

    LI R5 0x9F   ;R5=159
    SLT R5 R4    ;159<R4
    BTEQZ FOR_J

    LI R5 0xEF   ;R5=239
    SLT R5 R3    ;239<R3
    BTEQZ FOR_I

;	LW R0   ;PRINT END
	JR R7

PRINT_BIRD:
    SW_SP R0 0x0000
    SW_SP R1 0x0001
    SW_SP R2 0x0002
    SW_SP R3 0x0003
    SW_SP R4 0x0004
    SW_SP R5 0x0005
    SW_SP R6 0x0006
    SW_SP R7 0x0007
    ADDSP 0x0008
    
; 0000~1FFF: code
; 2000~207F: bird0       (16*16)
; 2080~20FF: bird1       (16*16)
; 2100~217F: bird2       (16*16)

    LI R6 0xFE20 ; mem_addr = 0xFE20  <- bird status
    LW R6 R3 0x0000
    LI R6 0x2000 
    BEQZ R3 0x0005 ; bird_status >= 1
    ADDIU R3 0xFFFF
    ADDIU R6 0x0080
    BEQZ R3 0x0002 ; bird_status = 2
    ADDIU R6 0x0080

    LI R0 0x0000 ; i = 0
    LI R1 0x8000 ; Graphics Disk
FOR_BIRD_I:                                                                         

    ADDIU R0 0x0001 ; ++ i


    ADDSP 0xFFF8
    LW_SP R0 0x0000
    LW_SP R1 0x0001
    LW_SP R2 0x0002
    LW_SP R3 0x0003
    LW_SP R4 0x0004
    LW_SP R5 0x0005
    LW_SP R6 0x0006
    LW_SP R7 0x0007
    JR R7
    