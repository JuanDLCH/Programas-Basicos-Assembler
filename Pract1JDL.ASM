
;PROGRAMA PARA DOS NUMEROS DE UN DIGITO****************************
;**************************************************************************


        .MODEL  SMALL
        .386
        .STACK          ;DEFINIR SEGMENTO DE PILA

        .DATA           ;DEFINIIR SEGMENTO DE DATOS
N1      DB      ?
N2      DB      ?
RES     DW      ?
UNI     DB      ?
DECE    DB      ?
MMEN    DB      10,13,'PROGRAMA PARA CALCULADORA NUMEROS DE UN DIGITO $'
MN1     DB      10,10,13,'INGRESAR NUMERO 1: $'
MN2     DB      10,13,'INGRESAR NUMERO 2: $'
MRES    DB      10,10,13,'MULTIPLICACION: $'

MNOESNUM	DB	10,10,13,'SOLO SE PUEDEN NUMEROS... $'
MSUM	DB     10,10,13,'SUMA: $'
MLESS	DB     10,10,13,'RESTA: $'
MLESSN	DB	10,10,13,'RESTA:    -$'
MDIVICO	DB     10,10,13,'COCIENTE: $'
MDIVIRE	DB     10,10,13,'RESIDUO: $'
MDESEO	DB	10,10,13,'ESCOJA: (+)SUMAR (-)RESTAR (*)MULTIPLICAR (/)DIVIDIR: $ '
MVALIDA	DB	10,10,13,'INGRESE UNA OPCION VALIDA... $'

MSALIR  DB      10,10,13,'DIGITE <S> PARA SALIR: $'
ASCVAL  DB      5 DUP(00H),'$'
BINVAL  DW      0000


        .CODE
        ORG     0000    ;ASEGURAR DESPLAZAMIENTO 0000 PARA EL CS
        JMP     MAIN

;****** DEFINICION DEL SEGMENTO DE DATOS ***********
SEG_DAT:
        MOV     AX,@DATA
        MOV     DS,AX
        RET
;****************************************************

;******* RUTINA PARA MENSAJE *******************************
VIS_MENSAJE:
        MOV     AH,09H
        INT     21H
        RET
;****************************************************

;*****ES UN NUMERO MAYOR**************************
ESNUMERO:
	MOV     DX,OFFSET MNOESNUM
	CALL    VIS_MENSAJE
	CALL	CICLOING	

;****************************************************


;********** INGRESO NUMERO *****************************
INGRESO:
        MOV     AH,01H
        INT     21H
        RET
;**********************************************************

;**********************************************************
INGRESODIG:
	MOV	AH,01H
	INT	21H
;AQUI EVALUO SI ES NUMERO
	CMP     AL,57
        JA      ESNUMERO
        CMP     AL,47
        JNG     ESNUMERO
;HASTA AQUI
	RET
;**********************************************************

;*******ES NUMERO NEGATIVO*******************************
NEGATIVO:
	
	MOV	AL,N2
	SUB     AL,N1

	MOV	BINVAL,AX
	CALL	BINASCII

	MOV	DX,OFFSET MLESSN
	CALL    VIS_MENSAJE
	MOV	DX,OFFSET ASCVAL
	CALL    VIS_MENSAJE
	
        MOV	DX,OFFSET MSALIR
        CALL    VIS_MENSAJE
        CALL    INGRESO
        CMP     AL,'S'
        JE      SALIR
        JMP     CICLOING
;**********************************************************

;**********************************************************
SALIR:  MOV     AH,4CH
        INT     21H
	RET
;**********************************************************

;**********************************************************
BINASCII:       
	LEA     SI,ASCVAL
        MOV     CX,5
        MOV     AL,00H
C10:    MOV     [SI],AL
        INC     SI
        LOOP    C10
        MOV     CX,10
        LEA     SI,ASCVAL+4
        MOV     AX,BINVAL
C20:    CMP     AX,CX
        JB      C30
        XOR     DX,DX
        DIV     CX
        OR      DL,30H
        MOV     [SI],DL
        DEC     SI
        JMP     C20
C30:    OR      AL,30H
        MOV     [SI],AL
        RET
;**********************************************************

