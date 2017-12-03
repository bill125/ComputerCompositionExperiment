;0000~1FFF - code
;2000~207F - bird1       (16*16)
;2080~20FF - bird2       (16*16)
;2100~217F - bird3       (16*16)
;2180~227F - pipe        (32*16)
;2280~2C7F - ground      (160*32)
;2C80~777F - background  (160*240)

;0xFE00 - bird_coordinateY 
;0xFE01 - bird_velocity 
;0xFE02 - bird_accelerator(constant)
;0xFE03 - pipe0_coordinateX
;0xFE04 - pipe0_height
;0xFE05 - pipe1_coordinateX
;0xFE06 - pipe1_height
;0xFE07 - ground_coordinateX

B START

START:
	LI R0 0x00FF 
	SLL R0 R0 0x0000
	ADDIU R0 0x10   ;R0=0xFF10 
	MTSP R0
    MFPC R7
    ADDIU R7 0x02
    B RESET_PARAMETERS

    B PRINT_LOOP

PRINT_LOOP:
	MFPC R7
	ADDIU R7 0x0002
    B UPDATE_PARAMETERS   ;计算参数

	MFPC R7
	ADDIU R7 0x0002
    B PRINT_BACKGROUND   ;绘制背景

	MFPC R7
	ADDIU R7 0x0002
    B PRINT_GROUND   ;绘制地板

	;MFPC R7
	;ADDIU R7 0x0002
    ;B PRINT_PIPE   ;绘制管道

	MFPC R7
	ADDIU R7 0x0002
    B PRINT_BIRD   ;绘制鸟

    B PRINT_LOOP
    
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

    LI R0 0x25    ; 0xFE00
    SLL R0 R0 0x00
    SW R6 R0 0x80
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
    LI R0 0x00    ; 0xFE06
    SW R6 R0 0x07
    
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

    ;0xFE03 - pipe0_coordinateX
    ;0xFE04 - pipe0_height
    ;0xFE05 - pipe1_coordinateX
    ;0xFE06 - pipe1_height
    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X03
    LI R1 0X10
    SW R0 R1 0X00   ;pipe0_coordinateX=16
    
    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X04
    SW R0 R1 0X00   ;pipe0_height=16
    
    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X05
    LI R1 0X30
    SW R0 R1 0X00   ;pipe1_coordinateX=48

    LI R0 0XFE
    SLL R0 R0 0X00
    ADDIU R0 0X06
    SW R0 R1 0X00   ;pipe1_height=48

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
BACKGROUND_FOR_I:   ;I=0~239
    LI R4 0x00   ;J=0
    ADDIU R3 0x01
BACKGROUND_FOR_J:   ;J=0~80
    LW R1 R5 0x00
    SW R2 R5 0x00
    ADDIU R1 0x01
    ADDIU R2 0x01
    ADDIU R4 0x01

    LI R5 0x4F   ;R5=79
    SLT R5 R4    ;159<R4
    BTEQZ BACKGROUND_FOR_J

    LI R5 0XEF   ;R5=239
    SLT R5 R3    ;239<R3
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
    ;B PRINT_PIPE_HEAD_1

    ADDIU R1 0X64   ;R1+=100
	MFPC R6
	ADDIU R6 0x0002
    ;B PRINT_PIPE_HEAD_2

    ADDIU R1 0X0B   ;R1+=11
    LI R3 0X76      ;R3=240-100-22=118
    SUBU R3 R2 R2   ;R2=R3-R2
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
    ;B PRINT_PIPE_HEAD_1

    ADDIU R1 0X70   ;R1+=112
	MFPC R6
	ADDIU R6 0x0002
    ;B PRINT_PIPE_HEAD_2

    ADDIU R1 0X10   ;R1+=16
    LI R3 0X50      ;R3=240-128-32=80
    SUBU R3 R2 R2   ;R2=R3-R2
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
    SW_SP R3 0X08
    SW_SP R4 0X09
    SW_SP R5 0X0A
    SW_SP R6 0X0B
    SW_SP R7 0X0C

    LI R3 0x22   ;图片地址 R3=0X2260
    SLL R1 R1 0x00
    ADDIU R1 0x60

PRINT_PIPE_BODY_ADDLOOP:   ;计算显存地址R0
    BEQZ R1 0X03
    ADDIU R1 0XFF
    ADDIU R0 0X50   ;R0+=50
    B PRINT_PIPE_BODY_ADDLOOP
    
    ADDIU R2 0XFF
    LI R5 0x00   ;I=0
PRINT_PIPE_BODY_FOR_I:   ;I=0~R2-1
    LI R4 0x00   ;J=0
    ADDIU R5 0x01
