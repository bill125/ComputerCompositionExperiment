;0000~1FFF - code
;2000~207F - bird1       (16*16)
;2080~20FF - bird2       (16*16)
;2100~217F - bird3       (16*16)
;2180~227F - pipe        (32*16)
;2280~2C7F - ground      (160*32)
;2C80~777F - background  (160*240)

;0xFE00 - bird_coordinateY 
;0xFE01 - bird_velocity 
;0xFE02 - bird_status
;0xFE03 - pipe0_coordinateX
;0xFE04 - pipe0_height
;0xFE05 - pipe1_coordinateX
;0xFE06 - pipe1_height
;0xFE07 - ground_coordinateX
;0xFE08 - game_status 0-on 1-over 2-pause
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
B START

START:
	LI R0 0x00FF 
	SLL R0 R0 0x0000
	ADDIU R0 0x10   ;R0=0xFF10 
	MTSP R0

    MFPC R7
    ADDIU R7 0x02
    B RESET_PARAMETERS

	MFPC R7
	ADDIU R7 0x0002
    B PRINT_BACKGROUND   ;绘制背景

    B PRINT_LOOP

PRINT_LOOP:
	MFPC R7
	ADDIU R7 0x0002
    B UPDATE_PARAMETERS   ;计算参数

    ; MFPC R7 
    ; ADDIU R7 0x02
    ; B DETECT_COLLISION ;Detect Collision

    LI R0 0xFE ;Dead | Alive  
    SLL R0 R0 0x00
    LW R0 R1 0x08

    BNEZ R1 GAME_OVER

	MFPC R7
	ADDIU R7 0x0002
    B PRINT_GROUND   ;绘制地板

	MFPC R7
	ADDIU R7 0x0002
    B PRINT_PIPE   ;绘制管道

	MFPC R7
	ADDIU R7 0x0002
    B PRINT_BIRD   ;绘制鸟

    B PRINT_LOOP

GAME_OVER:
    LI R0 0xFE ;Dead | Alive  
    SLL R0 R0 0x00
    LW R0 R1 0x08

    BEQZ R1 START

RESET_PARAMETERS:
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

    LI R0 0x00    ; 0xFE00
    SW R6 R0 0x00
    LI R0 0x00    ; 0xFE01
    SW R6 R0 0x01
    LI R0 0x00    ; 0xFE02
    SW R6 R0 0x02
    LI R0 0x00    ; 0xFE03
    SW R6 R0 0x03
    LI R0 0x00    ; 0xFE04
    SW R6 R0 0x04
    LI R0 0x00    ; 0xFE05
    SW R6 R0 0x05
    LI R0 0x00    ; 0xFE06
    SW R6 R0 0x06
    LI R0 0x00    ; 0xFE07
    SW R6 R0 0x07
    LI R0 0x00    ; 0xFE08
    SW R6 R0 0x08
    LI R0 0x00    ; 0xFE09
    SW R6 R0 0x09
    
    ;RESET BIRD
    LI R6 0xFE
    SLL R6 R6 0x00
    LI R0 0xB0    ; bird_coordinateY
    SW R6 R0 0x00

    LI R0 0x01    ; bird_velocity
    SW R6 R0 0X01

    LI R0 0x20    ; bird_stateaddr
    SLL R0 R0 0X00
    SW R6 R0 0x02

    LI R0 0X3F    ; bird_state
    SW R6 R0 0x08

    ;RESET PIPE
    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X03
    LI R1 0X20
    SW R0 R1 0X00   ;pipe0_coordinateX=32
    
    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X04
    LI R1 0X10
    SW R0 R1 0X00   ;pipe0_height=16
    
    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X05
    LI R1 0X4F
    SW R0 R1 0X00   ;pipe1_coordinateX=79

    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X06
    LI R1 0X50
    SW R0 R1 0X00   ;pipe1_height=80

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

