
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATtiny2313
;Program type           : Application
;Clock frequency        : 1,000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 32 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU WDTCSR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _sens_t=R2
	.DEF _sens_t_msb=R3
	.DEF _time=R4
	.DEF _time_msb=R5
	.DEF _cnt=R7
	.DEF _inv=R6
	.DEF _up=R9
	.DEF _flag=R8

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _comp_a_200ms
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _comp_a_25us
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_rst:
	.DB  0x62,0x6F,0x6F,0x74,0x69,0x6E,0x67,0x2E
	.DB  0x2E,0x2E,0xD,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <delay.h>
;
;#define sbi(BYTE, BITE)     BYTE|=(1<<BITE)
;#define cbi(BYTE, BITE)     BYTE&=~(1<<BITE)
;
;#define LED_BYTE            PORTB
;#define RIGHT_UP            PORTA.0
;#define LEFT_D              PORTA.1
;#define LEFT_UP             PORTD.2
;#define RIGHT_D             PORTD.3
;
;#define ALL_ON              PORTB=0xFF
;#define ALL_OFF             PORTB=0x00
;#define RST_T0              TCNT0=0;
;#define RST_T1              TCNT1H=0;TCNT1L=0;
;
;#define PUT_DOWN            sbi(DDRD, 4);cbi(PORTD, 4)
;#define SET_INPUT           cbi(DDRD, 4);cbi(PORTD, 4)
;#define SENSOR              PIND.4
;
;#define MUSIC               PORTD.6
;
;#define TIME_NOTUCH         1
;
;#define LINE_FLAG           0
;#define ONE_LED_FLAG        1
;#define FULL_FLAG           2
;#define LAST_FLAG           3
;#define MIG_FLAG            4
;
;#define STOP_FLAG           5
;
;#define TUCH_FLAG           6
;
;flash char rst[]="booting...\r";
;
;unsigned int sens_t, time;
;
;char cnt, inv, up, flag;
;
;void initdev()
; 0000 002C {

	.CSEG
_initdev:
; .FSTART _initdev
; 0000 002D  DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 002E  DDRB=0xFF;
	OUT  0x17,R30
; 0000 002F  DDRD=0xEF;
	LDI  R30,LOW(239)
	OUT  0x11,R30
; 0000 0030 
; 0000 0031  TCCR0B=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0032  OCR0A=5;
	LDI  R30,LOW(5)
	OUT  0x36,R30
; 0000 0033 
; 0000 0034  TCCR1B=0x05;
	OUT  0x2E,R30
; 0000 0035  OCR1AH=0x01;
	LDI  R30,LOW(1)
	OUT  0x2B,R30
; 0000 0036  OCR1AL=0x86;
	LDI  R30,LOW(134)
	OUT  0x2A,R30
; 0000 0037 
; 0000 0038  TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 0039 
; 0000 003A  UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 003B  UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 003C  UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 003D  UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 003E  UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 003F 
; 0000 0040  ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0041 }
	RET
; .FEND
;
;void line()
; 0000 0044 {
_line:
; .FSTART _line
; 0000 0045  up = ~up;
	COM  R9
; 0000 0046 
; 0000 0047  if(!inv)
	TST  R6
	BRNE _0x3
; 0000 0048    {
; 0000 0049     if(up)
	TST  R9
	BREQ _0x4
; 0000 004A      {
; 0000 004B       ALL_OFF;
	RCALL SUBOPT_0x0
; 0000 004C       LEFT_UP=1;
; 0000 004D       RIGHT_UP=1;
; 0000 004E 
; 0000 004F       LEFT_D=0;
; 0000 0050       RIGHT_D=0;
; 0000 0051 
; 0000 0052       if(cnt<7) ALL_OFF;
	CP   R7,R30
	BRSH _0xD
	LDI  R30,LOW(0)
	RJMP _0x168
; 0000 0053       else LED_BYTE|= ~(0xFF << (cnt - 7));
_0xD:
	RCALL SUBOPT_0x1
	SUBI R30,LOW(7)
	RCALL SUBOPT_0x2
_0x168:
	OUT  0x18,R30
; 0000 0054         }
; 0000 0055 
; 0000 0056      else
	RJMP _0xF
_0x4:
; 0000 0057      {
; 0000 0058       LEFT_UP=0;
	RCALL SUBOPT_0x3
; 0000 0059       RIGHT_UP=0;
; 0000 005A 
; 0000 005B       LEFT_D=1;
; 0000 005C       RIGHT_D=1;
; 0000 005D 
; 0000 005E       if(cnt>7) ALL_ON;
	CP   R30,R7
	BRSH _0x18
	LDI  R30,LOW(255)
	RJMP _0x169
; 0000 005F       else LED_BYTE|=~(0xFF<<cnt);
_0x18:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
_0x169:
	OUT  0x18,R30
; 0000 0060         }
_0xF:
; 0000 0061      if(cnt==17)
	LDI  R30,LOW(17)
	CP   R30,R7
	BRNE _0x1A
; 0000 0062        {
; 0000 0063         cnt=0;
	CLR  R7
; 0000 0064         inv=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0065          }
; 0000 0066          }
_0x1A:
; 0000 0067 
; 0000 0068    else
	RJMP _0x1B
_0x3:
; 0000 0069      {
; 0000 006A        if(up)
	TST  R9
	BREQ _0x1C
; 0000 006B          {
; 0000 006C           ALL_OFF;
	RCALL SUBOPT_0x0
; 0000 006D           LEFT_UP=1;
; 0000 006E           RIGHT_UP=1;
; 0000 006F 
; 0000 0070           LEFT_D=0;
; 0000 0071           RIGHT_D=0;
; 0000 0072 
; 0000 0073           if(cnt > 7) ALL_ON;
	CP   R30,R7
	BRSH _0x25
	LDI  R30,LOW(255)
	RJMP _0x16A
; 0000 0074           else LED_BYTE|= ~(0xFF >> (cnt));
_0x25:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x4
_0x16A:
	OUT  0x18,R30
; 0000 0075             }
; 0000 0076 
; 0000 0077          else
	RJMP _0x27
_0x1C:
; 0000 0078          {
; 0000 0079           ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 007A           LEFT_UP=0;
	RCALL SUBOPT_0x3
; 0000 007B           RIGHT_UP=0;
; 0000 007C 
; 0000 007D           LEFT_D=1;
; 0000 007E           RIGHT_D=1;
; 0000 007F 
; 0000 0080           if(cnt < 7) ALL_OFF;
	CP   R7,R30
	BRSH _0x30
	LDI  R30,LOW(0)
	RJMP _0x16B
; 0000 0081           else LED_BYTE|=~(0xFF >> (cnt - 7));
_0x30:
	RCALL SUBOPT_0x1
	SUBI R30,LOW(7)
	RCALL SUBOPT_0x6
_0x16B:
	OUT  0x18,R30
; 0000 0082              }
_0x27:
; 0000 0083       if(cnt==16)
	LDI  R30,LOW(16)
	CP   R30,R7
	BRNE _0x32
; 0000 0084         {
; 0000 0085          cnt=0;
	CLR  R7
; 0000 0086          inv=0;
	CLR  R6
; 0000 0087          sbi(flag, ONE_LED_FLAG);
	LDI  R30,LOW(2)
	OR   R8,R30
; 0000 0088          cbi(flag, LINE_FLAG);
	LDI  R30,LOW(254)
	AND  R8,R30
; 0000 0089            }
; 0000 008A              }
_0x32:
_0x1B:
; 0000 008B 
; 0000 008C }
	RET
