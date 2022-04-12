;
; USART_ASM.asm
;
; Created: 03.04.2022 21:58:50
; Author : ZM
;


; Replace with your application code
.org $000
	rjmp	 INIT
.org $01A
	rjmp	USART_RXC
.org $01C
	rjmp	USART_UDRE
.org $01E
	rjmp	USART_TXC
;==============================INITIALIZE==============================
INIT: 
	ldi		r16, LOW(RAMEND)
	out		SPL, r16
	ldi		r16, HIGH(RAMEND)
	out		SPH, r16

	ldi		r16, (1 << TXEN) | (1 << UDRIE) | (1 << TXCIE)
	out		UCSRB, r16
	ldi		r16, (1 << UCSZ1) | (1 << UCSZ0) | (1 << URSEL)
	out		UCSRC, r16
	ldi		r16, 0x33
	out		UBRRL, r16
	sei
;==============================MAIN_LOOP===============================
MAIN_LOOP:
	rjmp	MAIN_LOOP

USART_RXC:
	reti

USART_UDRE:
	ldi		ZH, HIGH(2 * WORDS)
	ldi		ZL, LOW(2 * WORDS)
	add		ZL, r17
	lpm
	inc		r17
	cpi		r17, 5
	brne		LABEL_01
	clr		r17
	ldi		r16, (0 << TXEN) | (0 << UDRE)
	out		UCSRB, r16
	reti

LABEL_01:
	mov		r16, r0
	out		UDR, r16

USART_TXC:
	reti
;==============================WORDS===================================
WORDS:		.db		"Test"