PIPE_COLLISION:
    ; R0 - x
    ; R1 - height
    ; R2 - x0
    ; R3 - y0

    ; x0 + 8 <= x + 2   <==>   x - 6 >= x0
    ADDIU R0 0xFA ; R0 = x - 6
    SLT R0 R2
    BTEQZ PIPE_NO_COLLISION
    ADDIU R0 0x06

    ; x0 >= x + 14  
    ADDIU R0 0x0E ; R0 = x + 14
    SLT R2 R0
    BTEQZ PIPE_NO_COLLISION
    ADDIU R0 0x0E

    ; height + 11 >= y0
    ADDIU R1 0x0B
    SLT R1 R3
    BTEQZ PIPE_COLLISION_HAPPEN
    ADDIU R1 0xF5

    ; y0 + 16 >= height + 80  <==> y0 >= height + 64 
    ADDIU R1 0x40
    SLT R3 R1
    BTEQZ PIPE_COLLISION_HAPPEN
    ADDIU R1 0xC0

    B PIPE_NO_COLLISION

PIPE_COLLISION_HAPPEN:
    LI R0 0x01
    B 0x01

PIPE_NO_COLLISION:
    LI R0 0x00

    JR R7

DETECT_COLLISION:
    SW_SP R0 0x00
    SW_SP R1 0x01
    SW_SP R2 0x02
    SW_SP R3 0x03
    SW_SP R4 0x04
    SW_SP R5 0x05
    SW_SP R6 0x06
    SW_SP R7 0x07
    ADDSP 0x08

    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X02
    LW R0 R6 0X00   ;图片地址 R3=MEM[bird_stateaddr]
    
;     LI R0 0XFE
;     SLL R0 R0 0X00
;     LW R0 R1 0X00   ;R1=bird_coordinateY 
;     LI R0 0X80
;     SLL R0 R0 0X00
;     ADDIU R0 0X10
; COLLISION_BIRD_ADDLOOP:   ;计算显存地址R0
;     BEQZ R1 0X03
;     ADDIU R1 0XFF
;     ADDIU R0 0X50   ;R0+=80
;     B COLLISION_BIRD_ADDLOOP
    
    LI R5 0x00   ;I=0
COLLISION_BIRD_FOR_I:   ;I=0~15
    LI R4 0x00   ;J=0
    ADDIU R5 0x01
COLLISION_BIRD_FOR_J:   ;J=0~7
    LW R6 R3 0x00

    LI R7 0XFF
    AND R7 R3
    BEQZ R7 NO_COLLISION  ;低8位为0
   
    LI R7 0XFF
    SLL R7 R7 0X00
    AND R7 R3
    BEQZ R7 NO_COLLISION   ;高8位为0

    ; TOP BORDER - NOT EXIST
    ; BOTTOM BORDER - GROUND
    LI R7 0xFE
    SLL R7 R7 0x00
    ADDIU3 R7 R1 0x10
    LI R0 0x70
    ADDIU R0 0x60
    SLT R0 R1
    BTEQZ COLLISION_HAPPEN  
    
    ; PIPE0
    LI R7 0xFE
    SLL R7 R7 0x00
    LW R7 R0 0x03
    LW R7 R1 0x04
    LI R2 0x10
    LW R7 R3 0x00

    MFPC R7
    ADDIU R7 0x02
    B PIPE_COLLISION
    BNEZ R0 COLLISION_HAPPEN

    ; PIPE1
    LI R7 0xFE
    SLL R7 R7 0x00
    LW R7 R0 0x05
    LW R7 R1 0x06
    LI R2 0x10
    LW R7 R3 0x00

    MFPC R7
    ADDIU R7 0x02
    B PIPE_COLLISION
    BNEZ R0 COLLISION_HAPPEN

COLLISION_HAPPEN:
    LI R7 0xFE   ; set game status
    SLL R7 R7 0x00
    LI R0 0x01   ; over
    SW R7 R0 0x09
    B 0x01