; .FEND
;
;void one_led()
; 0000 008F {
_one_led:
; .FSTART _one_led
; 0000 0090   if(!inv)
	TST  R6
	BRNE _0x33
; 0000 0091     {
; 0000 0092      if(cnt > 23)
	RCALL SUBOPT_0x7
	BRSH _0x34
; 0000 0093        {
; 0000 0094         ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 0095         RIGHT_UP=0;
	RCALL SUBOPT_0x8
; 0000 0096         RIGHT_D=0;
; 0000 0097         LEFT_D=0;
	CBI  0x1B,1
; 0000 0098         LEFT_UP=1;
	SBI  0x12,2
; 0000 0099 
; 0000 009A         LED_BYTE|= (0x01 << (cnt - 24));
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x9
; 0000 009B 
; 0000 009C         if(LED_BYTE == 0)
	BRNE _0x3D
; 0000 009D           {
; 0000 009E            cnt=0;
	CLR  R7
; 0000 009F            inv=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 00A0             }
; 0000 00A1         goto exit;
_0x3D:
	RJMP _0x3E
; 0000 00A2           }
; 0000 00A3 
; 0000 00A4       if(cnt > 15)
_0x34:
	RCALL SUBOPT_0xA
	BRSH _0x3F
; 0000 00A5        {
; 0000 00A6         ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 00A7         RIGHT_UP=0;
	RCALL SUBOPT_0x8
; 0000 00A8         RIGHT_D=0;
; 0000 00A9         LEFT_D=1;
	SBI  0x1B,1
; 0000 00AA         LEFT_UP=0;
	RCALL SUBOPT_0xB
; 0000 00AB 
; 0000 00AC         LED_BYTE|= (0x01 << (cnt - 16));
	RCALL SUBOPT_0xC
; 0000 00AD         goto exit;
	RJMP _0x3E
; 0000 00AE           }
; 0000 00AF 
; 0000 00B0       if(cnt > 7)
_0x3F:
	RCALL SUBOPT_0xD
	BRSH _0x48
; 0000 00B1        {
; 0000 00B2         ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 00B3         RIGHT_UP=0;
	RCALL SUBOPT_0xE
; 0000 00B4         RIGHT_D=1;
; 0000 00B5         LEFT_D=0;
; 0000 00B6         LEFT_UP=0;
; 0000 00B7 
; 0000 00B8         LED_BYTE|= (0x80 >> (cnt - 8));
	RCALL SUBOPT_0xF
; 0000 00B9         goto exit;
	RJMP _0x3E
; 0000 00BA           }
; 0000 00BB 
; 0000 00BC       if(cnt < 7)
_0x48:
	RCALL SUBOPT_0x10
	BRSH _0x51
; 0000 00BD        {
; 0000 00BE         ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 00BF         RIGHT_UP=1;
	RCALL SUBOPT_0x11
; 0000 00C0         RIGHT_D=0;
; 0000 00C1         LEFT_D=0;
; 0000 00C2         LEFT_UP=0;
; 0000 00C3 
; 0000 00C4         LED_BYTE|= (0x80 >> cnt);
	RCALL SUBOPT_0x12
; 0000 00C5         goto exit;
	RJMP _0x3E
; 0000 00C6           }
; 0000 00C7           }
_0x51:
; 0000 00C8 
; 0000 00C9     else
	RJMP _0x5A
_0x33:
; 0000 00CA     {
; 0000 00CB       if(cnt > 23)
	RCALL SUBOPT_0x7
	BRSH _0x5B
; 0000 00CC        {
; 0000 00CD         ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 00CE         RIGHT_UP=1;
	RCALL SUBOPT_0x11
; 0000 00CF         RIGHT_D=0;
; 0000 00D0         LEFT_D=0;
; 0000 00D1         LEFT_UP=0;
; 0000 00D2 
; 0000 00D3         LED_BYTE|= (0x01 << (cnt - 24));
	RCALL SUBOPT_0x9
; 0000 00D4 
; 0000 00D5         if(LED_BYTE == 0)
	BRNE _0x64
; 0000 00D6           {
; 0000 00D7            cnt=0;
	CLR  R7
; 0000 00D8            inv=0;
	CLR  R6
; 0000 00D9            cbi(flag, ONE_LED_FLAG);
	LDI  R30,LOW(253)
	AND  R8,R30
; 0000 00DA            sbi(flag, FULL_FLAG);
	LDI  R30,LOW(4)
	OR   R8,R30
; 0000 00DB             }
; 0000 00DC         goto exit;
_0x64:
	RJMP _0x3E
; 0000 00DD           }
; 0000 00DE 
; 0000 00DF       if(cnt > 15)
_0x5B:
	RCALL SUBOPT_0xA
	BRSH _0x65
; 0000 00E0        {
; 0000 00E1         ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 00E2         RIGHT_UP=0;
	RCALL SUBOPT_0xE
; 0000 00E3         RIGHT_D=1;
; 0000 00E4         LEFT_D=0;
; 0000 00E5         LEFT_UP=0;
; 0000 00E6 
; 0000 00E7         LED_BYTE|= (0x01 << (cnt - 16));
	RCALL SUBOPT_0xC
; 0000 00E8         goto exit;
	RJMP _0x3E
; 0000 00E9           }
; 0000 00EA 
; 0000 00EB       if(cnt > 7)
_0x65:
	RCALL SUBOPT_0xD
	BRSH _0x6E
; 0000 00EC        {
; 0000 00ED         ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 00EE         RIGHT_UP=0;
	RCALL SUBOPT_0x8
; 0000 00EF         RIGHT_D=0;
; 0000 00F0         LEFT_D=1;
	SBI  0x1B,1
; 0000 00F1         LEFT_UP=0;
	RCALL SUBOPT_0xB
; 0000 00F2 
; 0000 00F3         LED_BYTE|= (0x80 >> (cnt - 8));
	RCALL SUBOPT_0xF
; 0000 00F4         goto exit;
	RJMP _0x3E
; 0000 00F5           }
; 0000 00F6 
; 0000 00F7       if(cnt < 7)
_0x6E:
	RCALL SUBOPT_0x10
	BRSH _0x77
; 0000 00F8        {
; 0000 00F9         ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 00FA         RIGHT_UP=0;
	RCALL SUBOPT_0x8
; 0000 00FB         RIGHT_D=0;
; 0000 00FC         LEFT_D=0;
	CBI  0x1B,1
; 0000 00FD         LEFT_UP=1;
	SBI  0x12,2
; 0000 00FE 
; 0000 00FF         LED_BYTE|= (0x80 >> cnt);
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x12
; 0000 0100         goto exit;
; 0000 0101           }
; 0000 0102 
; 0000 0103       }
_0x77:
_0x5A:
; 0000 0104 
; 0000 0105 exit:
_0x3E:
; 0000 0106      }
	RET
