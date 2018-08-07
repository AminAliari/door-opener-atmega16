
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 2.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _state=R4
	.DEF _state_msb=R5
	.DEF _cursor=R6
	.DEF _cursor_msb=R7
	.DEF _access=R8
	.DEF _access_msb=R9
	.DEF _freeUserIndex=R10
	.DEF _freeUserIndex_msb=R11
	.DEF __lcd_x=R13
	.DEF __lcd_y=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x2,0x0,0xFF,0xFF

_0x0:
	.DB  0x30,0x30,0x30,0x30,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x69,0x6E
	.DB  0x76,0x61,0x6C,0x69,0x64,0x20,0x69,0x6E
	.DB  0x70,0x75,0x74,0x0,0x66,0x75,0x6C,0x6C
	.DB  0x0,0x73,0x75,0x63,0x63,0x65,0x73,0x73
	.DB  0x66,0x75,0x6C,0x0,0x6C,0x6F,0x61,0x64
	.DB  0x69,0x6E,0x67,0x20,0x64,0x61,0x74,0x61
	.DB  0x2E,0x2E,0x2E,0x0,0x6C,0x6F,0x61,0x64
	.DB  0x65,0x64,0x0,0x75,0x73,0x65,0x72,0x20
	.DB  0x69,0x64,0x3A,0x0,0x70,0x61,0x73,0x73
	.DB  0x77,0x6F,0x72,0x64,0x3A,0x0,0x63,0x68
	.DB  0x65,0x63,0x6B,0x69,0x6E,0x67,0x2E,0x2E
	.DB  0x2E,0x0,0x77,0x72,0x6F,0x6E,0x67,0x20
	.DB  0x69,0x64,0x20,0x6F,0x72,0x20,0x70,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x0,0x63
	.DB  0x68,0x65,0x63,0x6B,0x69,0x6E,0x67,0x20
	.DB  0x61,0x63,0x63,0x65,0x73,0x73,0x0,0x61
	.DB  0x63,0x63,0x65,0x73,0x73,0x20,0x67,0x72
	.DB  0x61,0x6E,0x74,0x65,0x64,0x0,0x6E,0x6F
	.DB  0x20,0x61,0x63,0x63,0x65,0x73,0x73,0x0
	.DB  0x31,0x2E,0x6F,0x70,0x65,0x6E,0x20,0x32
	.DB  0x2E,0x61,0x64,0x64,0x20,0x20,0x20,0x20
	.DB  0x33,0x2E,0x64,0x65,0x6C,0x20,0x34,0x2E
	.DB  0x61,0x63,0x20,0x2A,0x2E,0x65,0x78,0x63
	.DB  0x0,0x65,0x6E,0x74,0x65,0x72,0x20,0x75
	.DB  0x73,0x65,0x72,0x20,0x69,0x64,0x3A,0x0
	.DB  0x31,0x20,0x70,0x75,0x62,0x6C,0x69,0x63
	.DB  0x0,0x32,0x20,0x75,0x73,0x65,0x72,0x73
	.DB  0x20,0x6F,0x6E,0x6C,0x79,0x0,0x33,0x20
	.DB  0x6E,0x6F,0x6E,0x65,0x0,0x2A,0x20,0x62
	.DB  0x61,0x63,0x6B,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x05
	.DW  _0x16
	.DW  _0x0*2

	.DW  0x11
	.DW  _0x1E
	.DW  _0x0*2+5

	.DW  0x05
	.DW  _0x29
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x29+5
	.DW  _0x0*2

	.DW  0x0E
	.DW  _0x7C
	.DW  _0x0*2+22

	.DW  0x05
	.DW  _0x7C+14
	.DW  _0x0*2+36

	.DW  0x0B
	.DW  _0x7C+19
	.DW  _0x0*2+41

	.DW  0x0B
	.DW  _0x7C+30
	.DW  _0x0*2+41

	.DW  0x0B
	.DW  _0x7C+41
	.DW  _0x0*2+41

	.DW  0x0E
	.DW  _0x7C+52
	.DW  _0x0*2+22

	.DW  0x10
	.DW  _0xA1
	.DW  _0x0*2+52

	.DW  0x07
	.DW  _0xA1+16
	.DW  _0x0*2+68

	.DW  0x09
	.DW  _0xA1+23
	.DW  _0x0*2+75

	.DW  0x0A
	.DW  _0xA1+32
	.DW  _0x0*2+84

	.DW  0x0A
	.DW  _0xA1+42
	.DW  _0x0*2+84

	.DW  0x0C
	.DW  _0xA1+52
	.DW  _0x0*2+94

	.DW  0x15
	.DW  _0xA1+64
	.DW  _0x0*2+106

	.DW  0x10
	.DW  _0xA1+85
	.DW  _0x0*2+127

	.DW  0x0F
	.DW  _0xA1+101
	.DW  _0x0*2+143

	.DW  0x0A
	.DW  _0xA1+116
	.DW  _0x0*2+158

	.DW  0x10
	.DW  _0xA1+126
	.DW  _0x0*2+127

	.DW  0x0F
	.DW  _0xA1+142
	.DW  _0x0*2+143

	.DW  0x0A
	.DW  _0xA1+157
	.DW  _0x0*2+158

	.DW  0x21
	.DW  _0xA1+167
	.DW  _0x0*2+168

	.DW  0x0F
	.DW  _0xA1+200
	.DW  _0x0*2+201

	.DW  0x0F
	.DW  _0xA1+215
	.DW  _0x0*2+201

	.DW  0x09
	.DW  _0xA1+230
	.DW  _0x0*2+216

	.DW  0x0D
	.DW  _0xA1+239
	.DW  _0x0*2+225

	.DW  0x07
	.DW  _0xA1+252
	.DW  _0x0*2+238

	.DW  0x07
	.DW  _0xA1+259
	.DW  _0x0*2+245

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <alcd.h>
;#include <delay.h>
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdint.h>
;#include <stdlib.h>
;#include <eeprom.h>
;#include <string.h>
;
;// states
;#define IDLE -1
;#define INIT 0
;#define LOGIN_USER 1
;#define LOGIN_PASS_INIT 2
;#define LOGIN_PASS 3
;#define LOGIN_CHECK 4
;#define LOGIN_ERROR 5
;#define USER_LOGGED 6
;#define GUEST_LOGGED 7
;#define ADMIN_MENU 8
;#define ADMIN_CHECK 9
;#define ADMIN_ADD 10
;#define ADMIN_ADD_ID 11
;#define ADMIN_ADD_PASS_INIT 12
;#define ADMIN_ADD_PASS 13
;#define ADMIN_DEL 14
;#define ADMIN_DEL_CHECK 15
;#define ADMIN_CNT 16
;#define ADMIN_CNT_CHECK 17
;#define DOOR_OPEN 18
;
;// constants
;const int MAX_USER = 10;
;
;
;// structs
;typedef struct {
;  char id[4];
;  char password[4];
;} User;
;
;// variables
;char ADMIN_PASS[4];
;char ADMIN_ID[4];
;char GUEST_ID[4];
;char GUEST_PASS[4];
;
;
;int state = 0;
;int cursor = 0;
;int access = 2;
;int EEMEM eaccess = 0;
;int freeUserIndex = -1;
;
;
;User currentUser;
;User users[MAX_USER];
;User EEMEM eusers[MAX_USER];
;
;// functions
;
;int isValid(char* A){
; 0000 003D int isValid(char* A){

	.CSEG
_isValid:
; .FSTART _isValid
; 0000 003E   int i;
; 0000 003F   for (i = 0; i < 4; i++) {
	CALL SUBOPT_0x0
;	*A -> Y+2
;	i -> R16,R17
_0x4:
	__CPWRN 16,17,4
	BRGE _0x5
; 0000 0040     if (((int) A[i]) >= '0' || ((int) A[i]) <= '9' );
	CALL SUBOPT_0x1
	SBIW R26,48
	BRGE _0x7
	CALL SUBOPT_0x1
	SBIW R26,58
	BRGE _0x6
_0x7:
; 0000 0041     else return 0;
	RJMP _0x9
_0x6:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20C0006
; 0000 0042   }
_0x9:
	__ADDWRN 16,17,1
	RJMP _0x4
_0x5:
; 0000 0043   return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x20C0006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; 0000 0044 }
; .FEND
;void move(char* A,char* B){
; 0000 0045 void move(char* A,char* B){
_move:
; .FSTART _move
; 0000 0046   int i;
; 0000 0047   for (i = 0; i<4; i++)
	CALL SUBOPT_0x0
;	*A -> Y+4
;	*B -> Y+2
;	i -> R16,R17
_0xB:
	__CPWRN 16,17,4
	BRGE _0xC
; 0000 0048     A[i] = B[i];
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0x2
	MOVW R26,R0
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0xB
_0xC:
; 0000 0049 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20C0001
; .FEND
;int equals(char* A,char* B){
; 0000 004A int equals(char* A,char* B){
_equals:
; .FSTART _equals
; 0000 004B   int i;
; 0000 004C   for (i = 0; i<4; i++) {
	CALL SUBOPT_0x0
;	*A -> Y+4
;	*B -> Y+2
;	i -> R16,R17
_0xE:
	__CPWRN 16,17,4
	BRGE _0xF
; 0000 004D     if (A[i] == B[i]);
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X
	CALL SUBOPT_0x2
	CP   R30,R0
	BREQ _0x11
; 0000 004E     else {
; 0000 004F       delay_ms(1000);
	CALL SUBOPT_0x3
; 0000 0050       return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20C0001
; 0000 0051     }
_0x11:
; 0000 0052   }
	__ADDWRN 16,17,1
	RJMP _0xE
_0xF:
; 0000 0053   return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20C0001
; 0000 0054 }
; .FEND
;
;void loadData() {
; 0000 0056 void loadData() {
_loadData:
; .FSTART _loadData
; 0000 0057   int i;
; 0000 0058   // load users
; 0000 0059 
; 0000 005A   for ( i = 0 ;i < MAX_USER ; i++) {
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x13:
	__CPWRN 16,17,10
	BRGE _0x14
; 0000 005B     eeprom_read_block(&users[i], &eusers[i], sizeof(users[i]));
	CALL SUBOPT_0x4
	CALL _eeprom_read_block
; 0000 005C     if (equals(users[i].id,"0000") || !isValid(users[i].id)){
	CALL SUBOPT_0x5
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x16,0
	RCALL _equals
	SBIW R30,0
	BRNE _0x17
	CALL SUBOPT_0x5
	MOVW R26,R30
	RCALL _isValid
	SBIW R30,0
	BRNE _0x15
_0x17:
; 0000 005D       freeUserIndex = i;
	MOVW R10,R16
; 0000 005E       break;
	RJMP _0x14
; 0000 005F     }
; 0000 0060     // freeUserIndex = 0;
; 0000 0061   }
_0x15:
	__ADDWRN 16,17,1
	RJMP _0x13
_0x14:
; 0000 0062   // load access
; 0000 0063   eeprom_read_block(&access, &eaccess, sizeof(access));
	CALL SUBOPT_0x6
	CALL _eeprom_read_block
; 0000 0064 }
	RJMP _0x20C0005
; .FEND

	.DSEG
_0x16:
	.BYTE 0x5
;
;void writeData() {
; 0000 0066 void writeData() {

	.CSEG
_writeData:
; .FSTART _writeData
; 0000 0067   // write users
; 0000 0068   int i;
; 0000 0069   for (i=0;i<MAX_USER;i++) {
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x1A:
	__CPWRN 16,17,10
	BRGE _0x1B
; 0000 006A     eeprom_write_block(&users[i], &eusers[i], sizeof(users[i]));
	CALL SUBOPT_0x4
	CALL _eeprom_write_block
; 0000 006B   }
	__ADDWRN 16,17,1
	RJMP _0x1A
_0x1B:
; 0000 006C 
; 0000 006D   // write access
; 0000 006E   eeprom_write_block(&access, &eaccess, sizeof(access));
	CALL SUBOPT_0x6
	CALL _eeprom_write_block
; 0000 006F }
	RJMP _0x20C0005
; .FEND
;
;void put(char c) {
; 0000 0071 void put(char c) {
_put:
; .FSTART _put
; 0000 0072   if (cursor > 14) return;
	ST   -Y,R26
;	c -> Y+0
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x1C
	JMP  _0x20C0004
; 0000 0073 
; 0000 0074   lcd_gotoxy(cursor, 1);
_0x1C:
	ST   -Y,R6
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0075   lcd_putchar(c);
	LD   R26,Y
	CALL _lcd_putchar
; 0000 0076   cursor++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0077 }
	JMP  _0x20C0004
; .FEND
;
;void clear() {
; 0000 0079 void clear() {
_clear:
; .FSTART _clear
; 0000 007A   if (cursor < 1) return;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x1D
	RET
; 0000 007B   cursor--;
_0x1D:
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
; 0000 007C   lcd_gotoxy(cursor, 1);
	ST   -Y,R6
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 007D   lcd_putchar('');
	LDI  R26,LOW(0)
	CALL _lcd_putchar
; 0000 007E }
	RET
; .FEND
;
;void clearLine() {
; 0000 0080 void clearLine() {
; 0000 0081   cursor = 0;
; 0000 0082   lcd_gotoxy(cursor, 1);
; 0000 0083   lcd_puts("                ");
; 0000 0084 }

	.DSEG
_0x1E:
	.BYTE 0x11
;
;void addUser(User u) {
; 0000 0086 void addUser(User u) {

	.CSEG
_addUser:
; .FSTART _addUser
; 0000 0087   int j;
; 0000 0088   memcpy(&users[freeUserIndex], &u, sizeof(u));
	ST   -Y,R17
	ST   -Y,R16
;	u -> Y+2
;	j -> R16,R17
	MOVW R30,R10
	CALL SUBOPT_0x7
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memcpy
; 0000 0089   freeUserIndex++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 008A   for(j=0;j<4;j++)
	__GETWRN 16,17,0
_0x20:
	__CPWRN 16,17,4
	BRGE _0x21
; 0000 008B   users[freeUserIndex].id[j] = '0';
	MOVW R30,R10
	CALL SUBOPT_0x7
	ADD  R30,R16
	ADC  R31,R17
	LDI  R26,LOW(48)
	STD  Z+0,R26
	__ADDWRN 16,17,1
	RJMP _0x20
_0x21:
; 0000 008C writeData();
	RCALL _writeData
; 0000 008D }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20C0003
; .FEND
;
;void delUser(User u) {
; 0000 008F void delUser(User u) {
_delUser:
; .FSTART _delUser
; 0000 0090   int i;
; 0000 0091   int j;
; 0000 0092   loadData();
	CALL __SAVELOCR4
;	u -> Y+4
;	i -> R16,R17
;	j -> R18,R19
	RCALL _loadData
; 0000 0093   for (i=0;i<MAX_USER;i++) {
	__GETWRN 16,17,0
_0x23:
	__CPWRN 16,17,10
	BRGE _0x24
; 0000 0094     if (equals(users[i].id , u.id)) {
	CALL SUBOPT_0x5
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,6
	RCALL _equals
	SBIW R30,0
	BREQ _0x25
; 0000 0095         for (j = i; j < MAX_USER-1; j++) {
	MOVW R18,R16
_0x27:
	__CPWRN 18,19,9
	BRGE _0x28
; 0000 0096           move(users[j].id,users[j+1].id);
	MOVW R30,R18
	CALL SUBOPT_0x7
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,1
	CALL SUBOPT_0x7
	MOVW R26,R30
	RCALL _move
; 0000 0097           move(users[j].password,users[j+1].password);
	MOVW R30,R18
	CALL SUBOPT_0x8
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,1
	CALL SUBOPT_0x8
	MOVW R26,R30
	RCALL _move
; 0000 0098         }
	__ADDWRN 18,19,1
	RJMP _0x27
_0x28:
; 0000 0099         move(users[MAX_USER-1].id,"0000");
	__POINTW1MN _users,72
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x29,0
	RCALL _move
; 0000 009A         move(users[MAX_USER-1].id,"0000");
	__POINTW1MN _users,72
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x29,5
	RCALL _move
; 0000 009B         freeUserIndex--;
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
; 0000 009C         break;
	RJMP _0x24
; 0000 009D     }
; 0000 009E   }
_0x25:
	__ADDWRN 16,17,1
	RJMP _0x23
_0x24:
; 0000 009F   writeData();
	RCALL _writeData
; 0000 00A0   // int i;
; 0000 00A1   // int j;
; 0000 00A2   // loadData();
; 0000 00A3   // for (i=0;i<MAX_USER;i++) {
; 0000 00A4   //   if (equals(users[i].id , u.id)) {
; 0000 00A5   //     lcd_clear();
; 0000 00A6   //     lcd_puts("yay");
; 0000 00A7   //     delay_ms(1000);
; 0000 00A8   //     for (j = i; j < MAX_USER-1; j++) {
; 0000 00A9   //     }
; 0000 00AA   //     memcpy(&users[freeUserIndex], &u, sizeof(u));
; 0000 00AB   //     freeUserIndex--;
; 0000 00AC   //     writeData();
; 0000 00AD   //  }
; 0000 00AE   //}
; 0000 00AF }
	CALL __LOADLOCR4
	ADIW R28,12
	RET
; .FEND

	.DSEG
_0x29:
	.BYTE 0xA
;
;
;
;
;char getKey() {
; 0000 00B4 char getKey() {

	.CSEG
_getKey:
; .FSTART _getKey
; 0000 00B5   char pressedKey = '';
; 0000 00B6 
; 0000 00B7   PORTC.0 = 0;
	ST   -Y,R17
;	pressedKey -> R17
	LDI  R17,0
	CBI  0x15,0
; 0000 00B8   PORTC.1 = 1;
	SBI  0x15,1
; 0000 00B9   PORTC.2 = 1;
	SBI  0x15,2
; 0000 00BA 
; 0000 00BB   if (PINC.0 == 0) {
	SBIC 0x13,0
	RJMP _0x30
; 0000 00BC     if (PINC.3 == 0) {
	SBIC 0x13,3
	RJMP _0x31
; 0000 00BD       pressedKey = '1';
	LDI  R17,LOW(49)
; 0000 00BE     }else if (PINC.4 == 0) {
	RJMP _0x32
_0x31:
	SBIC 0x13,4
	RJMP _0x33
; 0000 00BF       pressedKey = '4';
	LDI  R17,LOW(52)
; 0000 00C0     }else if (PINC.5 == 0) {
	RJMP _0x34
_0x33:
	SBIC 0x13,5
	RJMP _0x35
; 0000 00C1       pressedKey = '7';
	LDI  R17,LOW(55)
; 0000 00C2     }else if (PINC.6 == 0) {
	RJMP _0x36
_0x35:
	SBIS 0x13,6
; 0000 00C3       pressedKey = '*';
	LDI  R17,LOW(42)
; 0000 00C4     }
; 0000 00C5   }
_0x36:
_0x34:
_0x32:
; 0000 00C6 
; 0000 00C7   PORTC.0 = 1;
_0x30:
	SBI  0x15,0
; 0000 00C8   PORTC.1 = 0;
	CBI  0x15,1
; 0000 00C9   PORTC.2 = 1;
	SBI  0x15,2
; 0000 00CA 
; 0000 00CB   if (PINC.1 == 0) {
	SBIC 0x13,1
	RJMP _0x3E
; 0000 00CC     if (PINC.3 == 0) {
	SBIC 0x13,3
	RJMP _0x3F
; 0000 00CD       pressedKey = '2';
	LDI  R17,LOW(50)
; 0000 00CE     }else if (PINC.4 == 0) {
	RJMP _0x40
_0x3F:
	SBIC 0x13,4
	RJMP _0x41
; 0000 00CF       pressedKey = '5';
	LDI  R17,LOW(53)
; 0000 00D0     }else if (PINC.5 == 0) {
	RJMP _0x42
_0x41:
	SBIC 0x13,5
	RJMP _0x43
; 0000 00D1       pressedKey = '8';
	LDI  R17,LOW(56)
; 0000 00D2     }else if (PINC.6 == 0) {
	RJMP _0x44
_0x43:
	SBIS 0x13,6
; 0000 00D3       pressedKey = '0';
	LDI  R17,LOW(48)
; 0000 00D4     }
; 0000 00D5   }
_0x44:
_0x42:
_0x40:
; 0000 00D6 
; 0000 00D7   PORTC.0 = 1;
_0x3E:
	SBI  0x15,0
; 0000 00D8   PORTC.1 = 1;
	SBI  0x15,1
; 0000 00D9   PORTC.2 = 0;
	CBI  0x15,2
; 0000 00DA 
; 0000 00DB   if (PINC.2 == 0) {
	SBIC 0x13,2
	RJMP _0x4C
; 0000 00DC     if (PINC.3 == 0) {
	SBIC 0x13,3
	RJMP _0x4D
; 0000 00DD       pressedKey = '3';
	LDI  R17,LOW(51)
; 0000 00DE     }else if (PINC.4 == 0) {
	RJMP _0x4E
_0x4D:
	SBIC 0x13,4
	RJMP _0x4F
; 0000 00DF       pressedKey = '6';
	LDI  R17,LOW(54)
; 0000 00E0     }else if (PINC.5 == 0) {
	RJMP _0x50
_0x4F:
	SBIC 0x13,5
	RJMP _0x51
; 0000 00E1       pressedKey = '9';
	LDI  R17,LOW(57)
; 0000 00E2     }else if (PINC.6 == 0) {
	RJMP _0x52
_0x51:
	SBIS 0x13,6
; 0000 00E3       pressedKey = '#';
	LDI  R17,LOW(35)
; 0000 00E4     }
; 0000 00E5   }
_0x52:
_0x50:
_0x4E:
; 0000 00E6 
; 0000 00E7   PORTC.0 = 0;
_0x4C:
	CBI  0x15,0
; 0000 00E8   PORTC.1 = 0;
	CBI  0x15,1
; 0000 00E9   PORTC.2 = 0;
	CBI  0x15,2
; 0000 00EA 
; 0000 00EB   return pressedKey;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 00EC }
; .FEND
;
;int authenticate() {
; 0000 00EE int authenticate() {
_authenticate:
; .FSTART _authenticate
; 0000 00EF   int i;
; 0000 00F0   if (equals(currentUser.id , GUEST_ID)) {
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDI  R30,LOW(_currentUser)
	LDI  R31,HIGH(_currentUser)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_GUEST_ID)
	LDI  R27,HIGH(_GUEST_ID)
	RCALL _equals
	SBIW R30,0
	BREQ _0x5A
; 0000 00F1     return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20C0005
; 0000 00F2   }
; 0000 00F3 
; 0000 00F4   if (equals(currentUser.id , ADMIN_ID) && equals(currentUser.password , ADMIN_PASS)) {
_0x5A:
	LDI  R30,LOW(_currentUser)
	LDI  R31,HIGH(_currentUser)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_ADMIN_ID)
	LDI  R27,HIGH(_ADMIN_ID)
	RCALL _equals
	SBIW R30,0
	BREQ _0x5C
	__POINTW1MN _currentUser,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_ADMIN_PASS)
	LDI  R27,HIGH(_ADMIN_PASS)
	RCALL _equals
	SBIW R30,0
	BRNE _0x5D
_0x5C:
	RJMP _0x5B
_0x5D:
; 0000 00F5     return 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x20C0005
; 0000 00F6   }
; 0000 00F7 
; 0000 00F8   for (i=0;i<MAX_USER;i++) {
_0x5B:
	__GETWRN 16,17,0
_0x5F:
	__CPWRN 16,17,10
	BRGE _0x60
; 0000 00F9     if (equals(users[i].id , currentUser.id) && equals(users[i].password , currentUser.password)) {
	CALL SUBOPT_0x5
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_currentUser)
	LDI  R27,HIGH(_currentUser)
	RCALL _equals
	SBIW R30,0
	BREQ _0x62
	MOVW R30,R16
	CALL SUBOPT_0x8
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _currentUser,4
	RCALL _equals
	SBIW R30,0
	BRNE _0x63
_0x62:
	RJMP _0x61
_0x63:
; 0000 00FA       return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20C0005
; 0000 00FB     }
; 0000 00FC   }
_0x61:
	__ADDWRN 16,17,1
	RJMP _0x5F
_0x60:
; 0000 00FD   return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x20C0005:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 00FE }
; .FEND
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void) {
; 0000 0101 interrupt [2] void ext_int0_isr(void) {
_ext_int0_isr:
; .FSTART _ext_int0_isr
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
; 0000 0102   char pressedKey = '';
; 0000 0103   switch (state) {
	ST   -Y,R17
;	pressedKey -> R17
	LDI  R17,0
	MOVW R30,R4
; 0000 0104     case LOGIN_USER:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x67
; 0000 0105     pressedKey = getKey();
	CALL SUBOPT_0x9
; 0000 0106     if (pressedKey == '#') {
	BRNE _0x68
; 0000 0107       cursor = 0;
	CLR  R6
	CLR  R7
; 0000 0108       state = LOGIN_PASS_INIT;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 0109     }else if (pressedKey == '*') {
	RJMP _0x69
_0x68:
	CPI  R17,42
	BRNE _0x6A
; 0000 010A       clear();
	RCALL _clear
; 0000 010B     }else{
	RJMP _0x6B
_0x6A:
; 0000 010C       currentUser.id[cursor] = pressedKey;
	CALL SUBOPT_0xA
; 0000 010D       put(pressedKey);
; 0000 010E     }
_0x6B:
_0x69:
; 0000 010F     break;
	RJMP _0x66
; 0000 0110     case LOGIN_PASS:
_0x67:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6C
; 0000 0111     pressedKey = getKey();
	CALL SUBOPT_0x9
; 0000 0112     if (pressedKey == '#') {
	BRNE _0x6D
; 0000 0113       cursor = 0;
	CLR  R6
	CLR  R7
; 0000 0114       state = LOGIN_CHECK;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R4,R30
; 0000 0115     }else if (pressedKey == '*') {
	RJMP _0x6E
_0x6D:
	CPI  R17,42
	BRNE _0x6F
; 0000 0116       clear();
	RCALL _clear
; 0000 0117     }else{
	RJMP _0x70
_0x6F:
; 0000 0118       currentUser.password[cursor] = pressedKey;
	CALL SUBOPT_0xB
; 0000 0119       put('*');
; 0000 011A     }
_0x70:
_0x6E:
; 0000 011B     break;
	RJMP _0x66
; 0000 011C     case ADMIN_CHECK:
_0x6C:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x71
; 0000 011D     pressedKey = getKey();
	RCALL _getKey
	MOV  R17,R30
; 0000 011E     if (pressedKey == '1') {
	CPI  R17,49
	BRNE _0x72
; 0000 011F       state = DOOR_OPEN;
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	RJMP _0xBA
; 0000 0120     }else if (pressedKey == '2') {
_0x72:
	CPI  R17,50
	BRNE _0x74
; 0000 0121       state = ADMIN_ADD;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP _0xBA
; 0000 0122     }else if (pressedKey == '3') {
_0x74:
	CPI  R17,51
	BRNE _0x76
; 0000 0123       state = ADMIN_DEL;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RJMP _0xBA
; 0000 0124     }else if (pressedKey == '4') {
_0x76:
	CPI  R17,52
	BRNE _0x78
; 0000 0125       state = ADMIN_CNT;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP _0xBA
; 0000 0126     }else if (pressedKey == '*') {
_0x78:
	CPI  R17,42
	BRNE _0x7A
; 0000 0127       state = INIT;
	CLR  R4
	CLR  R5
; 0000 0128     }else{
	RJMP _0x7B
_0x7A:
; 0000 0129       lcd_puts("invalid input");
	__POINTW2MN _0x7C,0
	CALL _lcd_puts
; 0000 012A       delay_ms(1000);
	CALL SUBOPT_0x3
; 0000 012B       state = ADMIN_MENU;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
_0xBA:
	MOVW R4,R30
; 0000 012C     }
_0x7B:
; 0000 012D     break;
	RJMP _0x66
; 0000 012E     case ADMIN_ADD_ID:
_0x71:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x7D
; 0000 012F     pressedKey = getKey();
	CALL SUBOPT_0x9
; 0000 0130     if (pressedKey == '#') {
	BRNE _0x7E
; 0000 0131       cursor = 0;
	CLR  R6
	CLR  R7
; 0000 0132       state = ADMIN_ADD_PASS_INIT;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	MOVW R4,R30
; 0000 0133     }else if (pressedKey == '*') {
	RJMP _0x7F
_0x7E:
	CPI  R17,42
	BRNE _0x80
; 0000 0134       clear();
	RCALL _clear
; 0000 0135     }else{
	RJMP _0x81
_0x80:
; 0000 0136       currentUser.id[cursor] = pressedKey;
	CALL SUBOPT_0xA
; 0000 0137       put(pressedKey);
; 0000 0138     }
_0x81:
_0x7F:
; 0000 0139 
; 0000 013A     break;
	RJMP _0x66
; 0000 013B     case ADMIN_ADD_PASS:
_0x7D:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x82
; 0000 013C     pressedKey = getKey();
	CALL SUBOPT_0x9
; 0000 013D 
; 0000 013E     if (pressedKey == '#') {
	BRNE _0x83
; 0000 013F       cursor = 0;
	CLR  R6
	CLR  R7
; 0000 0140       if(freeUserIndex < MAX_USER)
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x84
; 0000 0141         addUser(currentUser);
	LDI  R30,LOW(_currentUser)
	LDI  R31,HIGH(_currentUser)
	LDI  R26,8
	CALL __PUTPARL
	RCALL _addUser
; 0000 0142       else{
	RJMP _0x85
_0x84:
; 0000 0143         lcd_clear();
	CALL _lcd_clear
; 0000 0144         lcd_puts("full");
	__POINTW2MN _0x7C,14
	CALL _lcd_puts
; 0000 0145         delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0146       }
_0x85:
; 0000 0147       state = ADMIN_MENU;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R4,R30
; 0000 0148     }else if (pressedKey == '*') {
	RJMP _0x86
_0x83:
	CPI  R17,42
	BRNE _0x87
; 0000 0149       clear();
	RCALL _clear
; 0000 014A     }else{
	RJMP _0x88
_0x87:
; 0000 014B       currentUser.password[cursor] = pressedKey;
	CALL SUBOPT_0xB
; 0000 014C       put('*');
; 0000 014D     }
_0x88:
_0x86:
; 0000 014E     break;
	RJMP _0x66
; 0000 014F     case ADMIN_DEL_CHECK:
_0x82:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x89
; 0000 0150     pressedKey = getKey();
	CALL SUBOPT_0x9
; 0000 0151     if (pressedKey == '#') {
	BRNE _0x8A
; 0000 0152       cursor = 0;
	CLR  R6
	CLR  R7
; 0000 0153       delUser(currentUser);
	LDI  R30,LOW(_currentUser)
	LDI  R31,HIGH(_currentUser)
	LDI  R26,8
	CALL __PUTPARL
	RCALL _delUser
; 0000 0154       state = ADMIN_MENU;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R4,R30
; 0000 0155     }else if (pressedKey == '*') {
	RJMP _0x8B
_0x8A:
	CPI  R17,42
	BRNE _0x8C
; 0000 0156       clear();
	RCALL _clear
; 0000 0157     }else{
	RJMP _0x8D
_0x8C:
; 0000 0158       currentUser.id[cursor] = pressedKey;
	CALL SUBOPT_0xA
; 0000 0159       put(pressedKey);
; 0000 015A     }
_0x8D:
_0x8B:
; 0000 015B     break;
	RJMP _0x66
; 0000 015C     case ADMIN_CNT_CHECK:
_0x89:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x66
; 0000 015D     pressedKey = getKey();
	RCALL _getKey
	MOV  R17,R30
; 0000 015E 
; 0000 015F     if (pressedKey == '1') {
	CPI  R17,49
	BRNE _0x8F
; 0000 0160       access = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0xC
; 0000 0161       writeData();
; 0000 0162       lcd_clear();
; 0000 0163       lcd_puts("successful");
	__POINTW2MN _0x7C,19
	RJMP _0xBB
; 0000 0164       delay_ms(1000);
; 0000 0165       state = ADMIN_MENU;
; 0000 0166     }else if (pressedKey == '2') {
_0x8F:
	CPI  R17,50
	BRNE _0x91
; 0000 0167       access = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xC
; 0000 0168       writeData();
; 0000 0169       lcd_clear();
; 0000 016A       lcd_puts("successful");
	__POINTW2MN _0x7C,30
	RJMP _0xBB
; 0000 016B       delay_ms(1000);
; 0000 016C       state = ADMIN_MENU;
; 0000 016D     }else if (pressedKey == '3') {
_0x91:
	CPI  R17,51
	BRNE _0x93
; 0000 016E       access = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xC
; 0000 016F       writeData();
; 0000 0170       lcd_clear();
; 0000 0171       lcd_puts("successful");
	__POINTW2MN _0x7C,41
	RJMP _0xBB
; 0000 0172       delay_ms(1000);
; 0000 0173       state = ADMIN_MENU;
; 0000 0174     }else if (pressedKey == '*') {
_0x93:
	CPI  R17,42
	BREQ _0xBC
; 0000 0175       state = ADMIN_MENU;
; 0000 0176     }else{
; 0000 0177       lcd_clear();
	CALL _lcd_clear
; 0000 0178       lcd_puts("invalid input");
	__POINTW2MN _0x7C,52
_0xBB:
	CALL _lcd_puts
; 0000 0179       delay_ms(1000);
	CALL SUBOPT_0x3
; 0000 017A       state = ADMIN_MENU;
_0xBC:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R4,R30
; 0000 017B     }
; 0000 017C     break;
; 0000 017D   }
_0x66:
; 0000 017E }
	LD   R17,Y+
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

	.DSEG
_0x7C:
	.BYTE 0x42
;
;void main(void) {
; 0000 0180 void main(void) {

	.CSEG
_main:
; .FSTART _main
; 0000 0181   // Declare your local variables here
; 0000 0182 
; 0000 0183   // Input/Output Ports initialization
; 0000 0184   // Port A initialization
; 0000 0185   // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0186   DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0187   // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0188   PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0189 
; 0000 018A   // Port B initialization
; 0000 018B   // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 018C   DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 018D   // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 018E   PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 018F 
; 0000 0190   // Port C initialization
; 0000 0191   // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0192   DDRC=(1<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(135)
	OUT  0x14,R30
; 0000 0193   // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0194   PORTC=(0<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(120)
	OUT  0x15,R30
; 0000 0195 
; 0000 0196   // Port D initialization
; 0000 0197   // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0198   DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0199   // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 019A   PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 019B 
; 0000 019C   // Timer/Counter 0 initialization
; 0000 019D   // Clock source: System Clock
; 0000 019E   // Clock value: Timer 0 Stopped
; 0000 019F   // Mode: Normal top=0xFF
; 0000 01A0   // OC0 output: Disconnected
; 0000 01A1   TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 01A2   TCNT0=0x00;
	OUT  0x32,R30
; 0000 01A3   OCR0=0x00;
	OUT  0x3C,R30
; 0000 01A4 
; 0000 01A5   // Timer/Counter 1 initialization
; 0000 01A6   // Clock source: System Clock
; 0000 01A7   // Clock value: Timer1 Stopped
; 0000 01A8   // Mode: Normal top=0xFFFF
; 0000 01A9   // OC1A output: Disconnected
; 0000 01AA   // OC1B output: Disconnected
; 0000 01AB   // Noise Canceler: Off
; 0000 01AC   // Input Capture on Falling Edge
; 0000 01AD   // Timer1 Overflow Interrupt: Off
; 0000 01AE   // Input Capture Interrupt: Off
; 0000 01AF   // Compare A Match Interrupt: Off
; 0000 01B0   // Compare B Match Interrupt: Off
; 0000 01B1   TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 01B2   TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 01B3   TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 01B4   TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01B5   ICR1H=0x00;
	OUT  0x27,R30
; 0000 01B6   ICR1L=0x00;
	OUT  0x26,R30
; 0000 01B7   OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01B8   OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01B9   OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01BA   OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01BB 
; 0000 01BC   // Timer/Counter 2 initialization
; 0000 01BD   // Clock source: System Clock
; 0000 01BE   // Clock value: Timer2 Stopped
; 0000 01BF   // Mode: Normal top=0xFF
; 0000 01C0   // OC2 output: Disconnected
; 0000 01C1   ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 01C2   TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 01C3   TCNT2=0x00;
	OUT  0x24,R30
; 0000 01C4   OCR2=0x00;
	OUT  0x23,R30
; 0000 01C5 
; 0000 01C6   // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01C7   TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 01C8 
; 0000 01C9   // External Interrupt(s) initialization
; 0000 01CA   // INT0: On
; 0000 01CB   // INT0 Mode: Rising Edge
; 0000 01CC   // INT1: Off
; 0000 01CD   // INT2: Off
; 0000 01CE   GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 01CF   MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);
	LDI  R30,LOW(3)
	OUT  0x35,R30
; 0000 01D0   MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 01D1   GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 01D2 
; 0000 01D3   // USART initialization
; 0000 01D4   // USART disabled
; 0000 01D5   UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 01D6 
; 0000 01D7   // Analog Comparator initialization
; 0000 01D8   // Analog Comparator: Off
; 0000 01D9   // The Analog Comparator's positive input is
; 0000 01DA   // connected to the AIN0 pin
; 0000 01DB   // The Analog Comparator's negative input is
; 0000 01DC   // connected to the AIN1 pin
; 0000 01DD   ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01DE   SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01DF 
; 0000 01E0   // ADC initialization
; 0000 01E1   // ADC disabled
; 0000 01E2   ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 01E3 
; 0000 01E4   // SPI initialization
; 0000 01E5   // SPI disabled
; 0000 01E6   SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 01E7 
; 0000 01E8   // TWI initialization
; 0000 01E9   // TWI disabled
; 0000 01EA   TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 01EB 
; 0000 01EC   // Alphanumeric LCD initialization
; 0000 01ED   // Connections are specified in the
; 0000 01EE   // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 01EF   // RS - PORTA Bit 1
; 0000 01F0   // RD - PORTA Bit 2
; 0000 01F1   // EN - PORTA Bit 3
; 0000 01F2   // D4 - PORTA Bit 4
; 0000 01F3   // D5 - PORTA Bit 5
; 0000 01F4   // D6 - PORTA Bit 6
; 0000 01F5   // D7 - PORTA Bit 7
; 0000 01F6   // Characters/line: 16
; 0000 01F7   lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 01F8 
; 0000 01F9   // Global enable interrupts
; 0000 01FA   #asm("sei")
	sei
; 0000 01FB   ADMIN_ID[0] = '1';
	LDI  R30,LOW(49)
	STS  _ADMIN_ID,R30
; 0000 01FC   ADMIN_ID[1] = '0';
	LDI  R30,LOW(48)
	__PUTB1MN _ADMIN_ID,1
; 0000 01FD   ADMIN_ID[2] = '0';
	__PUTB1MN _ADMIN_ID,2
; 0000 01FE   ADMIN_ID[3] = '0';
	__PUTB1MN _ADMIN_ID,3
; 0000 01FF   ADMIN_PASS[0] = '1';
	LDI  R30,LOW(49)
	STS  _ADMIN_PASS,R30
; 0000 0200   ADMIN_PASS[1] = '1';
	__PUTB1MN _ADMIN_PASS,1
; 0000 0201   ADMIN_PASS[2] = '1';
	__PUTB1MN _ADMIN_PASS,2
; 0000 0202   ADMIN_PASS[3] = '1';
	__PUTB1MN _ADMIN_PASS,3
; 0000 0203   GUEST_ID[0] = '0';
	LDI  R30,LOW(48)
	STS  _GUEST_ID,R30
; 0000 0204   GUEST_ID[1] = '0';
	__PUTB1MN _GUEST_ID,1
; 0000 0205   GUEST_ID[2] = '0';
	__PUTB1MN _GUEST_ID,2
; 0000 0206   GUEST_ID[3] = '0';
	__PUTB1MN _GUEST_ID,3
; 0000 0207   GUEST_PASS[0] = '0';
	STS  _GUEST_PASS,R30
; 0000 0208   GUEST_PASS[1] = '0';
	__PUTB1MN _GUEST_PASS,1
; 0000 0209   GUEST_PASS[2] = '0';
	__PUTB1MN _GUEST_PASS,2
; 0000 020A   GUEST_PASS[3] = '0';
	__PUTB1MN _GUEST_PASS,3
; 0000 020B   while (1) {
_0x97:
; 0000 020C     switch (state) {
	MOVW R30,R4
; 0000 020D       case IDLE:
	CPI  R30,LOW(0xFFFFFFFF)
	LDI  R26,HIGH(0xFFFFFFFF)
	CPC  R31,R26
	BRNE _0x9D
; 0000 020E       break;
	RJMP _0x9C
; 0000 020F 
; 0000 0210       case INIT:
_0x9D:
	SBIW R30,0
	BRNE _0x9E
; 0000 0211       PORTC.7 = 0;
	CBI  0x15,7
; 0000 0212       lcd_clear();
	RCALL _lcd_clear
; 0000 0213       lcd_puts("loading data...");
	__POINTW2MN _0xA1,0
	RCALL _lcd_puts
; 0000 0214       loadData();
	RCALL _loadData
; 0000 0215       lcd_clear();
	RCALL _lcd_clear
; 0000 0216       lcd_puts("loaded");
	__POINTW2MN _0xA1,16
	RCALL _lcd_puts
; 0000 0217       lcd_clear();
	RCALL _lcd_clear
; 0000 0218       lcd_puts("user id:");
	__POINTW2MN _0xA1,23
	CALL SUBOPT_0xD
; 0000 0219       lcd_gotoxy(0, 1);
; 0000 021A       cursor = 0;
; 0000 021B       state = LOGIN_USER;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 021C       break;
	RJMP _0x9C
; 0000 021D 
; 0000 021E       case LOGIN_PASS_INIT:
_0x9E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA2
; 0000 021F       lcd_clear();
	RCALL _lcd_clear
; 0000 0220       lcd_puts("password:");
	__POINTW2MN _0xA1,32
	CALL SUBOPT_0xD
; 0000 0221       lcd_gotoxy(0, 1);
; 0000 0222       cursor = 0;
; 0000 0223       state = LOGIN_PASS;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
; 0000 0224       break;
	RJMP _0x9C
; 0000 0225       case ADMIN_ADD_PASS_INIT:
_0xA2:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xA3
; 0000 0226       lcd_clear();
	RCALL _lcd_clear
; 0000 0227       lcd_puts("password:");
	__POINTW2MN _0xA1,42
	CALL SUBOPT_0xD
; 0000 0228       lcd_gotoxy(0, 1);
; 0000 0229       cursor = 0;
; 0000 022A       state = ADMIN_ADD_PASS;
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	MOVW R4,R30
; 0000 022B       break;
	RJMP _0x9C
; 0000 022C 
; 0000 022D       case LOGIN_CHECK:
_0xA3:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xA4
; 0000 022E       lcd_clear();
	RCALL _lcd_clear
; 0000 022F       lcd_puts("checking...");
	__POINTW2MN _0xA1,52
	RCALL _lcd_puts
; 0000 0230 
; 0000 0231       switch (authenticate()) {
	RCALL _authenticate
; 0000 0232         case 0:
	SBIW R30,0
	BRNE _0xA8
; 0000 0233         state = LOGIN_ERROR;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0xBD
; 0000 0234         break;
; 0000 0235         case 1:
_0xA8:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xA9
; 0000 0236         state = USER_LOGGED;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0xBD
; 0000 0237         break;
; 0000 0238         case 2:
_0xA9:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA7
; 0000 0239         state = ADMIN_MENU;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
_0xBD:
	MOVW R4,R30
; 0000 023A         break;
; 0000 023B       }
_0xA7:
; 0000 023C       break;
	RJMP _0x9C
; 0000 023D 
; 0000 023E       case LOGIN_ERROR:
_0xA4:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xAB
; 0000 023F       lcd_clear();
	RCALL _lcd_clear
; 0000 0240       lcd_puts("wrong id or password");
	__POINTW2MN _0xA1,64
	CALL SUBOPT_0xE
; 0000 0241       lcd_gotoxy(0, 1);
; 0000 0242       delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	RJMP _0xBE
; 0000 0243       state = INIT;
; 0000 0244       break;
; 0000 0245 
; 0000 0246       case USER_LOGGED:
_0xAB:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xAC
; 0000 0247       lcd_clear();
	RCALL _lcd_clear
; 0000 0248       lcd_puts("checking access");
	__POINTW2MN _0xA1,85
	CALL SUBOPT_0xF
; 0000 0249       delay_ms(1500);
; 0000 024A       lcd_clear();
; 0000 024B 
; 0000 024C       if (access < 2) {
	BRGE _0xAD
; 0000 024D         lcd_puts("access granted");
	__POINTW2MN _0xA1,101
	RCALL _lcd_puts
; 0000 024E         state = DOOR_OPEN;
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	MOVW R4,R30
; 0000 024F       }else {
	RJMP _0xAE
_0xAD:
; 0000 0250         lcd_puts("no access");
	__POINTW2MN _0xA1,116
	RCALL _lcd_puts
; 0000 0251       }
_0xAE:
; 0000 0252       break;
	RJMP _0x9C
; 0000 0253       case GUEST_LOGGED:
_0xAC:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xAF
; 0000 0254       lcd_clear();
	RCALL _lcd_clear
; 0000 0255       lcd_puts("checking access");
	__POINTW2MN _0xA1,126
	CALL SUBOPT_0xF
; 0000 0256       delay_ms(1500);
; 0000 0257       lcd_clear();
; 0000 0258 
; 0000 0259       if (access < 2) {
	BRGE _0xB0
; 0000 025A         lcd_puts("access granted");
	__POINTW2MN _0xA1,142
	RCALL _lcd_puts
; 0000 025B         state = DOOR_OPEN;
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	MOVW R4,R30
; 0000 025C       }else {
	RJMP _0xB1
_0xB0:
; 0000 025D         lcd_puts("no access");
	__POINTW2MN _0xA1,157
	RCALL _lcd_puts
; 0000 025E       }
_0xB1:
; 0000 025F 
; 0000 0260       delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RJMP _0xBE
; 0000 0261       state = INIT;
; 0000 0262       break;
; 0000 0263 
; 0000 0264       case ADMIN_MENU:
_0xAF:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xB2
; 0000 0265       lcd_clear();
	RCALL _lcd_clear
; 0000 0266       lcd_puts("1.open 2.add    3.del 4.ac *.exc");
	__POINTW2MN _0xA1,167
	RCALL _lcd_puts
; 0000 0267       state = ADMIN_CHECK;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R4,R30
; 0000 0268       break;
	RJMP _0x9C
; 0000 0269 
; 0000 026A       case ADMIN_ADD:
_0xB2:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xB3
; 0000 026B       lcd_clear();
	CALL SUBOPT_0x10
; 0000 026C       lcd_gotoxy(0,0);
; 0000 026D       lcd_puts("enter user id:");
	__POINTW2MN _0xA1,200
	RCALL _lcd_puts
; 0000 026E       state = ADMIN_ADD_ID;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	MOVW R4,R30
; 0000 026F       break;
	RJMP _0x9C
; 0000 0270 
; 0000 0271       case ADMIN_DEL:
_0xB3:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xB4
; 0000 0272       lcd_clear();
	CALL SUBOPT_0x10
; 0000 0273       lcd_gotoxy(0,0);
; 0000 0274       lcd_puts("enter user id:");
	__POINTW2MN _0xA1,215
	RCALL _lcd_puts
; 0000 0275       state = ADMIN_DEL_CHECK;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	MOVW R4,R30
; 0000 0276       break;
	RJMP _0x9C
; 0000 0277 
; 0000 0278       case ADMIN_CNT:
_0xB4:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xB5
; 0000 0279       lcd_clear();
	RCALL _lcd_clear
; 0000 027A       lcd_puts("1 public");
	__POINTW2MN _0xA1,230
	RCALL _lcd_puts
; 0000 027B       lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 027C       lcd_puts("2 users only");
	__POINTW2MN _0xA1,239
	CALL SUBOPT_0xE
; 0000 027D       lcd_gotoxy(0,1);
; 0000 027E       lcd_puts("3 none");
	__POINTW2MN _0xA1,252
	RCALL _lcd_puts
; 0000 027F       lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0280       lcd_puts("* back");
	__POINTW2MN _0xA1,259
	RCALL _lcd_puts
; 0000 0281       state = ADMIN_CNT_CHECK;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	MOVW R4,R30
; 0000 0282       break;
	RJMP _0x9C
; 0000 0283 
; 0000 0284       case DOOR_OPEN:
_0xB5:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x9C
; 0000 0285       PORTC.7 = 1;
	SBI  0x15,7
; 0000 0286       delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
_0xBE:
	CALL _delay_ms
; 0000 0287       state = INIT;
	CLR  R4
	CLR  R5
; 0000 0288       break;
; 0000 0289     }
_0x9C:
; 0000 028A   }
	RJMP _0x97
; 0000 028B }
_0xB9:
	RJMP _0xB9
; .FEND

	.DSEG
_0xA1:
	.BYTE 0x10A
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 3
	SBI  0x1B,3
	__DELAY_USB 3
	CBI  0x1B,3
	__DELAY_USB 3
	RJMP _0x20C0004
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	RJMP _0x20C0004
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R13,Y+1
	LDD  R12,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x11
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x11
	LDI  R30,LOW(0)
	MOV  R12,R30
	MOV  R13,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	CP   R13,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R12
	MOV  R26,R12
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20C0004
_0x2000007:
_0x2000004:
	INC  R13
	SBI  0x1B,1
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,1
	RJMP _0x20C0004
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,3
	SBI  0x1A,1
	SBI  0x1A,2
	CBI  0x1B,3
	CBI  0x1B,1
	CBI  0x1B,2
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x12
	CALL SUBOPT_0x12
	CALL SUBOPT_0x12
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 67
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0004:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG
_eeprom_read_block:
; .FSTART _eeprom_read_block
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	__GETWRS 16,17,8
	__GETWRS 18,19,6
_0x2040003:
	CALL SUBOPT_0x13
	BREQ _0x2040005
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOVW R26,R18
	__ADDWRN 18,19,1
	CALL __EEPROMRDB
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x2040003
_0x2040005:
	RJMP _0x20C0002
; .FEND
_eeprom_write_block:
; .FSTART _eeprom_write_block
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	__GETWRS 16,17,6
	__GETWRS 18,19,8
_0x2040006:
	CALL SUBOPT_0x13
	BREQ _0x2040008
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	POP  R26
	POP  R27
	CALL __EEPROMWRB
	RJMP _0x2040006
_0x2040008:
_0x20C0002:
	CALL __LOADLOCR4
_0x20C0003:
	ADIW R28,10
	RET
; .FEND

	.CSEG
_memcpy:
; .FSTART _memcpy
	ST   -Y,R27
	ST   -Y,R26
    ldd  r25,y+1
    ld   r24,y
    adiw r24,0
    breq memcpy1
    ldd  r27,y+5
    ldd  r26,y+4
    ldd  r31,y+3
    ldd  r30,y+2
memcpy0:
    ld   r22,z+
    st   x+,r22
    sbiw r24,1
    brne memcpy0
memcpy1:
    ldd  r31,y+5
    ldd  r30,y+4
_0x20C0001:
	ADIW R28,6
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_ADMIN_PASS:
	.BYTE 0x4
_ADMIN_ID:
	.BYTE 0x4
_GUEST_ID:
	.BYTE 0x4
_GUEST_PASS:
	.BYTE 0x4

	.ESEG
_eaccess:
	.DB  0x0,0x0

	.DSEG
_currentUser:
	.BYTE 0x8
_users:
	.BYTE 0x50

	.ESEG
_eusers:
	.BYTE 0x50

	.DSEG
__base_y_G100:
	.BYTE 0x4
__lcd_maxx:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4:
	MOVW R30,R16
	CALL __LSLW3
	MOVW R26,R30
	SUBI R30,LOW(-_users)
	SBCI R31,HIGH(-_users)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R26
	SUBI R30,LOW(-_eusers)
	SBCI R31,HIGH(-_eusers)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	MOVW R30,R16
	CALL __LSLW3
	SUBI R30,LOW(-_users)
	SBCI R31,HIGH(-_users)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_eaccess)
	LDI  R31,HIGH(_eaccess)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	CALL __LSLW3
	SUBI R30,LOW(-_users)
	SBCI R31,HIGH(-_users)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CALL __LSLW3
	__ADDW1MN _users,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	CALL _getKey
	MOV  R17,R30
	CPI  R17,35
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	MOVW R30,R6
	SUBI R30,LOW(-_currentUser)
	SBCI R31,HIGH(-_currentUser)
	ST   Z,R17
	MOV  R26,R17
	JMP  _put

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	__POINTW1MN _currentUser,4
	ADD  R30,R6
	ADC  R31,R7
	ST   Z,R17
	LDI  R26,LOW(42)
	JMP  _put

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	MOVW R8,R30
	CALL _writeData
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xD:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	CLR  R6
	CLR  R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	CALL _lcd_puts
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
	CALL _lcd_clear
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USB 67
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	ADIW R30,1
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1F4
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__PUTPARL:
	CLR  R27
__PUTPAR:
	ADD  R30,R26
	ADC  R31,R27
__PUTPAR0:
	LD   R0,-Z
	ST   -Y,R0
	SBIW R26,1
	BRNE __PUTPAR0
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