NO_COLLISION:
    NOP

    ADDIU R3 0x01
    ADDIU R0 0X01
    ADDIU R4 0x01
    LI R7 0x07   ;R7=7
    SLT R7 R4    ;7<R4
    BTEQZ COLLISION_BIRD_FOR_J

    ADDIU R0 0X48
    LI R7 0X0F
    SLT R7 R5    ;15<R5
    BTEQZ COLLISION_BIRD_FOR_I



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

UPDATE_PARAMETERS:
    SW_SP R0 0X00
    SW_SP R1 0X01
    SW_SP R2 0X02
    SW_SP R3 0X03
    SW_SP R4 0X04
    SW_SP R5 0X05
    SW_SP R6 0X06
    SW_SP R7 0X07
 
    ;更新BIRD
    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X08
    LW R0 R1 0X00   ;R1=STATE
    ADDIU R1 0XFF

    SRA R3 R1 0X04
    BNEZ R3 0X01
    LI R1 0X3F
    SW R0 R1 0X00

    SRA R3 R1 0X04

    ADDIU R3 0XFF   ;STATE=1
    BNEZ R3 0X02
    LI R2 0X20
    SLL R2 R2 0X00

    ADDIU R3 0XFF   ;STATE=2
    BNEZ R3 0X04
    LI R2 0X20
    SLL R2 R2 0X00
    ADDIU R2 0X40
    ADDIU R2 0X40

    ADDIU R3 0XFF   ;STATE=3
    BNEZ R3 0X02
    LI R2 0X21
    SLL R2 R2 0X00


    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X02
    SW R0 R2 0X00

    ;更新ground_coordinateX +1
    LI R0 0xFE
    SLL R0 R0 0X00
    ADDIU R0 0X07
    
    LW R0 R1 0X00 
    ADDIU R1 0X01
    LI R2 0X0F
    SLT R2 R1   ;15<ground_coordinateX
    BTEQZ 0X01
    LI R1 0X08
    SW R0 R1 0X00
    
    ;更新pipe0_coordinateX - 1
    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X03
    LW R0 R1 0X00
    ADDIU R1 0XFF

    LI R2 0X00
    ADDIU R2 0XF0
    SLT R1 R2   ;R1<-16
    BTEQZ 0X01
    LI R1 0X4F

    SW R0 R1 0X00
    
    ;更新pipe1_coordinateX - 1
    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X05
    LW R0 R1 0X00
    ADDIU R1 0XFF

    LI R2 0X00
    ADDIU R2 0XF0
    SLT R1 R2   ;R1<-16
    BTEQZ 0X01
    LI R1 0X4F

    SW R0 R1 0X00

    LW_SP R0 0X00
    LW_SP R1 0X01
    LW_SP R2 0X02
    LW_SP R3 0X03
    LW_SP R4 0X04
    LW_SP R5 0X05
    LW_SP R6 0X06
    LW_SP R7 0X07
	JR R7   ;END

PRINT_BACKGROUND:
    SW_SP R0 0X00
    SW_SP R1 0X01
    SW_SP R2 0X02
    SW_SP R3 0X03
    SW_SP R4 0X04
    SW_SP R5 0X05
    SW_SP R6 0X06
    SW_SP R7 0X07

    LI R1 0x2C   ;图片地址
    SLL R1 R1 0x00
    ADDIU R1 0x40
    ADDIU R1 0x40
    LI R2 0x80   ;显存地址
    SLL R2 R2 0x00
    LI R3 0x00   ;I=0
BACKGROUND_FOR_I:   ;I=0~207
    LI R4 0x00   ;J=0
    ADDIU R3 0x01
BACKGROUND_FOR_J:   ;J=0~80
    LW R1 R5 0x00
    LI R7 0X01
    
    LI R6 0XFE
    SLL R6 R6 0X00
    ADDIU R6 0X02