; .FEND
;
;void full()
; 0000 0109 {
_full:
; .FSTART _full
; 0000 010A  static char j;
; 0000 010B 
; 0000 010C  j++;
	RCALL SUBOPT_0x13
	SUBI R30,-LOW(1)
	STS  _j_S0000003000,R30
; 0000 010D  if(j > 4) j=1;
	LDS  R26,_j_S0000003000
	CPI  R26,LOW(0x5)
	BRLO _0x80
	LDI  R30,LOW(1)
	STS  _j_S0000003000,R30
; 0000 010E 
; 0000 010F  if(!inv)
_0x80:
	TST  R6
	BREQ PC+2
	RJMP _0x81
; 0000 0110    {
; 0000 0111     switch (j)
	RCALL SUBOPT_0x14
; 0000 0112        {
; 0000 0113         case 1:
	BRNE _0x85
; 0000 0114               ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 0115               RIGHT_UP=1;
	RCALL SUBOPT_0x15
; 0000 0116               RIGHT_D=0;
; 0000 0117               LEFT_D=0;
; 0000 0118               LEFT_UP=0;
; 0000 0119         break;
	RJMP _0x84
; 0000 011A 
; 0000 011B         case 2:
_0x85:
	RCALL SUBOPT_0x16
	BRNE _0x8E
; 0000 011C                ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 011D                RIGHT_UP=0;
	RCALL SUBOPT_0x17
; 0000 011E                RIGHT_D=1;
; 0000 011F                LEFT_D=0;
; 0000 0120                LEFT_UP=0;
; 0000 0121         break;
	RJMP _0x84
; 0000 0122 
; 0000 0123         case 3:
_0x8E:
	RCALL SUBOPT_0x18
	BRNE _0x97
; 0000 0124                ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 0125                RIGHT_UP=0;
	RCALL SUBOPT_0x8
; 0000 0126                RIGHT_D=0;
; 0000 0127                LEFT_D=1;
	SBI  0x1B,1
; 0000 0128                LEFT_UP=0;
	CBI  0x12,2
; 0000 0129         break;
	RJMP _0x84
; 0000 012A 
; 0000 012B         case 4:
_0x97:
	RCALL SUBOPT_0x19
	BRNE _0xA9
; 0000 012C                ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 012D                RIGHT_UP=0;
	RCALL SUBOPT_0x8
; 0000 012E                RIGHT_D=0;
; 0000 012F                LEFT_D=0;
	CBI  0x1B,1
; 0000 0130                LEFT_UP=1;
	SBI  0x12,2
; 0000 0131         break;
; 0000 0132 
; 0000 0133         default:break;
_0xA9:
; 0000 0134          }
_0x84:
; 0000 0135 
; 0000 0136     if(cnt > 23)
	RCALL SUBOPT_0x7
	BRSH _0xAA
; 0000 0137      {
; 0000 0138       switch (j)
	RCALL SUBOPT_0x14
; 0000 0139            {
; 0000 013A             case 1:
	BRNE _0xAE
; 0000 013B                    ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 013C             break;
	RJMP _0xAD
; 0000 013D 
; 0000 013E             case 2:
_0xAE:
	RCALL SUBOPT_0x16
	BRNE _0xAF
; 0000 013F                    ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 0140             break;
	RJMP _0xAD
; 0000 0141 
; 0000 0142             case 3:
_0xAF:
	RCALL SUBOPT_0x18
	BRNE _0xB0
; 0000 0143                    ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 0144             break;
	RJMP _0xAD
; 0000 0145 
; 0000 0146             case 4:
_0xB0:
	RCALL SUBOPT_0x19
	BRNE _0xB3
; 0000 0147                    LED_BYTE|= ~(0xFF << (cnt - 24));
	RCALL SUBOPT_0x1
	SUBI R30,LOW(24)
	RCALL SUBOPT_0x2
	OUT  0x18,R30
; 0000 0148                    if(LED_BYTE == 0xFF)
	IN   R30,0x18
	CPI  R30,LOW(0xFF)
	BRNE _0xB2
; 0000 0149                      {
; 0000 014A                       inv=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 014B                       cnt=0;
	CLR  R7
; 0000 014C                        }
; 0000 014D             break;
_0xB2:
; 0000 014E 
; 0000 014F             default:break;
_0xB3:
; 0000 0150                 }
_0xAD:
; 0000 0151 
; 0000 0152       goto exit1;
	RJMP _0xB4
; 0000 0153       }
; 0000 0154 
; 0000 0155     if(cnt > 15)
_0xAA:
	RCALL SUBOPT_0xA
	BRSH _0xB5
; 0000 0156      {
; 0000 0157        switch (j)
	RCALL SUBOPT_0x14
; 0000 0158            {
; 0000 0159             case 1:
	BRNE _0xB9
; 0000 015A                    ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 015B             break;
	RJMP _0xB8
; 0000 015C 
; 0000 015D             case 2:
_0xB9:
	RCALL SUBOPT_0x16
	BRNE _0xBA
; 0000 015E                    ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 015F             break;
	RJMP _0xB8
; 0000 0160 
; 0000 0161             case 3:
_0xBA:
	RCALL SUBOPT_0x18
	BRNE _0xBB
; 0000 0162                    LED_BYTE|= ~(0xFF << (cnt - 16));
	RCALL SUBOPT_0x1
	SUBI R30,LOW(16)
	RCALL SUBOPT_0x2
	OUT  0x18,R30
; 0000 0163             break;
	RJMP _0xB8
; 0000 0164 
; 0000 0165             case 4:
_0xBB:
	RCALL SUBOPT_0x19
	BRNE _0xBD
; 0000 0166                    ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 0167             break;
; 0000 0168 
; 0000 0169             default:break;
_0xBD:
; 0000 016A                 }
_0xB8:
; 0000 016B 
; 0000 016C       goto exit1;
	RJMP _0xB4
; 0000 016D       }
; 0000 016E 
; 0000 016F      if(cnt > 7)
_0xB5:
	RCALL SUBOPT_0xD
	BRSH _0xBE
; 0000 0170      {
; 0000 0171       switch (j)
	RCALL SUBOPT_0x14
; 0000 0172            {
; 0000 0173             case 1:
	BRNE _0xC2
; 0000 0174                    ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 0175             break;
	RJMP _0xC1
; 0000 0176 
; 0000 0177             case 2:
_0xC2:
	RCALL SUBOPT_0x16
	BRNE _0xC3
; 0000 0178                    LED_BYTE|= ~(0xFF >> (cnt - 8));
	RCALL SUBOPT_0x1
	SUBI R30,LOW(8)
	RCALL SUBOPT_0x6
	OUT  0x18,R30
; 0000 0179             break;
	RJMP _0xC1
; 0000 017A 
; 0000 017B             case 3:
_0xC3:
	RCALL SUBOPT_0x18
	BRNE _0xC4
; 0000 017C                    ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 017D             break;
	RJMP _0xC1
; 0000 017E 
; 0000 017F             case 4:
_0xC4:
	RCALL SUBOPT_0x19
	BRNE _0xC6
; 0000 0180                    ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 0181             break;
; 0000 0182 
; 0000 0183             default:break;
_0xC6:
; 0000 0184                 }
_0xC1:
; 0000 0185 
; 0000 0186       goto exit1;
	RJMP _0xB4
; 0000 0187       }
; 0000 0188 
; 0000 0189    if(cnt < 7)
_0xBE:
	RCALL SUBOPT_0x10
	BRSH _0xC7
; 0000 018A     {
; 0000 018B      switch (j)
	RCALL SUBOPT_0x14
; 0000 018C            {
; 0000 018D             case 1:
	BRNE _0xCB
; 0000 018E                    LED_BYTE|= ~(0xFF >> cnt);
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x4
	OUT  0x18,R30
; 0000 018F             break;
	RJMP _0xCA
; 0000 0190 
; 0000 0191             case 2:
_0xCB:
	RCALL SUBOPT_0x16
	BRNE _0xCC
; 0000 0192                    ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 0193             break;
	RJMP _0xCA
; 0000 0194 
; 0000 0195             case 3:
_0xCC:
	RCALL SUBOPT_0x18
	BRNE _0xCD
; 0000 0196                    ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 0197             break;
	RJMP _0xCA
; 0000 0198 
; 0000 0199             case 4:
_0xCD:
	RCALL SUBOPT_0x19
	BRNE _0xCF
; 0000 019A                    ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 019B             break;
; 0000 019C 
; 0000 019D             default:break;
_0xCF:
; 0000 019E                 }
_0xCA:
; 0000 019F 
; 0000 01A0      goto exit1;
	RJMP _0xB4
; 0000 01A1       }
; 0000 01A2       }
_0xC7:
; 0000 01A3 
; 0000 01A4 //**********************************************
; 0000 01A5    else
	RJMP _0xD0
_0x81:
; 0000 01A6    {
; 0000 01A7     switch (j)
	RCALL SUBOPT_0x14
; 0000 01A8        {
; 0000 01A9         case 1:
	BRNE _0xD4
; 0000 01AA               ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 01AB               RIGHT_UP=0;
	RCALL SUBOPT_0x8
; 0000 01AC               RIGHT_D=0;
; 0000 01AD               LEFT_D=0;
	CBI  0x1B,1
; 0000 01AE               LEFT_UP=1;
	SBI  0x12,2
; 0000 01AF         break;
	RJMP _0xD3
; 0000 01B0 
; 0000 01B1         case 2:
_0xD4:
	RCALL SUBOPT_0x16
	BRNE _0xDD
; 0000 01B2                ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 01B3                RIGHT_UP=0;
	RCALL SUBOPT_0x8
; 0000 01B4                RIGHT_D=0;
; 0000 01B5                LEFT_D=1;
	SBI  0x1B,1
; 0000 01B6                LEFT_UP=0;
	CBI  0x12,2
; 0000 01B7         break;
	RJMP _0xD3
; 0000 01B8 
; 0000 01B9         case 3:
_0xDD:
	RCALL SUBOPT_0x18
	BRNE _0xE6
; 0000 01BA                ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 01BB                RIGHT_UP=0;
	RCALL SUBOPT_0x17
; 0000 01BC                RIGHT_D=1;
; 0000 01BD                LEFT_D=0;
; 0000 01BE                LEFT_UP=0;
; 0000 01BF         break;
	RJMP _0xD3
; 0000 01C0 
; 0000 01C1         case 4:
_0xE6:
	RCALL SUBOPT_0x19
	BRNE _0xF8
; 0000 01C2                ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 01C3                RIGHT_UP=1;
	RCALL SUBOPT_0x15
; 0000 01C4                RIGHT_D=0;
; 0000 01C5                LEFT_D=0;
; 0000 01C6                LEFT_UP=0;
; 0000 01C7         break;
; 0000 01C8 
; 0000 01C9         default:break;
_0xF8:
; 0000 01CA          }
_0xD3:
; 0000 01CB 
; 0000 01CC     if(cnt > 23)
	RCALL SUBOPT_0x7
	BRSH _0xF9
; 0000 01CD      {
; 0000 01CE       switch (j)
	RCALL SUBOPT_0x14
; 0000 01CF            {
; 0000 01D0             case 1:
	BRNE _0xFD
; 0000 01D1                    ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 01D2             break;
	RJMP _0xFC
; 0000 01D3 
; 0000 01D4             case 2:
_0xFD:
	RCALL SUBOPT_0x16
	BRNE _0xFE
; 0000 01D5                    ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 01D6             break;
	RJMP _0xFC
; 0000 01D7 
; 0000 01D8             case 3:
_0xFE:
	RCALL SUBOPT_0x18
	BRNE _0xFF
; 0000 01D9                    ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 01DA             break;
	RJMP _0xFC
; 0000 01DB 
; 0000 01DC             case 4:
_0xFF:
	RCALL SUBOPT_0x19
	BRNE _0x102
; 0000 01DD                    LED_BYTE|= ~(0xFF << (cnt - 24));
	RCALL SUBOPT_0x1
	SUBI R30,LOW(24)
	RCALL SUBOPT_0x2
	OUT  0x18,R30
; 0000 01DE                    if(LED_BYTE == 0xFF)
	IN   R30,0x18
	CPI  R30,LOW(0xFF)
	BRNE _0x101
; 0000 01DF                      {
; 0000 01E0                       inv=0;
	CLR  R6
; 0000 01E1                       cnt=0;
	CLR  R7
; 0000 01E2                       cbi(flag, FULL_FLAG);
	LDI  R30,LOW(251)
	AND  R8,R30
; 0000 01E3                       sbi(flag, LAST_FLAG);
	LDI  R30,LOW(8)
	OR   R8,R30
; 0000 01E4                       ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 01E5                       time=0;
	RCALL SUBOPT_0x1B
; 0000 01E6                        }
; 0000 01E7             break;
_0x101:
; 0000 01E8 
; 0000 01E9             default:break;
_0x102:
; 0000 01EA                 }
_0xFC:
; 0000 01EB 
; 0000 01EC       goto exit1;
	RJMP _0xB4
; 0000 01ED       }
; 0000 01EE 
; 0000 01EF     if(cnt > 15)
_0xF9:
	RCALL SUBOPT_0xA
	BRSH _0x103
; 0000 01F0      {
; 0000 01F1        switch (j)
	RCALL SUBOPT_0x14
; 0000 01F2            {
; 0000 01F3             case 1:
	BRNE _0x107
; 0000 01F4                    ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 01F5             break;
	RJMP _0x106
; 0000 01F6 
; 0000 01F7             case 2:
_0x107:
	RCALL SUBOPT_0x16
	BRNE _0x108
; 0000 01F8                    ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 01F9             break;
	RJMP _0x106
; 0000 01FA 
; 0000 01FB             case 3:
_0x108:
	RCALL SUBOPT_0x18
	BRNE _0x109
; 0000 01FC                    LED_BYTE|= ~(0xFF << (cnt - 16));
	RCALL SUBOPT_0x1
	SUBI R30,LOW(16)
	RCALL SUBOPT_0x2
	OUT  0x18,R30
; 0000 01FD             break;
	RJMP _0x106
; 0000 01FE 
; 0000 01FF             case 4:
_0x109:
	RCALL SUBOPT_0x19
	BRNE _0x10B
; 0000 0200                    ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 0201             break;
; 0000 0202 
; 0000 0203             default:break;
_0x10B:
; 0000 0204                 }
_0x106:
; 0000 0205 
; 0000 0206       goto exit1;
	RJMP _0xB4
; 0000 0207       }
; 0000 0208 
; 0000 0209      if(cnt > 7)
_0x103:
	RCALL SUBOPT_0xD
	BRSH _0x10C
; 0000 020A      {
; 0000 020B       switch (j)
	RCALL SUBOPT_0x14
; 0000 020C            {
; 0000 020D             case 1:
	BRNE _0x110
; 0000 020E                    ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 020F             break;
	RJMP _0x10F
; 0000 0210 
; 0000 0211             case 2:
_0x110:
	RCALL SUBOPT_0x16
	BRNE _0x111
; 0000 0212                    LED_BYTE|= ~(0xFF >> (cnt - 8));
	RCALL SUBOPT_0x1
	SUBI R30,LOW(8)
	RCALL SUBOPT_0x6
	OUT  0x18,R30
; 0000 0213             break;
	RJMP _0x10F
; 0000 0214 
; 0000 0215             case 3:
_0x111:
	RCALL SUBOPT_0x18
	BRNE _0x112
; 0000 0216                    ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 0217             break;
	RJMP _0x10F
; 0000 0218 
; 0000 0219             case 4:
_0x112:
	RCALL SUBOPT_0x19
	BRNE _0x114
; 0000 021A                    ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 021B             break;
; 0000 021C 
; 0000 021D             default:break;
_0x114:
; 0000 021E                 }
_0x10F:
; 0000 021F 
; 0000 0220       goto exit1;
	RJMP _0xB4
; 0000 0221       }
; 0000 0222 
; 0000 0223    if(cnt < 7)
_0x10C:
	RCALL SUBOPT_0x10
	BRSH _0x115
; 0000 0224     {
; 0000 0225      switch (j)
	RCALL SUBOPT_0x14
; 0000 0226            {
; 0000 0227             case 1:
	BRNE _0x119
; 0000 0228                    LED_BYTE|= ~(0xFF >> cnt);
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x4
	OUT  0x18,R30
; 0000 0229             break;
	RJMP _0x118
; 0000 022A 
; 0000 022B             case 2:
_0x119:
	RCALL SUBOPT_0x16
	BRNE _0x11A
; 0000 022C                    ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 022D             break;
	RJMP _0x118
; 0000 022E 
; 0000 022F             case 3:
_0x11A:
	RCALL SUBOPT_0x18
	BRNE _0x11B
; 0000 0230                    ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 0231             break;
	RJMP _0x118
; 0000 0232 
; 0000 0233             case 4:
_0x11B:
	RCALL SUBOPT_0x19
	BRNE _0x11D
; 0000 0234                    ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 0235             break;
; 0000 0236 
; 0000 0237             default:break;
_0x11D:
; 0000 0238                 }
_0x118:
; 0000 0239 
; 0000 023A      goto exit1;
; 0000 023B       }
; 0000 023C    }
_0x115:
_0xD0:
; 0000 023D 
; 0000 023E    exit1:
_0xB4:
; 0000 023F   }
	RET