;*********** PROGRAMA PRINCIPAL *************************
MAIN:   CALL    SEG_DAT
CICLOING:
        MOV     DX,OFFSET MMEN
	CALL    VIS_MENSAJE

	MOV     DX,OFFSET MDESEO
	CALL    VIS_MENSAJE
	CALL    INGRESO
	CMP     AL,'+'
        JE      SUMA
	CMP     AL,'-'
        JE      RESTA
	CMP     AL,'*'
        JE      MULTI
	CMP     AL,'/'
        JE      DIVI
	
	MOV     DX,OFFSET MVALIDA
	CALL    VIS_MENSAJE
	JMP    CICLOING

MULTI:  MOV     DX,OFFSET MN1
	CALL    VIS_MENSAJE
        CALL    INGRESODIG
	MOV	N1,AL

        MOV	DX,OFFSET MN2
	CALL    VIS_MENSAJE
        CALL    INGRESODIG
	MOV	N2,AL

        MOV     AH,0
	MOV	AL,N1

	MUL     N2

	MOV	BINVAL,AX
	CALL	BINASCII

	MOV	DX,OFFSET MRES
	CALL    VIS_MENSAJE
	MOV	DX,OFFSET ASCVAL
	CALL    VIS_MENSAJE
	
        MOV	DX,OFFSET MSALIR
        CALL    VIS_MENSAJE
        CALL    INGRESO
        CMP     AL,'S'
        JE      SALIR
        JMP     CICLOING

RESTA:	MOV     DX,OFFSET MN1
	CALL    VIS_MENSAJE
        CALL    INGRESODIG
	MOV	N1,AL

        MOV	DX,OFFSET MN2
	CALL    VIS_MENSAJE
        CALL    INGRESODIG
	MOV	N2,AL

        MOV     AH,0
        
	MOV	AL,N1
	CMP     AL,N2
        JNGE    NEGATIVO
	
	
        SUB     AL,N2

	MOV	BINVAL,AX
	CALL	BINASCII

	MOV	DX,OFFSET MLESS
	CALL    VIS_MENSAJE
	MOV	DX,OFFSET ASCVAL
	CALL    VIS_MENSAJE
	
        MOV	DX,OFFSET MSALIR
        CALL    VIS_MENSAJE
        CALL    INGRESO
        CMP     AL,'S'
        JE      SALIR
        JMP     CICLOING

SUMA:	MOV     DX,OFFSET MN1
	CALL    VIS_MENSAJE
        CALL    INGRESODIG
        AND     AL,0FH          ;CONVERSION DE ASCII A HEX
	MOV	N1,AL

        MOV	DX,OFFSET MN2
	CALL    VIS_MENSAJE
        CALL    INGRESODIG
        AND     AL,0FH          ;CONVERSION DE ASCII A HEX
	MOV	N2,AL

        MOV     AH,0
	MOV	AL,N1
        ADD     AL,N2
        AAM
	OR      AX,3030H        ;CONVERSION DE HEX A ASCII
        MOV     DECE,AH
        MOV     UNI,AL
        MOV     DX,OFFSET MSUM
        CALL    VIS_MENSAJE
        MOV     DL,DECE
        MOV     AH,02H
        INT     21H
        MOV     DL,UNI
        MOV     AH,02H
        INT     21H
	
        MOV	DX,OFFSET MSALIR
        CALL    VIS_MENSAJE
        CALL    INGRESO
        CMP     AL,'S'
        JE      SALIR
        JMP     CICLOING

DIVI:	MOV     DX,OFFSET MN1
	CALL    VIS_MENSAJE
        CALL    INGRESODIG
	MOV	N1,AL

        MOV	DX,OFFSET MN2
	CALL    VIS_MENSAJE
        CALL    INGRESODIG
	MOV	N2,AL


        MOV     AH,0
	MOV	AL,N1
        DIV     N2
	MOV	AH,0

        MOV     BINVAL, AX
        CALL	BINASCII

	MOV	DX,OFFSET MDIVICO
	CALL    VIS_MENSAJE
	MOV	DX,OFFSET ASCVAL
	CALL    VIS_MENSAJE
	
	
	MOV     AH,0
	MOV	AL,N1
        DIV     N2
	MOV	AL,AH
	MOV	AH,0

	MOV	BINVAL,AX
	CALL	BINASCII

	MOV	DX,OFFSET MDIVIRE
	CALL    VIS_MENSAJE
	MOV	DX,OFFSET ASCVAL
	CALL    VIS_MENSAJE
	

        MOV	DX,OFFSET MSALIR
        CALL    VIS_MENSAJE
        CALL    INGRESO
        CMP     AL,'S'
        JE      SALIR
        JMP     CICLOING


        END