;BACKGROUND_TEST_PIPE0:
;    LW R6 R0 0X00
;
;    ADDIU R0 0XFF
;    SLT R0 R4   ;COORX-1<J
;    BTEQZ BACKGROUND_TEST_PIPE1
;    ADDIU R0 0X11
;    SLT R4 R0   ;J<COORX-1
;    BTEQZ BACKGROUND_TEST_PIPE1
;
;    LI R7 0X00
;    LW R6 R0 0X01
;
;    ADDIU R0 0XC
;    SLT R3 R0   ;I<COORY+12
;    BTEQZ 0X01
;    LI R7 0X00
;    ADDIU R0 0X43
;    SLT R0 R3   ;COORY+79<i
;    BTEQZ 0X01
;    LI R7 0X00
;
;BACKGROUND_TEST_PIPE1:
;    LW R6 R0 0X02
;
;    ADDIU R0 0XFF
;    SLT R0 R4   ;COORX-1<J
;    BTEQZ BACKGROUND_TEST_BIRD
;    LI R7 0X00
;    ADDIU R0 0X11
;    SLT R4 R0   ;J<COORX-1
;    BTEQZ BACKGROUND_TEST_BIRD
;
;    LI R7 0X00
;    LW R6 R0 0X03
;
;    ADDIU R0 0XC
;    SLT R3 R0   ;I<COORY+12
;    BTEQZ 0X01
;    LI R7 0X00
;    ADDIU R0 0X43
;    SLT R0 R3   ;COORY+79<i
;    BTEQZ 0X01
;    LI R7 0X00
;BACKGROUND_TEST_BIRD:

    BEQZ R7 0X01
    SW R2 R5 0x00

    ADDIU R1 0x01
    ADDIU R2 0x01
    ADDIU R4 0x01

    LI R5 0x4F   ;R5=79
    SLT R5 R4    ;159<R4
    BTEQZ BACKGROUND_FOR_J

    LI R5 0XCF   ;R5=207
    SLT R5 R3    ;207<R3
    BTEQZ BACKGROUND_FOR_I

    LW_SP R0 0X00
    LW_SP R1 0X01
    LW_SP R2 0X02
    LW_SP R3 0X03
    LW_SP R4 0X04
    LW_SP R5 0X05
    LW_SP R6 0X06
    LW_SP R7 0X07
	JR R7   ;PRINT_BACKGROUND END

PRINT_GROUND:
    SW_SP R0 0X00
    SW_SP R1 0X01
    SW_SP R2 0X02
    SW_SP R3 0X03
    SW_SP R4 0X04
    SW_SP R5 0X05
    SW_SP R6 0X06
    SW_SP R7 0X07

    LI R1 0x22   ;图片地址
    SLL R1 R1 0x00
    ADDIU R1 0x40
    ADDIU R1 0x40
    LI R0 0xFE
    SLL R0 R0 0X00
    ADDIU R0 0X07
    LW R0 R6 0X00   ;R6=ground_coordinateX
    ;LI R6 0X00;
    ADDU R6 R1 R1

    LI R2 0xc1   ;显存地址
    SLL R2 R2 0x00
    LI R3 0x00   ;I=0
GROUND_FOR_I:   ;I=0~31
    LI R4 0x00   ;J=0
    ADDIU R3 0x01
GROUND_FOR_J:   ;J=0~79
    LW R1 R5 0x00
    SW R2 R5 0x00

    ADDU R4 R6 R5
    LI R0 0X4F   ;R0=79
    CMP R0 R5    ;R0!=R5
    BTEQZ 0X01
    ADDIU R1 0X50
    ADDIU R1 0XB0

    ADDIU R1 0x01
    ADDIU R2 0x01
    ADDIU R4 0x01
    
    LI R5 0x4F   ;R5=79
    SLT R5 R4    ;79<R4
    BTEQZ GROUND_FOR_J

    ADDIU R1 0X50
    LI R5 0x1F   ;R5=31
    SLT R5 R3    ;31<R3
    BTEQZ GROUND_FOR_I

    LW_SP R0 0X00
    LW_SP R1 0X01
    LW_SP R2 0X02
    LW_SP R3 0X03
    LW_SP R4 0X04
    LW_SP R5 0X05
    LW_SP R6 0X06
    LW_SP R7 0X07
	JR R7   ;PRINT_GROUND END