; .FEND
;
;void last()
; 0000 0242 {
_last:
; .FSTART _last
; 0000 0243  static char state;
; 0000 0244 
; 0000 0245  up= ~up;
	COM  R9
; 0000 0246 
; 0000 0247  if(up)
	TST  R9
	BREQ _0x11E
; 0000 0248    {
; 0000 0249     ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 024A     RIGHT_UP=1;
	SBI  0x1B,0
; 0000 024B     LEFT_UP=1;
	SBI  0x12,2
; 0000 024C 
; 0000 024D     RIGHT_D=0;
	CBI  0x12,3
; 0000 024E     LEFT_D=0;
	CBI  0x1B,1
; 0000 024F 
; 0000 0250     if(cnt < 8)
	LDI  R30,LOW(8)
	CP   R7,R30
	BRSH _0x127
; 0000 0251       {
; 0000 0252        LED_BYTE|= (0x80 >> cnt);
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x12
; 0000 0253         }
; 0000 0254 
; 0000 0255      }
_0x127:
; 0000 0256 
; 0000 0257  else
	RJMP _0x128
_0x11E:
; 0000 0258    {
; 0000 0259     ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 025A     RIGHT_UP=0;
	CBI  0x1B,0
; 0000 025B     LEFT_UP=0;
	CBI  0x12,2
; 0000 025C 
; 0000 025D     RIGHT_D=1;
	SBI  0x12,3
; 0000 025E     LEFT_D=1;
	SBI  0x1B,1
; 0000 025F 
; 0000 0260     if(cnt >= 8)
	LDI  R30,LOW(8)
	CP   R7,R30
	BRLO _0x131
; 0000 0261       {
; 0000 0262        LED_BYTE|= (0x80 >> cnt - 8);
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0xF
; 0000 0263         }
; 0000 0264 
; 0000 0265      }
_0x131:
_0x128:
; 0000 0266 
; 0000 0267    if(state && !up)
	RCALL SUBOPT_0x1C
	CPI  R30,0
	BREQ _0x133
	TST  R9
	BREQ _0x134
_0x133:
	RJMP _0x132
_0x134:
; 0000 0268      {
; 0000 0269       LED_BYTE|= ~(0xFF << state);
	IN   R1,24
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x2
	OUT  0x18,R30
; 0000 026A         }
; 0000 026B 
; 0000 026C    if(state > 8 && up)
_0x132:
	LDS  R26,_state_S0000004000
	CPI  R26,LOW(0x9)
	BRLO _0x136
	TST  R9
	BRNE _0x137
_0x136:
	RJMP _0x135
_0x137:
; 0000 026D      {
; 0000 026E       LED_BYTE|= ~(0xFF << state - 8);
	IN   R1,24
	RCALL SUBOPT_0x1C
	SUBI R30,LOW(8)
	RCALL SUBOPT_0x2
	OUT  0x18,R30
; 0000 026F         }
; 0000 0270 
; 0000 0271  if(cnt == 15 - state)
_0x135:
	RCALL SUBOPT_0x1C
	LDI  R31,0
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R26,R7
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x138
; 0000 0272   {
; 0000 0273    state++;
	RCALL SUBOPT_0x1C
	SUBI R30,-LOW(1)
	STS  _state_S0000004000,R30
; 0000 0274    cnt= 0;
	CLR  R7
; 0000 0275 
; 0000 0276     if(state == 16)
	LDS  R26,_state_S0000004000
	CPI  R26,LOW(0x10)
	BRNE _0x139
; 0000 0277      {
; 0000 0278       state=0;
	LDI  R30,LOW(0)
	STS  _state_S0000004000,R30
; 0000 0279       time=0;
	RCALL SUBOPT_0x1B
; 0000 027A       sens_t=0;
	CLR  R2
	CLR  R3
; 0000 027B       putchar('W');
	LDI  R26,LOW(87)
	RCALL _putchar
; 0000 027C       cbi(flag, LAST_FLAG);
	LDI  R30,LOW(247)
	AND  R8,R30
; 0000 027D       cbi(flag, TUCH_FLAG);
	LDI  R30,LOW(191)
	AND  R8,R30
; 0000 027E       sbi(flag, MIG_FLAG);
	LDI  R30,LOW(16)
	OR   R8,R30
; 0000 027F       RIGHT_UP=0;
	RCALL SUBOPT_0x1D
; 0000 0280       LEFT_UP=0;
; 0000 0281 
; 0000 0282       RIGHT_D=0;
; 0000 0283       LEFT_D=0;
; 0000 0284       cnt=0;
	CLR  R7
; 0000 0285       up=0;
	CLR  R9
; 0000 0286        }
; 0000 0287        }
_0x139:
; 0000 0288        }
_0x138:
	RET
