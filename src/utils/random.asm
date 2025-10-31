SECTION "Pseudo-random number", WRAM0

wRandomNumber:: DS 2

SECTION "Pseudo-random number generator", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine generates a random number calling
;; the specified routine.
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A and B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

generate_random_number::
	call fibonacci_LFSR_PRNG
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine implements the Fibonacci LFSR PRNG.
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A and B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fibonacci_LFSR_PRNG::
	;; We load in BC the content of [wRandomNumber]
	ld hl, wRandomNumber
	ld b, [hl]
	inc l
	ld c, [hl]

	;; We add bits 15, 13, 12 and 10 (7, 5, 4 and 2 of B) 
	xor a
	.bit15:
		bit 7, b
		jr z, .bit13
		xor 1 ; xor is the sum in F2

	.bit13:
		bit 5, b
		jr z, .bit12
		xor 1 ; xor is the sum in F2

	.bit12:
		bit 4, b
		jr z, .bit10
		xor 1 ; xor is the sum in F2

	.bit10:
		bit 2, b
		jr z, .shift_and_add
		xor 1 ; xor is the sum in F2

	.shift_and_add:
		call multiply_bc_by_2
		add c ; a+c
		ld c, a

	ld hl, wRandomNumber
	ld [hl], b
	inc l
	ld [hl], c	
	ret