PRINT_PIPE:
    SW_SP R0 0X00
    SW_SP R1 0X01
    SW_SP R2 0X02
    SW_SP R3 0X03
    SW_SP R4 0X04
    SW_SP R5 0X05
    SW_SP R6 0X06
    SW_SP R7 0X07

;pipe0
    LI R6 0xFE
    SLL R6 R6 0X00
    ADDIU R6 0X03
    LW R6 R0 0X00   ;R0=pipe0_coordinateX
    LI R1 0x00      ;R1=0
    LI R6 0xFE
    SLL R6 R6 0X00
    ADDIU R6 0X04
    LW R6 R2 0X00   ;R2=pipe0_height
	MFPC R6
	ADDIU R6 0x0002
    B PRINT_PIPE_BODY

    ADDU R2 R1 R1   ;R1+=R2
	MFPC R6
	ADDIU R6 0x0002
    B PRINT_PIPE_HEAD_1

    ADDIU R1 0X50   ;R1+=80
	MFPC R6
	ADDIU R6 0x0002
    B PRINT_PIPE_HEAD_2

    ADDIU R1 0X0B   ;R1+=11
    LI R3 0XD0      ;R3=208
    SUBU R3 R1 R2   ;R2=R3-R1
	MFPC R6
	ADDIU R6 0x0002
    B PRINT_PIPE_BODY

;pipe1
    LI R6 0xFE
    SLL R6 R6 0X00
    ADDIU R6 0X05
    LW R6 R0 0X00   ;R0=pipe1_coordinateX  COORDX
    LI R1 0x00      ;R1=0  COORDY
    LI R6 0xFE
    SLL R6 R6 0X00
    ADDIU R6 0X06
    LW R6 R2 0X00   ;R2=pipe1_height  HEIGHT
	MFPC R6
	ADDIU R6 0x0002
    B PRINT_PIPE_BODY

    ADDU R2 R1 R1   ;R1+=R2
	MFPC R6
	ADDIU R6 0x0002
    B PRINT_PIPE_HEAD_1

    ADDIU R1 0X50   ;R1+=80
	MFPC R6
	ADDIU R6 0x0002
    B PRINT_PIPE_HEAD_2

    ADDIU R1 0X0B   ;R1+=11
    LI R3 0XD0      ;R3=208
    SUBU R3 R1 R2   ;R2=R3-R1
	MFPC R6
	ADDIU R6 0x0002
    B PRINT_PIPE_BODY
    
    LW_SP R0 0X00
    LW_SP R1 0X01
    LW_SP R2 0X02
    LW_SP R3 0X03
    LW_SP R4 0X04
    LW_SP R5 0X05
    LW_SP R6 0X06
    LW_SP R7 0X07
	JR R7   ;PRINT_GROUND END

PRINT_PIPE_BODY:
    ;R0 : COORDX
    ;R1 : COORDY
    ;R2 : HEIGHT
    ;2180~227F - pipe        (32*16)
    SW_SP R0 0X08
    SW_SP R1 0X09
    SW_SP R2 0X0A
    SW_SP R3 0X0B
    SW_SP R4 0X0C
    SW_SP R5 0X0D
    SW_SP R6 0X0E
    SW_SP R7 0X0F

    LI R3 0x22   ;图片地址 R3=0X2260
    SLL R3 R3 0x00
    ADDIU R3 0x60
    
    MOVE R5 R0   ;R5=COORDX
    LI R4 0X80
    SLL R4 R4 0X00
    ADDU R4 R0 R0
PRINT_PIPE_BODY_ADDLOOP:   ;计算显存地址R0
    BEQZ R1 0X03
    ADDIU R1 0XFF
    ADDIU R0 0X50   ;R0+=80
    B PRINT_PIPE_BODY_ADDLOOP
    
    ;LI R5 0x00   ;I=0
PRINT_PIPE_BODY_FOR_I:   ;I=0~R2
    LI R4 0x00   ;J=0
    ;ADDIU R5 0x01
    ADDIU R2 0XFF