; .FEND
;
;void mig()
; 0000 028B {
_mig:
; .FSTART _mig
; 0000 028C  static char val;
; 0000 028D 
; 0000 028E  RIGHT_UP=1;
	SBI  0x1B,0
; 0000 028F  LEFT_UP=1;
	SBI  0x12,2
; 0000 0290 
; 0000 0291  RIGHT_D=1;
	SBI  0x12,3
; 0000 0292  LEFT_D=1;
	SBI  0x1B,1
; 0000 0293  ALL_ON;
	RCALL SUBOPT_0x1A
; 0000 0294 
; 0000 0295  if(cnt < 25) ALL_ON;
	LDI  R30,LOW(25)
	CP   R7,R30
	BRSH _0x14A
	RCALL SUBOPT_0x1A
; 0000 0296  if(cnt > 25) ALL_OFF;
_0x14A:
	LDI  R30,LOW(25)
	CP   R30,R7
	BRSH _0x14B
	RCALL SUBOPT_0x5
; 0000 0297 
; 0000 0298  if(cnt == 50)
_0x14B:
	LDI  R30,LOW(50)
	CP   R30,R7
	BRNE _0x14C
; 0000 0299    {
; 0000 029A     cnt=0;
	CLR  R7
; 0000 029B     val++;
	LDS  R30,_val_S0000005000
	SUBI R30,-LOW(1)
	STS  _val_S0000005000,R30
; 0000 029C 
; 0000 029D      if(val == 7)
	LDS  R26,_val_S0000005000
	CPI  R26,LOW(0x7)
	BRNE _0x14D
; 0000 029E      {
; 0000 029F       cbi(flag, MIG_FLAG);
	LDI  R30,LOW(239)
	AND  R8,R30
; 0000 02A0       cbi(flag, TUCH_FLAG);
	LDI  R30,LOW(191)
	AND  R8,R30
; 0000 02A1 
; 0000 02A2       RIGHT_UP=0;
	RCALL SUBOPT_0x1D
; 0000 02A3       LEFT_UP=0;
; 0000 02A4 
; 0000 02A5       RIGHT_D=0;
; 0000 02A6       LEFT_D=0;
; 0000 02A7       ALL_OFF;
	RCALL SUBOPT_0x5
; 0000 02A8       MUSIC=0;
	CBI  0x12,6
; 0000 02A9       val=0;
	LDI  R30,LOW(0)
	STS  _val_S0000005000,R30
; 0000 02AA       time=0;
	RCALL SUBOPT_0x1B
; 0000 02AB       sens_t=0;
	CLR  R2
	CLR  R3
; 0000 02AC       inv=0;
	CLR  R6
; 0000 02AD       up=0;
	CLR  R9
; 0000 02AE       flag=0;
	CLR  R8
; 0000 02AF       cnt=0;
	CLR  R7
; 0000 02B0       }
; 0000 02B1       }
_0x14D:
; 0000 02B2       }
_0x14C:
	RET