PRINT_PIPE_BODY_FOR_J:   ;J=0~16
    LW R3 R6 0x00

    LI R7 0XFF
    AND R7 R6
    BNEZ R7 0X09   ;低8位不为0
    LI R1 0X2C
    SLL R1 R1 0X00
    ADDIU R1 0X40
    ADDIU R1 0X40  ;R1=背景地址 2C80
    ADDU R0 R1 R1
    LW R1 R7 0X00
    LI R1 0XFF
    AND R7 R1
    ADDU R7 R6 R6

    LI R7 0XFF
    SLL R7 R7 0X00
    AND R7 R6
    BNEZ R7 0X0A   ;高8位不为0
    LI R1 0X2C
    SLL R1 R1 0X00
    ADDIU R1 0X40
    ADDIU R1 0X40  ;R1=背景地址 2C80
    ADDU R0 R1 R1
    LW R1 R7 0X00
    LI R1 0XFF
    SLL R1 R1 0X00
    AND R7 R1
    ADDU R7 R6 R6
    
    SW R0 R6 0x00

    ADDIU R3 0x01
    ADDIU R0 0X01
    ADDIU R4 0x01
    LI R7 0x0F   ;R7=15
    SLT R7 R4    ;15<R4
    BTEQZ PRINT_PIPE_BODY_FOR_J

    ADDIU R3 0XF0
    ADDIU R0 0X40
    SLT R2 R5    ;R2<R5
    BTEQZ PRINT_PIPE_BODY_FOR_I

    LW_SP R3 0X08
    LW_SP R4 0X09
    LW_SP R5 0X0A
    LW_SP R6 0X0B
    LW_SP R7 0X0C
	JR R6   ;PRINT_GROUND END

PRINT_PIPE_HEAD_1:
    ;R0 : COORDX
    ;R1 : COORDY
    ;HEIGHT : 11
    SW_SP R2 0X08
    SW_SP R3 0X09
    SW_SP R4 0X0A
    SW_SP R5 0X0B
    SW_SP R6 0X0C
    SW_SP R7 0X0D

    LW_SP R2 0X08
    LW_SP R3 0X09
    LW_SP R4 0X0A
    LW_SP R5 0X0B
    LW_SP R6 0X0C
    LW_SP R7 0X0D
	JR R6   ;PRINT_GROUND END

PRINT_PIPE_HEAD_2:
    ;R0 : COORDX
    ;R1 : COORDY
    SW_SP R2 0X08
    SW_SP R3 0X09
    SW_SP R4 0X0A
    SW_SP R5 0X0B
    SW_SP R6 0X0C
    SW_SP R7 0X0D

    LW_SP R2 0X08
    LW_SP R3 0X09
    LW_SP R4 0X0A
    LW_SP R5 0X0B
    LW_SP R6 0X0C
    LW_SP R7 0X0D
	JR R6   ;PRINT_GROUND END


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
    SLL R6 R6 0x00 ; R6 = 0x8000
    ADDIU R3 0xFF
BIRD_ADDR_JUMP:
    ADDIU R6 0x50 ; next line
    ADDIU R0 0x01 ; ++ R0
    SLT R3 R0 ; if R3 >= bird_coordinateY
    BTEQZ BIRD_ADDR_JUMP

    ; bird_pic address in R5
    ; target line head address in R6
    LI R0 0x00 ; R0 = 0
BIRD_COPY_LOOP:
    LI R1 0x00 ; R1 = 0
BIRD_COPY_LINE_LOOP:
    ; Brute Force Copy
    LW R5 R2 0x00 ; R2 = bird pixel
    SW R6 R2 0x10 ; Store R2 to R6+0x10

    ; Selective Replace
    ; High - 8
    ;LW R5 R2 0x00
    ;SRA R2 R2 0x00
    ;LI R7 0xFF
    ;AND R2 R7 ; get high-8 bits
    ;ADDIU R2 0x01 ; Transparent Pixel
    ;BNEZ R2 0x02
    ;LW R4 R2 0x00 ; Use Previous
    ;B 0x02
    ;ADDIU R2 0xFF ; Use New
    ;SLL R2 R2 0x00

    ; Low - 8
    ;LW R5 R3 0x00
    ;LI R7 0xFF
    ;AND R3 R7 ; get low-8 bits
    ;ADDIU R3 0x01 ; Transparent Pixel
    ;BNEZ R3 0x05
    ;LW R4 R7 0x00 ; Use Previous
    ;LI R3 0xFF
    ;AND R7 R3
    ;ADDU R2 R7 R2;
    ;B 0x02
    ;ADDIU R3 0xFF ; Use New
    ;ADDU R2 R3 R2

    ;SW R4 R2 0x00 ; Store R2 to R4
    
    ADDIU R6 0x01 ; ++ R6
    ADDIU R5 0x01 ; ++ R5
    ADDIU R1 0x01 ; ++ R1
    SLTUI R1 0x08 ; if R1 < 8
    BTEQZ 0x01 ; loop
    B BIRD_COPY_LINE_LOOP 
    
    ADDIU R6 0x48 ; R6 jump line
    ADDIU R0 0x01 ; ++ R0
    SLTUI R0 0x10 ; if R0 < 16
    BTEQZ 0x01 ; loop
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