PRINT_PIPE_BODY_FOR_J:   ;J=COORDX~COORDX+15
    LW R3 R6 0x00

    LI R7 0XFF
    AND R7 R6
    BNEZ R7 0X09   ;低8位不为0
    LI R1 0X53
    SLL R1 R1 0X00
    ADDIU R1 0X40
    ADDIU R1 0X40  ;R1=背景地址 8000-2C80=5380
    SUBU R0 R1 R1
    LW R1 R7 0X00
    LI R1 0XFF
    AND R7 R1
    OR R6 R7
    ;ADDU R7 R6 R6

    LI R7 0XFF
    SLL R7 R7 0X00
    AND R7 R6
    BNEZ R7 0X0A   ;高8位不为0
    LI R1 0X53
    SLL R1 R1 0X00
    ADDIU R1 0X40
    ADDIU R1 0X40  ;R1=背景地址
    SUBU R0 R1 R1
    LW R1 R7 0X00
    LI R1 0XFF
    SLL R1 R1 0X00
    AND R7 R1
    OR R6 R7
    ;ADDU R7 R6 R6
    
    ADDU R4 R5 R4
    LI R7 0X00
    ADDIU R7 0XFF   ;R7=-1
    SLT R7 R4    ;R7<R4
    BTEQZ 0X04
    LI R7 0X50
    SLT R4 R7       ;R4<80
    BTEQZ 0X01
    SW R0 R6 0x00
    SUBU R4 R5 R4

    ADDIU R3 0x01
    ADDIU R0 0X01
    ADDIU R4 0x01
    LI R7 0x0F   ;R7=15
    SLT R7 R4    ;15<R4
    BTEQZ PRINT_PIPE_BODY_FOR_J

    ADDIU R3 0XF0
    ADDIU R0 0X40
    ;SLT R2 R5    ;R2<R5
    BNEZ R2 PRINT_PIPE_BODY_FOR_I   ;R2!=0

    LW_SP R0 0X08
    LW_SP R1 0X09
    LW_SP R2 0X0A
    LW_SP R3 0X0B
    LW_SP R4 0X0C
    LW_SP R5 0X0D
    LW_SP R6 0X0E
    LW_SP R7 0X0F
	JR R6   ;PRINT_GROUND END

PRINT_PIPE_HEAD_1:
    ;R0 : COORDX
    ;R1 : COORDY
    ;HEIGHT : 11
    SW_SP R0 0X08
    SW_SP R1 0X09
    SW_SP R2 0X0A
    SW_SP R3 0X0B
    SW_SP R4 0X0C
    SW_SP R5 0X0D
    SW_SP R6 0X0E
    SW_SP R7 0X0F

    LI R3 0x22   ;图片地址 R3=0X2220
    SLL R3 R3 0x00
    ADDIU R3 0x20

    MOVE R2 R0   ;R2=COORDX
    LI R4 0X80
    SLL R4 R4 0X00
    ADDU R4 R0 R0
PRINT_PIPE_HEAD_1_ADDLOOP:   ;计算显存地址R0
    BEQZ R1 0X03
    ADDIU R1 0XFF
    ADDIU R0 0X50   ;R0+=80
    B PRINT_PIPE_HEAD_1_ADDLOOP
    
    LI R5 0x00   ;I=0
PRINT_PIPE_HEAD_1_FOR_I:   ;I=0~10
    LI R4 0x00   ;J=0
    ADDIU R5 0x01
