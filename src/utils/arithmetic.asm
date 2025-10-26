SECTION "Arithmetic operations", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine adds the content of the 16-bit
;; registers BC and DE.
;;
;; INPUT:
;;		BC: 16-bit integer
;;		DE: 16-bit integer
;; OUTPUT:
;;		BC: BC+DE	
;; WARNING: Destroys BC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

add_bc_de::
	ld a, c
	add e
	ld c, a
	ld a, b
	adc d
	ld b,a
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine multiplies the content of the
;; 16-bit register HL by 32
;;
;; INPUT:
;;		HL: 16-bit integer
;; OUTPUT:
;;		HL: 32*HL	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mult_hl_32::
	add hl, hl      ; * 2
    add hl, hl      ; * 4
    add hl, hl      ; * 8
    add hl, hl      ; * 16
    add hl, hl      ; * 32
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This  routine divides the content of the 8-bit 
;; register A by 8.
;;
;; INPUT:
;;		A: 8-bit integer
;; OUTPUT:
;;		A: A/8	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

div_a_by_8::
    srl a
    srl a
    srl a
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine multiples the content of the 8-bit 
;; register A by 8.
;;
;; INPUT:
;;		A: 8-bit integer
;; OUTPUT:
;;		A: A/8	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mult_a_by_8::
	add a      ; * 2
    add a      ; * 4
    add a      ; * 32
	ret