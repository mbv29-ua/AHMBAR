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

add_bc_de::
	ld a, c
	add e
	ld c, a
	ld a, b
	adc d
	ld b,a
	ret