; .FEND
;
;void sensor_drv()
; 0000 02B5 {
_sensor_drv:
; .FSTART _sensor_drv
; 0000 02B6   if(SENSOR)
	SBIS 0x10,4
	RJMP _0x158
; 0000 02B7          {
; 0000 02B8           sens_t = time;
	MOVW R2,R4
; 0000 02B9           PUT_DOWN;
	SBI  0x11,4
	CBI  0x12,4
; 0000 02BA           //putchar(sens_t+48);
; 0000 02BB            if(sens_t > TIME_NOTUCH)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R2
	CPC  R31,R3
	BRSH _0x159
; 0000 02BC              {
; 0000 02BD               sbi(flag, TUCH_FLAG);
	LDI  R30,LOW(64)
	OR   R8,R30
; 0000 02BE               putchar(sens_t+48);
	MOV  R26,R2
	SUBI R26,-LOW(48)
	RCALL _putchar
; 0000 02BF                }
; 0000 02C0           sens_t=0;
_0x159:
	CLR  R2
	CLR  R3
; 0000 02C1           time=0;
	RCALL SUBOPT_0x1B
; 0000 02C2           SET_INPUT;
	CBI  0x11,4
	CBI  0x12,4
; 0000 02C3            }
; 0000 02C4         }
_0x158:
	RET