PRINT_PIPE_HEAD_1_FOR_J:   ;J=0~15
    LW R3 R6 0x00

    LI R7 0XFF
    AND R7 R6
    BNEZ R7 0X09   ;低8位不为0
    LI R1 0X53
    SLL R1 R1 0X00
    ADDIU R1 0X40
    ADDIU R1 0X40  ;R1=背景地址 8000-2C80=5380
    SUBU R0 R1 R1
    LW R1 R7 0X00
    LI R1 0XFF
    AND R7 R1
    OR R6 R7
    ;ADDU R7 R6 R6

    LI R7 0XFF
    SLL R7 R7 0X00
    AND R7 R6
    BNEZ R7 0X0A   ;高8位不为0
    LI R1 0X53
    SLL R1 R1 0X00
    ADDIU R1 0X40
    ADDIU R1 0X40  ;R1=背景地址
    SUBU R0 R1 R1
    LW R1 R7 0X00
    LI R1 0XFF
    SLL R1 R1 0X00
    AND R7 R1
    OR R6 R7
    ;ADDU R7 R6 R6
    
    ADDU R4 R2 R4
    LI R7 0X00
    ADDIU R7 0XFF   ;R7=-1
    SLT R7 R4    ;R7<R4
    BTEQZ 0X04
    LI R7 0X50
    SLT R4 R7       ;R4<80
    BTEQZ 0X01
    SW R0 R6 0x00
    SUBU R4 R2 R4

    ADDIU R3 0x01
    ADDIU R0 0X01
    ADDIU R4 0x01
    LI R7 0x0F   ;R7=15
    SLT R7 R4    ;15<R4
    BTEQZ PRINT_PIPE_HEAD_1_FOR_J

    ADDIU R3 0XE0
    ADDIU R0 0X40
    LI R7 0X0A
    SLT R7 R5    ;10<R5
    BTEQZ PRINT_PIPE_HEAD_1_FOR_I

    LW_SP R0 0X08
    LW_SP R1 0X09
    LW_SP R2 0X0A
    LW_SP R3 0X0B
    LW_SP R4 0X0C
    LW_SP R5 0X0D
    LW_SP R6 0X0E
    LW_SP R7 0X0F
	JR R6   ;PRINT_GROUND END

PRINT_PIPE_HEAD_2:
    ;R0 : COORDX
    ;R1 : COORDY
    ;HEIGHT : 11
    SW_SP R0 0X08
    SW_SP R1 0X09
    SW_SP R2 0X0A
    SW_SP R3 0X0B
    SW_SP R4 0X0C
    SW_SP R5 0X0D
    SW_SP R6 0X0E
    SW_SP R7 0X0F

    LI R3 0x21   ;图片地址 R3=0X2180
    SLL R3 R3 0x00
    ADDIU R3 0x40
    ADDIU R3 0x40

    MOVE R2 R0   ;R2=COORDX
    LI R4 0X80
    SLL R4 R4 0X00
    ADDU R4 R0 R0
PRINT_PIPE_HEAD_2_ADDLOOP:   ;计算显存地址R0
    BEQZ R1 0X03
    ADDIU R1 0XFF
    ADDIU R0 0X50   ;R0+=80
    B PRINT_PIPE_HEAD_2_ADDLOOP
    
    LI R5 0x00   ;I=0
PRINT_PIPE_HEAD_2_FOR_I:   ;I=0~10
    LI R4 0x00   ;J=0
    ADDIU R5 0x01
