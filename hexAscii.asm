TITLE mult: prova scritta 12 luglio 2018 

comment *
	Scrivere un programma in linguaggio Assembly 8086 che consenta di convertire un buffer
        CHARHEX di 64 caratteri ASCII (8 bit) tratti dall’alfabeto dei simboli esadecimali {‘0’, ‘1’,
        ‘2’, ‘3’, ‘4’, ‘5’, ‘6’, ‘7’, ‘8’, ‘9’, ‘A’, ‘B’, ‘C’, ‘D’, ‘E’, ‘F’} nel buffer INTHEX, composto
        di 32 interi senza segno, ognuno dei quali `e la ricodifica intera di una coppia di caratteri
        consecutivi di CHARHEX. Esempio: la coppia ‘3’, ‘B’ `e ricodificata nel numero 59.

*

;-----------------------------------------------------------------
; Definizione costanti
CR EQU 13                      ; carriage return
LF EQU 10                      ; line feed
DOLLAR EQU '$'


;-----------------------------------------------------------------
;    M  A  C  R  O
;-----------------------------------------------------------------

display macro xxxx                 ; N.B. ogni stringa deve terminare con '$' 
        push dx
	push ax
	mov dx,offset xxxx
	mov ah,9
	int 21h
	pop ax
     pop dx
endm



;-----------------------------------------------------------------
;
PILA SEGMENT STACK 'STACK'     ; definizione del segmento di stack
      DB      16 DUP('STACK')  ; lo stack e' riempito con la stringa 'stack'
                               ; per identificarlo meglio in fase di debug
PILA ENDS                      

;-----------------------------------------------------------------
;
DATI SEGMENT PUBLIC 'DATA'          ; definizione del segmento dati

CHARHEX      DB 64 DUP('B') ; vettore di B
INTHEX       DB 32


crlf db cr,lf,dollar

DATI ENDS  
 

;=================================================================

CSEG SEGMENT PUBLIC 'CODE'

MAIN proc far
        ASSUME CS:CSEG,DS:DATI,SS:PILA,ES:NOTHING;

        MOV AX,SEG DATI
        MOV DS,AX
        display crlf     ; stampa a video della stringa iniziale
        display CHARHEX 

        xor ax,ax
        xor bx,bx
        xor si,si
        xor di,di
ciclo:
        test si , 64
        jmp exit
        mov dl , CHARHEX[si]

        test dl , 4
        jz quattro

tre:
        mov dl,CHARHEX[si]
        jmp controllo
quattro:
        mov dl,CHARHEX[si]
        add dl,9
        jmp controllo
pari:
        mov al, 16
        mul dl   
        mov INTHEX[di],dl
        add di,1
        add si,1
controllo:
        test si,1
        jp pari
dispari:    
        add INTHEX[di],dl
        add si,1
        jmp ciclo

       
exit: 
       
        MOV AH,4CH              ; ritorno al DOS
        INT 21H

main endp

cseg ends

END MAIN                     ; il programma comincia all'indirizzo di MAIN




                         