; .FEND
;
;void WD()
; 0000 02C7 {
_WD:
; .FSTART _WD
; 0000 02C8  #asm("cli")
	cli
; 0000 02C9  #asm("wdr")
	wdr
; 0000 02CA  WDTCSR |= (1<<WDCE) | (1<<WDE);
	IN   R30,0x21
	ORI  R30,LOW(0x18)
	OUT  0x21,R30
; 0000 02CB  WDTCSR = (1<<WDE) | (1<<WDP2) | (1<<WDP0);
	LDI  R30,LOW(13)
	OUT  0x21,R30
; 0000 02CC  #asm("sei")
	sei
; 0000 02CD }
	RET
; .FEND
;
;void main()
; 0000 02D0 {
_main:
; .FSTART _main
; 0000 02D1  initdev();
	RCALL _initdev
; 0000 02D2  WD();
	RCALL _WD
; 0000 02D3  PUT_DOWN;
	SBI  0x11,4
	CBI  0x12,4
; 0000 02D4  delay_us(500);
	__DELAY_USB 167
; 0000 02D5  SET_INPUT;
	CBI  0x11,4
	CBI  0x12,4
; 0000 02D6  #asm("sei")
	sei
; 0000 02D7 
; 0000 02D8  putsf(rst);
	LDI  R26,LOW(_rst*2)
	LDI  R27,HIGH(_rst*2)
	RCALL _putsf
; 0000 02D9 
; 0000 02DA   while (1)
_0x15A:
; 0000 02DB       {
; 0000 02DC        #asm("wdr")
	wdr
; 0000 02DD        if( (flag & (1<<TUCH_FLAG)) && !(flag & (1<<LINE_FLAG)) && !(flag & (1<<ONE_LED_FLAG))
; 0000 02DE        && !(flag & (1<<FULL_FLAG)) && !(flag & (1<<LAST_FLAG)) && !(flag & (1<<MIG_FLAG)) )
	SBRS R8,6
	RJMP _0x15E
	SBRC R8,0
	RJMP _0x15E
	SBRC R8,1
	RJMP _0x15E
	SBRC R8,2
	RJMP _0x15E
	SBRC R8,3
	RJMP _0x15E
	SBRS R8,4
	RJMP _0x15F
_0x15E:
	RJMP _0x15D
_0x15F:
; 0000 02DF          {
; 0000 02E0           cbi(flag, TUCH_FLAG);
	LDI  R30,LOW(191)
	AND  R8,R30
; 0000 02E1           sbi(flag, LINE_FLAG);
	LDI  R30,LOW(1)
	OR   R8,R30
; 0000 02E2           MUSIC=1;
	SBI  0x12,6
; 0000 02E3           cnt=0;
	CLR  R7
; 0000 02E4           time=0;
	RCALL SUBOPT_0x1B
; 0000 02E5           putchar('T');
	LDI  R26,LOW(84)
	RCALL _putchar
; 0000 02E6             }
; 0000 02E7        }
_0x15D:
	RJMP _0x15A
; 0000 02E8        }
_0x162:
	RJMP _0x162