PRINT_PIPE_HEAD_2_FOR_J:   ;J=0~15
    LW R3 R6 0x00

    LI R7 0XFF
    AND R7 R6
    BNEZ R7 0X09   ;低8位不为0
    LI R1 0X53
    SLL R1 R1 0X00
    ADDIU R1 0X40
    ADDIU R1 0X40  ;R1=背景地址 8000-2C80=5380
    SUBU R0 R1 R1
    LW R1 R7 0X00
    LI R1 0XFF
    AND R7 R1
    OR R6 R7
    ;ADDU R7 R6 R6

    LI R7 0XFF
    SLL R7 R7 0X00
    AND R7 R6
    BNEZ R7 0X0A   ;高8位不为0
    LI R1 0X53
    SLL R1 R1 0X00
    ADDIU R1 0X40
    ADDIU R1 0X40  ;R1=背景地址
    SUBU R0 R1 R1
    LW R1 R7 0X00
    LI R1 0XFF
    SLL R1 R1 0X00
    AND R7 R1
    OR R6 R7
    ;ADDU R7 R6 R6
    
    ADDU R4 R2 R4
    LI R7 0X00
    ADDIU R7 0XFF   ;R7=-1
    SLT R7 R4    ;R7<R4
    BTEQZ 0X04
    LI R7 0X50
    SLT R4 R7       ;R4<80
    BTEQZ 0X01
    SW R0 R6 0x00
    SUBU R4 R2 R4

    ADDIU R3 0x01
    ADDIU R0 0X01
    ADDIU R4 0x01
    LI R7 0x0F   ;R7=15
    SLT R7 R4    ;15<R4
    BTEQZ PRINT_PIPE_HEAD_2_FOR_J

    ADDIU R0 0X40
    LI R7 0X0A
    SLT R7 R5    ;10<R5
    BTEQZ PRINT_PIPE_HEAD_2_FOR_I

    LW_SP R0 0X08
    LW_SP R1 0X09
    LW_SP R2 0X0A
    LW_SP R3 0X0B
    LW_SP R4 0X0C
    LW_SP R5 0X0D
    LW_SP R6 0X0E
    LW_SP R7 0X0F
	JR R6   ;PRINT_GROUND END

 PRINT_BIRD:
    SW_SP R0 0X00
    SW_SP R1 0X01
    SW_SP R2 0X02
    SW_SP R3 0X03
    SW_SP R4 0X04
    SW_SP R5 0X05
    SW_SP R6 0X06
    SW_SP R7 0X07

    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X02
    LW R0 R3 0X00   ;图片地址 R3=MEM[bird_stateaddr]
    
    LI R0 0XFE
    SLL R0 R0 0X00
    LW R0 R1 0X00   ;R1=bird_coordinateY 
    LI R0 0X80
    SLL R0 R0 0X00
    ADDIU R0 0X10
PRINT_BIRD_ADDLOOP:   ;计算显存地址R0
    BEQZ R1 0X03
    ADDIU R1 0XFF
    ADDIU R0 0X50   ;R0+=80
    B PRINT_BIRD_ADDLOOP
    
    LI R5 0x00   ;I=0
PRINT_BIRD_FOR_I:   ;I=0~15
    LI R4 0x00   ;J=0
    ADDIU R5 0x01
PRINT_BIRD_FOR_J:   ;J=0~7
    LW R3 R6 0x00

    LI R7 0XFF
    AND R7 R6
    BNEZ R7 0X09   ;低8位不为0
    LI R1 0X53
    SLL R1 R1 0X00
    ADDIU R1 0X40
    ADDIU R1 0X40  ;R1=背景地址 8000-2C80=5380
    SUBU R0 R1 R1
    LW R1 R7 0X00
    LI R1 0XFF
    AND R7 R1
    OR R6 R7

    LI R7 0XFF
    SLL R7 R7 0X00
    AND R7 R6
    BNEZ R7 0X0A   ;高8位不为0
    LI R1 0X53
    SLL R1 R1 0X00
    ADDIU R1 0X40
    ADDIU R1 0X40  ;R1=背景地址
    SUBU R0 R1 R1
    LW R1 R7 0X00
    LI R1 0XFF
    SLL R1 R1 0X00
    AND R7 R1
    OR R6 R7
    
    SW R0 R6 0x00

    ADDIU R3 0x01
    ADDIU R0 0X01
    ADDIU R4 0x01
    LI R7 0x07   ;R7=7
    SLT R7 R4    ;7<R4
    BTEQZ PRINT_BIRD_FOR_J

    ADDIU R0 0X48
    LI R7 0X0F
    SLT R7 R5    ;15<R5
    BTEQZ PRINT_BIRD_FOR_I

    LW_SP R0 0X00
    LW_SP R1 0X01
    LW_SP R2 0X02
    LW_SP R3 0X03
    LW_SP R4 0X04
    LW_SP R5 0X05
    LW_SP R6 0X06
    LW_SP R7 0X07
    JR R7   ;PRINT_BIRD END