; .FEND
;
;interrupt [TIM0_COMPA] void comp_a_25us()
; 0000 02EB {
_comp_a_25us:
; .FSTART _comp_a_25us
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 02EC  RST_T0;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 02ED  sensor_drv();
	RCALL _sensor_drv
; 0000 02EE  time++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 02EF 
; 0000 02F0     if( flag & (1<<LINE_FLAG) )    line();
	SBRC R8,0
	RCALL _line
; 0000 02F1 
; 0000 02F2     if( flag & (1<<ONE_LED_FLAG) ) one_led();
	SBRC R8,1
	RCALL _one_led
; 0000 02F3 
; 0000 02F4     if( flag & (1<<FULL_FLAG) )    full();
	SBRC R8,2
	RCALL _full
; 0000 02F5 
; 0000 02F6     if( flag & (1<<LAST_FLAG) )    last();
	SBRC R8,3
	RCALL _last
; 0000 02F7 
; 0000 02F8     if( flag & (1<<MIG_FLAG) )      mig();
	SBRC R8,4
	RCALL _mig
; 0000 02F9 
; 0000 02FA   }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;interrupt [TIM1_COMPA] void comp_a_200ms()
; 0000 02FD {
_comp_a_200ms:
; .FSTART _comp_a_200ms
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 02FE  RST_T1;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
; 0000 02FF  cnt++;
	INC  R7
; 0000 0300  }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
; .FEND
_putsf:
; .FSTART _putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000006:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000008
	MOV  R26,R17
	RCALL _putchar
	RJMP _0x2000006
_0x2000008:
	LDI  R26,LOW(10)
	RCALL _putchar
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_j_S0000003000:
	.BYTE 0x1
_state_S0000004000:
	.BYTE 0x1
_val_S0000005000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x18,R30
	SBI  0x12,2
	SBI  0x1B,0
	CBI  0x1B,1
	CBI  0x12,3
	LDI  R30,LOW(7)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1:
	IN   R1,24
	MOV  R30,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(255)
	RCALL __LSLB12
	COM  R30
	OR   R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	CBI  0x12,2
	CBI  0x1B,0
	SBI  0x1B,1
	SBI  0x12,3
	LDI  R30,LOW(7)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(255)
	RCALL __LSRB12
	COM  R30
	OR   R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	RCALL __LSRW12
	COM  R30
	OR   R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(23)
	CP   R30,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	CBI  0x1B,0
	CBI  0x12,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	SUBI R30,LOW(24)
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R30,R1
	OUT  0x18,R30
	IN   R30,0x18
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(15)
	CP   R30,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	CBI  0x12,2
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	SUBI R30,LOW(16)
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R30,R1
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(7)
	CP   R30,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	CBI  0x1B,0
	SBI  0x12,3
	CBI  0x1B,1
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xF:
	SUBI R30,LOW(8)
	LDI  R26,LOW(128)
	LDI  R27,HIGH(128)
	RCALL __LSRW12
	OR   R30,R1
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(7)
	CP   R7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	SBI  0x1B,0
	CBI  0x12,3
	CBI  0x1B,1
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(128)
	RCALL __LSRB12
	OR   R30,R1
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x13:
	LDS  R30,_j_S0000003000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x14:
	RCALL SUBOPT_0x13
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	SBI  0x1B,0
	CBI  0x12,3
	CBI  0x1B,1
	CBI  0x12,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x16:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	CBI  0x1B,0
	SBI  0x12,3
	CBI  0x1B,1
	CBI  0x12,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x18:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x19:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(255)
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	CLR  R4
	CLR  R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	LDS  R30,_state_S0000004000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CBI  0x1B,0
	CBI  0x12,2
	CBI  0x12,3
	CBI  0x1B,1
	RET


	.CSEG
__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSRW12R
__LSRW12L:
	LSR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRW12L
__LSRW12R:
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

;END OF CODE MARKER
__END_OF_CODE:
